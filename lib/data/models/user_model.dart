import 'package:uuid/uuid.dart';

class UserModel {
  final String id;
  final String name;
  bool hasPaid;
  Map<String, bool> paymentHistory;

  UserModel({
    required this.id,
    required this.name,
    this.hasPaid = false,
    Map<String, bool>? paymentHistory,
  }) : paymentHistory = paymentHistory ?? {};

  bool hasPaidForMonth(String monthKey){
    return paymentHistory[monthKey] == true;
  }

  // Factory constructor to create user with auto-generated ID
  factory UserModel.create(String name) {
    return UserModel(
      id: const Uuid().v4(), // generate unique ID
      name: name,
      hasPaid: false,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'hasPaid': hasPaid,
        'paymentHistory': paymentHistory,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'],
        name: map['name'],
        hasPaid: map['hasPaid'] ?? false,
        paymentHistory: Map<String, bool>.from(map['paymentHistory'] ?? {}),
      );

  // Mark user as paid for current month
  void markPaid(String monthKey) {
    hasPaid = !hasPaid;
    paymentHistory[monthKey] = true;
  }

  void markUnpaid(String monthKey) {
    paymentHistory[monthKey] = false;
  }
}
