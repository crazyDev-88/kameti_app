import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/date_utils.dart';

class DashboardHeader extends StatelessWidget {
  final double totalAmount;
  final bool allPaid;

  const DashboardHeader({
    super.key,
    required this.totalAmount,
    required this.allPaid,
  });

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateHelper.getCurrentMonthKey();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: LinearGradient(
            colors: allPaid
                ? [AppColors.pigmentGreen, AppColors.mantis]
                : [AppColors.hookersGreen, AppColors.seaGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Month: $currentMonth',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total: €${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              allPaid
                  ? '✅ All users have paid'
                  : '❌ Waiting for pending payments',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
