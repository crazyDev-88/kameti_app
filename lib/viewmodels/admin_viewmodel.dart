import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/date_utils.dart';
import '../data/models/payout_model.dart';
import '../data/models/user_model.dart';
import '../data/local/local_storage.dart';

class AdminViewModel extends ChangeNotifier {
  final LocalStorage _storage = LocalStorage();
  List<UserModel> users = [];
  List<PayoutModel> payouts = [];
  double monthlyAmount = AppConstants.defaultMonthlyAmount;
  String get currentMonthKey => DateHelper.getCurrentMonthKey();

  Future<void> initialize() async {
    users = await _storage.loadUsers();
    payouts = await _storage.loadPayouts();
    monthlyAmount = await _storage.loadAmount();

    final currentMonth = DateHelper.getCurrentMonthKey();
    final lastReset = await _storage.getLastReset();

    // ✅ Reset payments at new month
    if (lastReset == null || !DateHelper.isSameMonth(lastReset, currentMonth)) {
      _resetPayments();
      await _storage.setLastReset(currentMonth);
    }
    notifyListeners();
  }

  // ✅ Add new user with validation and unique ID
  void addUser(String name) {
    if (name.isEmpty) return;
    if (users.any((u) => u.name.toLowerCase() == name.toLowerCase())) return;

    final newUser = UserModel.create(name); // 🔹 Uses factory constructor to generate unique ID
    users.add(newUser);

    _storage.saveUsers(users);
    notifyListeners();
  }

  // ✅ Toggle payment for current month
  void togglePayment(int index) {
    final currentMonth = DateHelper.getCurrentMonthKey();
    users[index].markPaid(currentMonth);
    _storage.saveUsers(users);
    notifyListeners();
  }

  // ✅ Update monthly contribution amount
  void updateAmount(double amount) {
    monthlyAmount = amount;
    _storage.saveAmount(amount);
    notifyListeners();
  }

  // ✅ Reset all user payments at the start of each month
  void _resetPayments() {
    for (var user in users) {
      user.hasPaid = false;
    }
    _storage.saveUsers(users);
  }

  // ✅ Perform payout to selected user
  void payoutToUser(UserModel user) {
    final currentMonth = DateHelper.getCurrentMonthKey();
    final payout = PayoutModel(
      userId: user.id,
      userName: user.name,
      monthKey: currentMonth,
      amount: monthlyAmount * users.length,
      date: DateTime.now(),
    );

    payouts.add(payout);
    _storage.savePayout(payout);
    notifyListeners();
  }

  // ✅ Check if payout for current month is already done
  bool isPayoutDone(String monthKey) {
    return payouts.any((p) => p.monthKey == monthKey);
  }

  // ✅ Get current month payout info
  PayoutModel? getCurrentMonthPayout() {
    final currentMonth = DateHelper.getCurrentMonthKey();
    return payouts.firstWhere(
      (p) => p.monthKey == currentMonth,
      orElse: () => PayoutModel(
        userId: '',
        userName: '',
        monthKey: '',
        amount: 0,
        date: DateTime.now(),
      ),
    );
  }

  // ✅ Helper to check if all users have paid
  bool get allUsersPaid {
    return users.isNotEmpty && users.every((u) => u.hasPaid);
  }

  // ✅ Calculate total collected amount for current month
  double get totalCollected => users.where((u) => u.hasPaid).length * monthlyAmount;


  /// Returns a map of monthKey -> Map<userId, paidStatus>
  /// Example:
  /// {
  ///   '2025-08': { 'u1': true, 'u2': false },
  ///   '2025-07': { 'u1': true, 'u2': true },
  /// }
  Map<String, Map<String, bool>> getMonthlyPaymentsStatus() {
    final Map<String, Map<String, bool>> history = {};

    for (var user in users) {
      user.paymentHistory.forEach((month, paid) {
        history.putIfAbsent(month, () => {});
        history[month]![user.id] = paid;
      });
    }

    // Sort by month descending (most recent first)
    final sortedEntries = history.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return Map.fromEntries(sortedEntries);
  }

  bool allUsersPaidForMonth(String monthKey) {
    return users.isNotEmpty && users.every((u) => u.hasPaidForMonth(monthKey));
  }

}
