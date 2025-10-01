import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medicalservic/admin_home_screen.dart';
import 'package:medicalservic/user_home_screen.dart';

import 'package:medicalservic/utils/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isRegister = false;

  final List<Map<String, String>> hardcodedUsers = [
    {"email": "admin@gmail.com", "password": "123123", "role": "admin"},
    {"email": "user1@gmail.com", "password": "123123", "role": "user"},
    {"email": "user2@gmail.com", "password": "123123", "role": "user"},
  ];

  Future<bool> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // Hardcoded check
    final hardUser = hardcodedUsers.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );
    if (hardUser.isNotEmpty) {
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_email', hardUser['email']!);
      await prefs.setString('user_role', hardUser['role']!);
      return true;
    }

    // Registered users check
    List<String> users = prefs.getStringList('users') ?? [];
    final user = users
        .map((u) => jsonDecode(u))
        .firstWhere(
          (u) => u['email'] == email && u['password'] == password,
          orElse: () => null,
        );
    if (user != null) {
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_email', user['email']);
      await prefs.setString('user_role', user['role']);
      return true;
    }
    return false;
  }

  Future<bool> registerUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList('users') ?? [];

    bool exists = users.any((u) {
      final data = jsonDecode(u);
      return data['email'] == email;
    });
    if (exists) return false;

    final newUser = {"email": email, "password": password, "role": "user"};
    users.add(jsonEncode(newUser));
    await prefs.setStringList('users', users);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
          child: Column(
            children: [
              // Logo
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 40,
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                isRegister ? "Register" : "Login",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blueDark,
                ),
              ),
              const SizedBox(height: 20),

              // Email Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(
                    Icons.email,
                    color: AppColors.blueDark,
                  ),
                  filled: true,
                  fillColor: AppColors.blueLight.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Password Field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock, color: AppColors.blueDark),
                  filled: true,
                  fillColor: AppColors.blueLight.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Action Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blueDark,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Email & Password required"),
                      ),
                    );
                    return;
                  }

                  if (isRegister) {
                    bool registered = await registerUser(email, password);
                    if (registered) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("User registered successfully"),
                        ),
                      );
                      setState(() => isRegister = false);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User already exists")),
                      );
                    }
                  } else {
                    bool success = await loginUser(email, password);
                    if (success) {
                      emailController.clear();
                      passwordController.clear();

                      final prefs = await SharedPreferences.getInstance();
                      String role = prefs.getString('user_role') ?? 'user';

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  role == 'admin'
                                      ? const AdminHomeScreen()
                                      : const UserHomeScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid email or password"),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  isRegister ? "Register" : "Login",
                  style: const TextStyle(color: AppColors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),

              // Toggle
              TextButton(
                onPressed: () {
                  setState(() => isRegister = !isRegister);
                },
                child: Text(
                  isRegister
                      ? "Already have an account? Login"
                      : "New user? Register here",
                  style: const TextStyle(color: AppColors.blueDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
