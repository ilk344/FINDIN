import 'package:hive/hive.dart';
import '../models/transaction.dart';

class TransactionViewModel {
  final _txBox = Hive.box<TransactionModel>('transactions');

  Future<void> addTransaction(TransactionModel tx) async {
    await _txBox.add(tx);
  }

  List<TransactionModel> getUserTransactions(String username) {
    return _txBox.values.where((tx) => tx.username == username).toList();
  }
}
