// lib/screens/MeetingSchedule.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/Schedule.dart';

enum ScheduleTab { today, past, upcoming }

class MeetingSchedulePage extends StatefulWidget {
  const MeetingSchedulePage({Key? key}) : super(key: key);

  @override
  State<MeetingSchedulePage> createState() => _MeetingSchedulePageState();
}

class _MeetingSchedulePageState extends State<MeetingSchedulePage> {
  ScheduleTab _selectedTab = ScheduleTab.today;

  @override
  Widget build(BuildContext context) {
    // Hitung tanggal hari ini tanpa jam
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Schedule'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // === Filter Type segmented control ===
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Text(
                  'Filter Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                ToggleButtons(
                  isSelected: [
                    _selectedTab == ScheduleTab.today,
                    _selectedTab == ScheduleTab.past,
                    _selectedTab == ScheduleTab.upcoming,
                  ],
                  onPressed: (index) {
                    setState(() {
                      _selectedTab = ScheduleTab.values[index];
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  selectedBorderColor: Colors.blue,
                  selectedColor: Colors.white,
                  fillColor: Colors.blue,
                  color: Colors.black87,
                  constraints: const BoxConstraints(
                    minHeight: 32,
                    minWidth: 80,
                  ),
                  children: const [
                    Text('Today'),
                    Text('Past'),
                    Text('Upcoming'),
                  ],
                ),
              ],
            ),
          ),

          // === List of schedules ===
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance
                      .collection('schedule')
                      .orderBy('meeting_date')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                final allSchedules =
                    docs.map((doc) => Schedule.fromFirestore(doc)).toList();

                // Pisahkan ke tiga list
                final todayList =
                    allSchedules.where((s) {
                      final d = DateTime(
                        s.meetingDate.year,
                        s.meetingDate.month,
                        s.meetingDate.day,
                      );
                      return d == today;
                    }).toList();

                final pastList =
                    allSchedules.where((s) {
                      final d = DateTime(
                        s.meetingDate.year,
                        s.meetingDate.month,
                        s.meetingDate.day,
                      );
                      return d.isBefore(today);
                    }).toList();

                final upcomingList =
                    allSchedules.where((s) {
                      final d = DateTime(
                        s.meetingDate.year,
                        s.meetingDate.month,
                        s.meetingDate.day,
                      );
                      return d.isAfter(today);
                    }).toList();

                // Pilih sesuai tab
                List<Schedule> filtered;
                switch (_selectedTab) {
                  case ScheduleTab.today:
                    filtered = todayList;
                    break;
                  case ScheduleTab.past:
                    filtered = pastList;
                    break;
                  case ScheduleTab.upcoming:
                    filtered = upcomingList;
                    break;
                }

                if (filtered.isEmpty) {
                  return const Center(child: Text('No schedules found'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final s = filtered[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat(
                              'EEE, dd MMM yyyy',
                            ).format(s.meetingDate),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${s.startTime} – ${s.endTime}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            s.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
