import 'package:flutter/material.dart';
import 'screens/Homepage.dart';
import 'screens/Notification.dart';
import 'screens/ProfilePage.dart';
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
      HomePage(user: widget.user),
      NotificationPage(user: widget.user),
      ProfilePage(user: widget.user),
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
