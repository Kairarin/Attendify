// lib/app.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/Homepage.dart';
import 'screens/Notification.dart'; // ← import baru
import 'screens/ProfilePage.dart';
import 'screens/RequestLeave.dart';
import 'screens/Login.dart';
import 'models/User.dart';
import 'widgets/BottomBar.dart';

class MainScreen extends StatefulWidget {
  final UserModel user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(user: widget.user), // tab 0
      NotificationPage(user: widget.user), // tab 1
      ProfilePage(user: widget.user), // tab 2
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
      ),
    );
  }
}
