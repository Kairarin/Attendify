import 'package:flutter/material.dart';
import 'leave_request_page.dart';
import 'payroll_page.dart';
import 'schedule_page.dart';

void main() => runApp(const HRDashboardApp());

class HRDashboardApp extends StatelessWidget {
  const HRDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainNav(),
    );
  }
}

class MainNav extends StatefulWidget {
  /// initialIndex: 0=Home, 1=Schedule, 2=Profile
  final int initialIndex;
  const MainNav({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainNav> createState() => _MainNavState();
}class _MainNavState extends State<MainNav> {
  late int _selectedIndex;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    SchedulePage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int idx) => setState(() => _selectedIndex = idx);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/// Halaman Home dengan grid button
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.blue,
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Morning,',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('Dustin Henderson',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text('Admin',
                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Grid Buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _DashboardButton(
                    icon: Icons.group,
                    label: 'Employee\nManagement',
                    onTap: () {
                      // nanti implementasi
                    },
                  ),
                  _DashboardButton(
                    icon: Icons.exit_to_app,
                    label: 'Leave\nRequests',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LeaveRequestsPage()),
                      );
                    },
                  ),
                  _DashboardButton(
                    icon: Icons.history,
                    label: 'Attendance\nLogs',
                    onTap: () {
                      // nanti implementasi
                    },
                  ),
                  _DashboardButton(
                    icon: Icons.attach_money,
                    label: 'Payroll',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PayrollPage()),
                      );
                    },
                  ),
                  _DashboardButton(
                    icon: Icons.access_time,
                    label: 'Overtime',
                    onTap: () {
                      // nanti implementasi
                    },
                  ),
                  _DashboardButton(
                    icon: Icons.feedback,
                    label: 'Feedback',
                    onTap: () {
                      // nanti implementasi
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6)],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.black87),
            const SizedBox(height: 12),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// Halaman Profile (placeholder)
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Profile Page')),
      );
}
