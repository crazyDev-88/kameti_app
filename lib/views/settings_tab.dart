import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kameti_app/views/auth/admin_login.dart';
import 'package:provider/provider.dart';

import '../viewmodels/admin_viewmodel.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vm = Provider.of<AdminViewModel>(context, listen: false);
    _amountController.text = vm.monthlyAmount.toStringAsFixed(2);
  }

  void _updateAmount(BuildContext context, AdminViewModel vm) {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showSnackBar(context, 'Please enter a valid amount');
      return;
    }
    vm.updateAmount(amount);
    _showSnackBar(context, 'Monthly amount updated');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AdminViewModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monthly Contribution Amount (€):', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter monthly amount',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _updateAmount(context, vm),
            child: const Text('Save'),
          ),
          ElevatedButton(
            onPressed: () async {
              await Provider.of<AdminViewModel>(context, listen: false).exportDataToFile();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup exported successfully')),
              );
            },
            child: const Text('Export Data'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              await Provider.of<AdminViewModel>(context, listen: false).importDataFromFile();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup imported successfully')),
              );
            },
            child: const Text('Import Data'),
          ),
        ],
      ),
    );
  }
}
