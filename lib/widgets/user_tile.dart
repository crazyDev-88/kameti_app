import 'package:flutter/material.dart';
import '../data/models/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onPaidToggle;

  const UserTile({
    super.key,
    required this.user,
    required this.onPaidToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(user.name),
        subtitle: Text(user.hasPaid ? 'Paid this month' : 'Not Paid'),
        trailing: Checkbox(
          value: user.hasPaid,
          onChanged: (_) => onPaidToggle(), // ✅ Required argument added here
        ),
      ),
    );
  }
}
