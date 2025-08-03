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

  /// ✅ Convert object to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'hasPaid': hasPaid,
        'paymentHistory': paymentHistory,
      };

  /// ✅ Create object from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      hasPaid: json['hasPaid'] ?? false,
      paymentHistory: Map<String, bool>.from(json['paymentHistory'] ?? {}),
    );
  }
  // Mark user as paid for current month
  void markPaid(String monthKey) {
    hasPaid = !hasPaid;
    paymentHistory[monthKey] = true;
  }

  void markUnpaid(String monthKey) {
    paymentHistory[monthKey] = false;
  }
}
