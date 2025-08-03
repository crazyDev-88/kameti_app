class PayoutModel {
  final String userId;
  final String userName;
  final String monthKey;
  final double amount;
  final DateTime date;

  PayoutModel({
    required this.userId,
    required this.userName,
    required this.monthKey,
    required this.amount,
    required this.date,
  });

  /// ✅ Convert object to JSON
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'monthKey': monthKey,
        'amount': amount,
        'date': date.toIso8601String(),
      };

  /// ✅ Create object from JSON
  factory PayoutModel.fromJson(Map<String, dynamic> json) {
    return PayoutModel(
      userId: json['userId'],
      userName: json['userName'],
      monthKey: json['monthKey'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }
}
