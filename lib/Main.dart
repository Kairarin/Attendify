import 'package:flutter/material.dart';

// import semua screen
import 'screens/employee_overtime_screen.dart';
import 'screens/employee_payroll_screen.dart';
import 'screens/attendance_history_screen.dart';
import 'screens/employee_attendance_screen.dart';
import 'screens/request_leave_screen.dart';
import 'screens/career_profiling_screen.dart';
import 'screens/Apps.dart';
import 'screens/failed.dart';
import 'screens/Request.dart';

void main() {
  runApp(const AttendifyApp());
}

class AttendifyApp extends StatelessWidget {
  const AttendifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendify App',
      theme: ThemeData(
        primaryColor: const Color(0xFF22577A),
        scaffoldBackgroundColor: Colors.white,
      ),

      // mulai dari login
      initialRoute: '/',
      routes: {
        // Login sebagai root
        '/': (_) => const LoginScreen(),

        // setelah login, pindah ke Overtime
        '/overtime': (_) => const EmployeeOvertimeScreen(),

        // screen lainnya
        '/payroll': (_) => const EmployeePayrollScreen(),
        '/history': (_) => const AttendanceHistoryScreen(),
        '/attendance': (_) => const EmployeeAttendanceScreen(),
        '/request_leave': (_) => const RequestLeaveScreen(),
        '/career': (_) => const CareerProfilingScreen(),
      },
    );
  }
}

/// ==== LOGIN SCREEN ==== ///
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/LoginImage.jpg',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Attendify App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'LOGIN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'NIK',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // setelah login, ganti ke Overtime
                Navigator.pushReplacementNamed(context, '/overtime');
              },
              child: const Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22577A),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: logic lupa password
              },
              child: const Text(
                'Forget Password?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
