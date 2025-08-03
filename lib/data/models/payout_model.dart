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

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'userName': userName,
    'monthKey': monthKey,
    'amount': amount,
    'date': date,
  };

  factory PayoutModel.fromMap(Map<String, dynamic> map) => PayoutModel(
    userId: map['userId'],
    userName: map['userName'],
    monthKey: map['monthKey'],
    amount: map['amount'],
    date: map['date'],
  );
}
