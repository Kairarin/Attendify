import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/User.dart';
import '../models/Schedule.dart';

import 'AttendanceHistory.dart';
import 'EmployeeAttendance.dart';
import 'Complain.dart';
import 'MeetingSchedule.dart';
import 'RequestLeave.dart';

class HomePage extends StatelessWidget {
  final UserModel user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good morning';
    if (hour >= 12 && hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMoreOption(
                Icons.feedback,
                'Criticism/ Suggestions',
                context,
              ),
              _buildMoreOption(Icons.qr_code, 'Employee Attendance', context),
              _buildMoreOption(
                Icons.calendar_month,
                'Attendance History',
                context,
              ),
              _buildMoreOption(
                Icons.edit_note,
                'Attendance Correction',
                context,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoreOption(IconData icon, String label, BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        if (label == 'Attendance History') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AttendanceHistoryPage(user: user),
            ),
          );
        } else if (label == 'Employee Attendance') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EmployeeAttendancePage(user: user),
            ),
          );
        }
        // Tambahkan opsi lain sesuai kebutuhan…
      },
    );
  }

  Stream<Schedule?> watchTodaySchedule() {
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return FirebaseFirestore.instance
        .collection('schedule')
        .where('meeting_date', isEqualTo: todayString)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return Schedule.fromFirestore(snapshot.docs.first);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // === HEADER ===
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Kolom Greeting + Nama + Position
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getGreeting(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.nama,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.position,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  // Avatar & Logout
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white24,
                        child: ClipOval(
                          child: Image.network(
                            'https://i.pravatar.cc/150?img=3',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, _, __) => const Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // === WORKING SCHEDULE & tombol CHECK‐IN ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder<Schedule?>(
                stream: watchTodaySchedule(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Loading spinner
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
                        ],
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  final schedule = snapshot.data;
                  if (schedule == null) {
                    // Jika tidak ada jadwal hari ini
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Working Schedule",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "No schedule for today",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              "-- : -- - -- : --",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "No Check In Available",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Jika ada jadwal hari ini → tampilkan detailnya
                  final formattedDate = DateFormat(
                    'EEE, dd MMM yyyy',
                  ).format(schedule.meetingDate);
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Working Schedule",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "${schedule.startTime} - ${schedule.endTime}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          schedule.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => EmployeeAttendancePage(user: user),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Check-In",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // === FEATURE ICONS (justify‐center dengan spaceEvenly) ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Request Leave
                  _featureButton(
                    Icons.assignment,
                    "Request\nLeave",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RequestLeavePage(user: user),
                        ),
                      );
                    },
                  ),

                  // Complain
                  _featureButton(
                    Icons.report_problem,
                    "Complain",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ComplainPage(user: user),
                        ),
                      );
                    },
                  ),

                  // Meeting Schedule
                  _featureButton(
                    Icons.calendar_month,
                    "Meeting\nSchedule",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MeetingSchedulePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // === ATTENDANCE HISTORY (shortcut ke halaman riwayat) ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Attendance",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AttendanceHistoryPage(user: user),
                        ),
                      );
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 2) List of last 3 attendances
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('attendance')
                      .where(
                        'user_id',
                        isEqualTo: user.uid,
                      ) // hanya milik user ini
                      .limit(3)
                      .snapshots(),
              builder: (context, attSnap) {
                if (attSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = attSnap.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("No attendance records yet."),
                  );
                }
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, i) {
                    final att = docs[i];
                    final scheduleId = att.get('schedule_id') as String;
                    // 3) untuk tiap attendance, fetch schedule-nya
                    return FutureBuilder<DocumentSnapshot>(
                      future:
                          FirebaseFirestore.instance
                              .collection('schedule')
                              .doc(scheduleId)
                              .get(),
                      builder: (context, schSnap) {
                        if (schSnap.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(title: Text("Loading…"));
                        }
                        if (!schSnap.hasData || !schSnap.data!.exists) {
                          return const ListTile(
                            title: Text("Schedule data unavailable"),
                          );
                        }
                        final data = schSnap.data!;
                        final meetingDateStr =
                            data.get('meeting_date') as String;
                        final startTime = data.get('start_time') as String;
                        final endTime = data.get('end_time') as String;
                        final meetingDate = DateTime.parse(meetingDateStr);
                        final formattedDate = DateFormat(
                          'dd MMM yyyy',
                        ).format(meetingDate);
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text(formattedDate),
                          subtitle: Text("$startTime - $endTime"),
                          // kalau mau sesuatu saat tap, bisa ditambah onTap
                        );
                      },
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _featureButton(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
