import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/User.dart';

class AttendanceHistoryPage extends StatelessWidget {
  final UserModel user;

  const AttendanceHistoryPage({Key? key, required this.user}) : super(key: key);

  Stream<QuerySnapshot<Map<String, dynamic>>> _attendanceStream() {
    return FirebaseFirestore.instance
        .collection('attendance')
        .where('user_id', isEqualTo: user.uid)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: const BackButton(),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _attendanceStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading attendance.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No attendance records found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final timestamp = (data['created_at'] as Timestamp?)?.toDate();
              final formattedDate =
                  timestamp != null
                      ? DateFormat('EEE, dd MMM yyyy – HH:mm').format(timestamp)
                      : 'Unknown date';
              final evidence = data['evidence'] as String? ?? '-';
              final type = data['type'] as String? ?? '-';
              final scheduleId = data['schedule_id'] as String? ?? '-';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                elevation: 2,
                child: ListTile(
                  leading: Icon(
                    type == 'check_in' ? Icons.login : Icons.logout,
                    color: type == 'check_in' ? Colors.green : Colors.red,
                  ),
                  title: Text(type == 'check_in' ? 'Check-In' : 'Check-Out'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Time: $formattedDate'),
                      const SizedBox(height: 2),
                      Text('Evidence: $evidence'),
                      const SizedBox(height: 2),
                      Text('Schedule ID: $scheduleId'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
