import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/admin_viewmodel.dart';

class AddUserTab extends StatefulWidget {
  const AddUserTab({super.key});

  @override
  State<AddUserTab> createState() => _AddUserTabState();
}

class _AddUserTabState extends State<AddUserTab> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addUser(BuildContext context, AdminViewModel vm) {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showSnackBar(context, 'User name cannot be empty');
      return;
    }
    if (vm.users.any((u) => u.name.toLowerCase() == name.toLowerCase())) {
      _showSnackBar(context, 'User "$name" already exists');
      return;
    }
    vm.addUser(name);
    _nameController.clear();
    _showSnackBar(context, 'User "$name" added successfully');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AdminViewModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'User Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _addUser(context, vm),
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }
}
