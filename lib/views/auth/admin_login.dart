import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/app_colors.dart';
import 'package:local_auth/local_auth.dart';
import '../admin_dashboard.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();
  bool _error = false;

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> _login() async {
    final storedHash = await storage.read(key: 'adminPassword');
    if( storedHash == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Password set. Please restart App')),
      );
      return;
    }

    final inputHash = _hashPassword(_passwordController.text.trim());
    if(inputHash == storedHash){
      await storage.write(key: 'isLoggedIn', value: 'true');
      _navigateToDashboard();
    }else {
      setState(() => _error = true);
    }
    
  }

  Future<void> _tryBiometricLogin() async {
    try {
      bool canCheck = await auth.canCheckBiometrics;
      if (!canCheck) return;

      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticate as Admin",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        await storage.write(key: "isLoggedIn", value: "true");
        _navigateToDashboard();
      }
    } catch (e) {
      debugPrint("Biometric login failed: $e");
    }
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminDashboard()),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), _tryBiometricLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4AAD52),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Admin Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4AAD52),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                      errorText: _error ? "Invalid password" : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primarySwatch,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _login,
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 20,),
                  TextButton(onPressed: _tryBiometricLogin, child: const Text('User Fingerprint / FaceId')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
