import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/models/user_model.dart';
import '../../data/models/payout_model.dart';

class LocalStorage {
  static const String _usersKey = 'users';
  static const String _payoutsKey = 'payouts';
  static const String _amountKey = 'monthly_amount';
  static const String _lastResetKey = 'last_reset';

  // ✅ Save users with ID
  Future<void> saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final data = users.map((u) => jsonEncode(u.toMap())).toList();
    await prefs.setStringList(_usersKey, data);
  }

  // ✅ Load users with ID
  Future<List<UserModel>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_usersKey) ?? [];
    return data.map((e) => UserModel.fromMap(jsonDecode(e))).toList();
  }

  // ✅ Save payouts with userId
  Future<void> savePayout(PayoutModel payout) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_payoutsKey) ?? [];
    existing.add(jsonEncode(payout.toMap()));
    await prefs.setStringList(_payoutsKey, existing);
  }

  // ✅ Load payouts with userId
  Future<List<PayoutModel>> loadPayouts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_payoutsKey) ?? [];
    return data.map((e) => PayoutModel.fromMap(jsonDecode(e))).toList();
  }

  // ✅ Save monthly amount
  Future<void> saveAmount(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_amountKey, amount);
  }

  // ✅ Load monthly amount
  Future<double> loadAmount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_amountKey) ?? 200.0;
  }

  // ✅ Save last reset month
  Future<void> setLastReset(String monthKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastResetKey, monthKey);
  }

  // ✅ Get last reset month
  Future<String?> getLastReset() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastResetKey);
  }
}
