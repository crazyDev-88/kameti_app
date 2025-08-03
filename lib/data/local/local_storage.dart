import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../../data/models/user_model.dart';
import '../../data/models/payout_model.dart';

class LocalStorage {
  static const _usersKey = 'users';
  static const _payoutsKey = 'payouts';
  static const _amountKey = 'monthly_amount';
  static const _lastResetKey = 'last_reset';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// ✅ Save list of users as JSON
  Future<void> saveUsers(List<UserModel> users) async {
    final jsonString = jsonEncode(users.map((u) => u.toJson()).toList());
    await _secureStorage.write(key: _usersKey, value: jsonString);
  }

  /// ✅ Load list of users from JSON
  Future<List<UserModel>> loadUsers() async {
    final jsonString = await _secureStorage.read(key: _usersKey);
    if (jsonString == null) return [];
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((u) => UserModel.fromJson(u)).toList();
  }

  /// ✅ Save payouts as JSON
  Future<void> savePayout(PayoutModel payout) async {
    final existingPayouts = await loadPayouts();
    existingPayouts.add(payout);
    final jsonString = jsonEncode(existingPayouts.map((p) => p.toJson()).toList());
    await _secureStorage.write(key: _payoutsKey, value: jsonString);
  }

  /// ✅ Load payouts from JSON
  Future<List<PayoutModel>> loadPayouts() async {
    final jsonString = await _secureStorage.read(key: _payoutsKey);
    if (jsonString == null) return [];
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((p) => PayoutModel.fromJson(p)).toList();
  }

  /// ✅ Save monthly amount
  Future<void> saveAmount(double amount) async {
    await _secureStorage.write(key: _amountKey, value: amount.toString());
  }

  /// ✅ Load monthly amount
  Future<double> loadAmount() async {
    final value = await _secureStorage.read(key: _amountKey);
    return value != null ? double.tryParse(value) ?? 0 : 0;
  }

  /// ✅ Save last reset month
  Future<void> setLastReset(String monthKey) async {
    await _secureStorage.write(key: _lastResetKey, value: monthKey);
  }

  /// ✅ Get last reset month
  Future<String?> getLastReset() async {
    return await _secureStorage.read(key: _lastResetKey);
  }
}
