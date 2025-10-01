import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:medicalservic/user_home_screen.dart';
import 'package:medicalservic/utils/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> registerUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email & Password required")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList('users') ?? [];

    bool exists = users.any((u) {
      final map = jsonDecode(u);
      return map['email'] == email;
    });

    if (exists) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User already exists!")));
      return;
    }

    Map<String, String> newUser = {
      'email': email,
      'password': password,
      'role': 'user',
    };
    users.add(jsonEncode(newUser));
    await prefs.setStringList('users', users);

    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_email', email);
    await prefs.setString('user_role', 'user');

    emailController.clear();
    passwordController.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const UserHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', width: 150),
              const SizedBox(height: 20),

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
                onPressed: registerUser,
                child: const Text(
                  "Register",
                  style: TextStyle(color: AppColors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
