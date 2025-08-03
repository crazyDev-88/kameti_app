import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'views/admin_dashboard.dart';
import 'viewmodels/admin_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminViewModel()),
      ],
      child: MaterialApp(
        title: 'Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: AppColors.primarySwatch,
          scaffoldBackgroundColor: Colors.grey.shade100,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.pigmentGreen,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColors.mantis,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.seaGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(color: Colors.black87),
          ),
        ),
        home: const AdminDashboard(), // ✅ Show Admin Dashboard here
      ),
    );
  }
}
