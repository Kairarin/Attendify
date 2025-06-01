// File: lib/screens/AttendanceHistory.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/User.dart';

class AttendanceMonitoringPage extends StatefulWidget {
  const AttendanceMonitoringPage({super.key});

  @override
  State<AttendanceMonitoringPage> createState() =>
      _AttendanceMonitoringPageState();
}

class _AttendanceMonitoringPageState extends State<AttendanceMonitoringPage> {
  String selectedMonth = DateFormat.MMMM().format(DateTime.now());

  final List<String> months = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance History"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: const BackButton(),
      ),

      /// Ganti SingleChildScrollView + Column menjadi ListView
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16).copyWith(bottom: 16),
          children: [
            const Text(
              "Good Afternoon, Dustin Henderson",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat("EEE, dd MMM yyyy").format(DateTime.now()),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // ──────────────────────────────────────────────────────────────────
            // Length of Work & Rest of Leave
            // Gunakan Row dengan Expanded pada kedua kartu
            Row(
              children: [
                _buildInfoCard("Length of work", "0.22", "Year"),
                const SizedBox(width: 12),
                _buildInfoCard("Rest of leave", "1", "Day"),
              ],
            ),
            const SizedBox(height: 20),

            // ──────────────────────────────────────────────────────────────────
            // Attendance Summary
            const Text(
              "Attendance this month",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildSummaryBox("18", "Present"),
                _buildSummaryBox("0", "Late"),
                _buildSummaryBox("0", "Leave"),
                _buildSummaryBox("0", "Alpha"),
              ],
            ),
            const SizedBox(height: 20),

            // ──────────────────────────────────────────────────────────────────
            // Device Log Today
            const Text(
              "Device log today",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildLogBox("Check In", "06:58"),
                _buildLogBox("Check Out", "17:00"),
                _buildLogBox("Break Out", "12:00"),
                _buildLogBox("Break In", "13:00"),
              ],
            ),
            const SizedBox(height: 20),

            // ──────────────────────────────────────────────────────────────────
            // Month History Dropdown
            const Text(
              "Month history",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedMonth,
              onChanged: (value) {
                setState(() {
                  selectedMonth = value!;
                });
              },
              items:
                  months
                      .map(
                        (month) =>
                            DropdownMenuItem(value: month, child: Text(month)),
                      )
                      .toList(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Contoh: navigasi ke halaman lain jika index berubah
          // if (index == 0) { ... }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Request',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  /// Expanded di dalam Row, jadi kartu akan menyesuaikan lebar masing-masing
  Widget _buildInfoCard(String title, String value, String unit) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              unit,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Expanded di dalam Row, agar semua summary box terbagi rata
  Widget _buildSummaryBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Log box dengan lebar tetap, tetapi tidak memicu overflow Vertikal
  Widget _buildLogBox(String label, String time) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
