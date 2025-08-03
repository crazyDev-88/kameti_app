import 'package:flutter/material.dart';
import 'package:kameti_app/views/admin_dashboard.dart';
import 'package:kameti_app/views/auth/admin_login.dart';
import 'package:kameti_app/views/auth/set_admin_password.dart';
import 'package:kameti_app/views/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/constants/app_colors.dart';
import 'viewmodels/admin_viewmodel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  const storage = FlutterSecureStorage();
  //check if onboarding seen
  final seenOnboarding = await storage.read(key: 'seenOnboarding') == 'true';
  final isLoggedIn = await storage.read(key: 'isLoggedIn') == 'true';
  final hasPassword = await storage.read(key: 'adminPassword') != null;
  Widget startWidget;
  if(!seenOnboarding){
    startWidget = const OnboardingScreen();
  }else if (!hasPassword){
    startWidget = const SetAdminPassword();
  }else {
    startWidget = isLoggedIn ? const AdminDashboard() : const AdminLogin();
  }
  runApp(MyApp(
    startWidget: startWidget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
   return MultiProvider(providers: [ 
      ChangeNotifierProvider(create: (_) => AdminViewModel())
      ], child: MaterialApp(
        title: 'Kameti App',
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
                borderRadius: BorderRadiusGeometry.circular(12),
              )
            )
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(color: Colors.black87),
          )
        ),
        home: startWidget,
      ),
   );
  }
}
