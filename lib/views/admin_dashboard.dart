import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kameti_app/views/auth/admin_login.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../viewmodels/admin_viewmodel.dart';
import 'auth/qr_download_screen.dart';
import 'payment_history_tab.dart';
import 'settings_tab.dart';
import '../widgets/user_tile.dart';  // Assuming you have this for user list UI

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final storage = FlutterSecureStorage();
  int currentIndex = 1; // Center tab (Home) by default

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: currentIndex);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          currentIndex = _tabController.index;
        });
      }
    });
    Future.microtask(() =>
        Provider.of<AdminViewModel>(context, listen: false).initialize());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    await storage.delete(key: 'isLoggedIn');
    // Navigate to login screen and remove all previous routes
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminViewModel>(
      builder: (context, vm, child) {
        final currentMonth = vm.currentMonthKey;
        final totalAmount = vm.users.length * vm.monthlyAmount;
        final allPaid = vm.users.isNotEmpty && vm.users.every((u) => u.hasPaidForMonth(currentMonth));
        final payoutDone = vm.isPayoutDone(currentMonth);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Kameti App'),
            actions: [
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QrDownloadScreen(
                        downloadUrl: "https://yourusername.github.io/yourrepo/app-release.apk",
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        ElevatedButton(
                          child: const Text('Logout'),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await _logout(context);
                  }
                },
              ),
              if (currentIndex == 1) // Only on Dashboard tab
                IconButton(
                  icon: const Icon(Icons.attach_money),
                  onPressed: allPaid && !payoutDone
                      ? () => _showPayoutDialog(context, vm)
                      : null,
                  tooltip: 'Perform Monthly Payout',
                ),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const PaymentHistoryTab(),
              _buildDashboardBody(vm, totalAmount, allPaid),
              const SettingsTab(),
            ],
          ),
          floatingActionButton: currentIndex == 1
              ? FloatingActionButton(
                  onPressed: () => _showAddUserDialog(context),
                  tooltip: 'Add User',
                  child: const Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: ConvexAppBar(
            controller: _tabController,
            style: TabStyle.reactCircle,
            backgroundColor: AppColors.primarySwatch,
            items: const [
              TabItem(title: 'History', icon: Icons.history),
              TabItem(title: 'Dashboard', icon: Icons.dashboard),
              TabItem(title: 'Settings', icon: Icons.settings),
            ],
            onTap: (index) {
              _tabController.animateTo(index);
            },
          ),
        );
      },
    );
  }

  Widget _buildDashboardBody(AdminViewModel vm, double totalAmount, bool allPaid) {
    final currentMonth = vm.currentMonthKey;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard Header - show current month and total amount
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: allPaid ? Colors.green.shade100 : Colors.red.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Month: $currentMonth',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total Amount: €${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: allPaid ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Payout info or button
          vm.isPayoutDone(currentMonth)
              ? Text(
                  'Payout done to: ${vm.getCurrentMonthPayout()?.userName}',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                )
              : ElevatedButton(
                  onPressed: allPaid ? () => _showPayoutDialog(context, vm) : null,
                  child: const Text('Perform Monthly Payout'),
                ),
          const SizedBox(height: 16),
          const Text(
            'User List',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: vm.users.isEmpty
                ? const Center(child: Text('No users added yet'))
                : ListView.builder(
                    itemCount: vm.users.length,
                    itemBuilder: (context, index) {
                      final user = vm.users[index];
                      return UserTile(
                        user: user,
                        onPaidToggle: () => vm.togglePayment(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final vm = Provider.of<AdminViewModel>(context, listen: false);
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Enter user name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                _showSnackBar(context, 'User name cannot be empty');
                return;
              }
              if (vm.users.any((u) => u.name.toLowerCase() == name.toLowerCase())) {
                _showSnackBar(context, 'User "$name" already exists');
                return;
              }
              vm.addUser(name);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showPayoutDialog(BuildContext context, AdminViewModel vm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select User for Payout'),
        content: SizedBox(
          height: 250,
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: vm.users.length,
            itemBuilder: (context, index) {
              final user = vm.users[index];
              return ListTile(
                title: Text(user.name),
                onTap: () {
                  vm.payoutToUser(user);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payout done to ${user.name}')),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
