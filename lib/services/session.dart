import 'package:shared_preferences/shared_preferences.dart';

class Session {
  Future<bool> saveSession(String? username, String customerId, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username!);
    await prefs.setString('name', name);
    return prefs.setString('customer_id', customerId);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<String?> getCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('customer_id');
  }

  Future<bool> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('name');
    return prefs.remove('customer_id');
  }
}
