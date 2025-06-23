import 'package:hive/hive.dart';
import '../models/user.dart';

class AuthViewModel {
  final _userBox = Hive.box<User>('users');

  Future<bool> register(String username, String password) async {
    if (_userBox.containsKey(username)) return false;
    await _userBox.put(username, User(username: username, password: password));
    return true;
  }

  Future<User?> login(String username, String password) async {
    final user = _userBox.get(username);
    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }
}