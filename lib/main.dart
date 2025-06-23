import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user.dart';
import 'models/transaction.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  await Hive.openBox<User>('users');
  await Hive.openBox<TransactionModel>('transactions');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinDin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
        primarySwatch: Colors.teal,
      ),
      home: const WelcomeWithNavbar(),
    );
  }
}

class WelcomeWithNavbar extends StatelessWidget {
  const WelcomeWithNavbar({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/imagenes/imgMenu.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          SafeArea(
            child: Column(
              children: [
                // NAVBAR SUPERIOR
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F2027), Color(0xFF203A43)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.account_balance_wallet_outlined, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'FinDin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => _navigateTo(context, LoginView()),
                            child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () => _navigateTo(context, RegisterView()),
                            child: const Text('Crear cuenta', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // CONTENIDO CENTRAL CON FONDO TRANSPARENTE
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(height: 20),
                              Text(
                                'Tu dinero, bajo control.',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Accede a tus finanzas de forma inteligente, segura y sin complicaciones.',
                                style: TextStyle(fontSize: 16, color: Colors.white70),
                              ),
                              SizedBox(height: 30),
                              Text(
                                'Nuestra aplicación se encarga de almacenar todas y cada una de las ganancias o las pérdidas del usuario con el fin de que este pueda tener un buen manejo de su dinero.\n\n'
                                'La aplicación permite al usuario crear una cuenta, ingresar y agregar cantidades de dinero, así como el tipo (egreso o ingreso), además de un mensaje donde se especifique el motivo de dicho monto. Al final, el usuario podrá ver una lista con todos los montos registrados y un total de los mismos.\n\n'
                                'La aplicación va dirigida a cualquier persona que desee ser consciente de sus pagos, incluso puede ser utilizada como un administrador de gastos en algún emprendimiento pequeño.',
                                style: TextStyle(fontSize: 15, color: Colors.white70, height: 1.5),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
