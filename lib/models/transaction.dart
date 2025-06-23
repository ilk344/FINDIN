import 'package:hive/hive.dart';
part 'transaction.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String type; // ingreso o egreso

  @HiveField(2)
  double amount;

  @HiveField(3)
  String description;

  @HiveField(4)
  DateTime date;

  TransactionModel({
    required this.username,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  });
}