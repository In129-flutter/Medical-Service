import 'package:flutter/material.dart';
import 'package:medicalservic/admin_home_screen.dart';
import 'package:medicalservic/loginscreen.dart';
import 'package:medicalservic/registerscreen.dart';
import 'package:medicalservic/user_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Auto-login check
  Future<Widget> getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('is_logged_in') ?? false;
    String? role = prefs.getString('user_role');

    if (loggedIn) {
      if (role == 'admin') return const AdminHomeScreen();
      return const UserHomeScreen();
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  routes: {
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/user': (context) => const UserHomeScreen(),
    '/admin': (context) => const AdminHomeScreen(),
  },
  home: FutureBuilder<Widget>(
    future: getInitialScreen(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return snapshot.data!;
      } else {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
    },
  ),
)
;

  }
}
