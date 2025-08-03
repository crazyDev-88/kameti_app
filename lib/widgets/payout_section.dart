import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/models/user_model.dart';
import '../data/models/payout_model.dart';

class PayoutSection extends StatelessWidget {
  final List<UserModel> users;
  final UserModel? selectedUser;
  final Function(UserModel) onSelectUser;
  final VoidCallback onConfirmPayout;
  final PayoutModel? lastPayout;

  const PayoutSection({
    super.key,
    required this.users,
    required this.selectedUser,
    required this.onSelectUser,
    required this.onConfirmPayout,
    required this.lastPayout,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Payout',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            DropdownButton<UserModel>(
              value: selectedUser,
              hint: const Text('Select user for payout'),
              isExpanded: true,
              items: users.map((user) {
                return DropdownMenuItem(
                  value: user,
                  child: Text(user.name),
                );
              }).toList(),
              onChanged: (user) {
                if (user != null) onSelectUser(user);
              },
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: onConfirmPayout,
              icon: const Icon(Icons.send),
              label: const Text('Confirm Payout'),
            ),

            const SizedBox(height: 12),

            if (lastPayout != null)
              Text(
                '✅ Last payout: ${lastPayout!.userName} - ${lastPayout!.monthKey} (€${lastPayout!.amount.toStringAsFixed(2)})',
                style: const TextStyle(color: AppColors.pear),
              )
            else
              const Text('No payout made yet'),
          ],
        ),
      ),
    );
  }
}
