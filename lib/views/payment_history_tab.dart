import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/payout_model.dart';
import '../viewmodels/admin_viewmodel.dart';

class PaymentHistoryTab extends StatelessWidget {
  const PaymentHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminViewModel>(
      builder: (context, vm, child) {
        final history = vm.getMonthlyPaymentsStatus();

        if (history.isEmpty) {
          return const Center(child: Text('No payment history available.'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: history.entries.map((entry) {
            final monthKey = entry.key;
            final payments = entry.value;

            final payout = vm.payouts.firstWhere(
              (p) => p.monthKey == monthKey,
              orElse: () => PayoutModel(
                userId: '',
                userName: '',
                monthKey: '',
                amount: 0,
                date: DateTime.now(),
              ),
            );

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ExpansionTile(
                title: Text('Month: $monthKey', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: payout.monthKey.isNotEmpty
                    ? Text('Payout done to: ${payout.userName}', style: const TextStyle(color: Colors.green))
                    : const Text('Payout pending', style: TextStyle(color: Colors.red)),
                children: payments.entries.map((e) {
                  final userId = e.key;
                  final paid = e.value;
                  final userName = vm.users.firstWhere((u) => u.id == userId).name;
                  return ListTile(
                    title: Text(userName),
                    trailing: Icon(
                      paid ? Icons.check_circle : Icons.cancel,
                      color: paid ? Colors.green : Colors.red,
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
