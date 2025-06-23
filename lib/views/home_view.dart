import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../view_models/transaction_view_model.dart';
import 'login_view.dart';

class HomeView extends StatefulWidget {
  final String username;
  const HomeView({super.key, required this.username});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TransactionViewModel _txModel = TransactionViewModel();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _description = TextEditingController();
  String _type = 'ingreso';

  @override
  Widget build(BuildContext context) {
    final transactions = _txModel.getUserTransactions(widget.username);
    final total = transactions.fold<double>(
        0,
        (sum, tx) =>
            tx.type == 'ingreso' ? sum + tx.amount : sum - tx.amount);

    return Scaffold(
      backgroundColor: const Color(0xFF2C5364),
      appBar: AppBar(
  backgroundColor: const Color(0xFF203A43), // Color más claro que negro
  title: Text(
    'Bienvenido ${widget.username}',
    style: const TextStyle(fontSize: 20, color: Colors.white),
  ),
  leading: IconButton(
    icon: Image.asset(
      'assets/imagenes/logout.png',
      width: 24,
      height: 24,
      color: Colors.white, // Tinte blanco al ícono
    ),
    tooltip: 'Cerrar sesión',
    onPressed: () async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF203A43),
          title: const Text('¿Cerrar sesión?', style: TextStyle(color: Colors.white, fontSize: 18)),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?', style: TextStyle(color: Colors.white70, fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white70, fontSize: 16)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Cerrar sesión', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        _amount.clear();
        _description.clear();
        setState(() {});
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginView()),
        );
      }
    },
  ),
),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF203A43),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      dropdownColor: const Color(0xFF203A43),
                      value: _type,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      items: const [
                        DropdownMenuItem(
                            value: 'ingreso',
                            child: Text('Ingreso', style: TextStyle(fontSize: 16))),
                        DropdownMenuItem(
                            value: 'egreso',
                            child: Text('Egreso', style: TextStyle(fontSize: 16))),
                      ],
                      onChanged: (val) => setState(() => _type = val!),
                      underline: Container(),
                      iconEnabledColor: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Image.asset('assets/imagenes/opciones.png', width: 24, height: 24),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecciona el tipo de transacción'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ➤ Campos de entrada
            TextField(
              controller: _amount,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto',
                labelStyle: TextStyle(color: Colors.white70, fontSize: 16),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _description,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: const InputDecoration(
                labelText: 'Descripción',
                labelStyle: TextStyle(color: Colors.white70, fontSize: 16),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final tx = TransactionModel(
                    username: widget.username,
                    type: _type,
                    amount: double.tryParse(_amount.text) ?? 0,
                    description: _description.text,
                    date: DateTime.now(),
                  );
                  await _txModel.addTransaction(tx);
                  _amount.clear();
                  _description.clear();
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F2027),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Guardar', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Historial:', style: TextStyle(color: Colors.white70, fontSize: 18)),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: transactions.isEmpty
                  ? const Center(
                      child: Text(
                        'Sin transacciones registradas.',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        return Card(
                          color: const Color(0xFF203A43),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(
                              '${tx.type.toUpperCase()}: \$${tx.amount.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            subtitle: Text(
                              '${tx.description} - ${tx.date.toLocal().toString().split('.')[0]}',
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            trailing: IconButton(
                              icon: Image.asset('assets/imagenes/delete.png', width: 24, height: 24),
                              tooltip: 'Eliminar',
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: const Color(0xFF203A43),
                                    title: const Text('Confirmar eliminación', style: TextStyle(color: Colors.white, fontSize: 18)),
                                    content: const Text('¿Eliminar este registro?', style: TextStyle(color: Colors.white70, fontSize: 16)),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancelar', style: TextStyle(color: Colors.white70, fontSize: 16)),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  await tx.delete();
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
