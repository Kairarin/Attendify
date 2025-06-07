import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/User.dart';
import '../models/LeaveRequest.dart';

enum RequestStatus { pending, accepted, rejected }

extension RequestStatusExt on RequestStatus {
  String get name {
    switch (this) {
      case RequestStatus.accepted:
        return 'Accepted';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.pending:
      default:
        return 'Pending';
    }
  }

  Color get color {
    switch (this) {
      case RequestStatus.accepted:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.pending:
      default:
        return Colors.orange;
    }
  }
}

class NotificationPage extends StatefulWidget {
  final UserModel user;
  const NotificationPage({Key? key, required this.user}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  RequestStatus _filter = RequestStatus.pending;

  Stream<QuerySnapshot<Map<String, dynamic>>> get _stream =>
      FirebaseFirestore.instance
          .collection('requests')
          .where('user_id', isEqualTo: widget.user.uid)
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // === Filter status ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ToggleButtons(
              isSelected:
                  RequestStatus.values.map((s) => s == _filter).toList(),
              onPressed: (i) {
                setState(() => _filter = RequestStatus.values[i]);
              },
              borderRadius: BorderRadius.circular(20),
              selectedBorderColor: Colors.blue,
              selectedColor: Colors.white,
              fillColor: Colors.blue,
              color: Colors.black87,
              constraints: const BoxConstraints(minHeight: 32, minWidth: 80),
              children: RequestStatus.values.map((s) => Text(s.name)).toList(),
            ),
          ),

          // === List of requests ===
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _stream,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data?.docs ?? [];
                // Map to LeaveRequest + createdAt
                final items =
                    docs
                        .map((doc) {
                          final lr = LeaveRequest.fromFirestore(doc);
                          final ts = doc.get('created_at') as Timestamp?;
                          return MapEntry(lr, ts?.toDate() ?? DateTime.now());
                        })
                        .where((entry) {
                          // filter by status
                          return entry.key.status.toLowerCase() ==
                              _filter.name.toLowerCase();
                        })
                        .toList();

                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${_filter.name} requests',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) {
                    final req = items[i].key;
                    final createdAt = items[i].value;

                    // format "For: ..." teks
                    String forText;
                    if (req.startDate == req.endDate) {
                      forText = DateFormat('dd MMM yyyy').format(req.startDate);
                    } else {
                      forText =
                          '${DateFormat('dd MMM yyyy').format(req.startDate)} – ${DateFormat('dd MMM yyyy').format(req.endDate)}';
                    }

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
                          // baris atas: Reason & creation date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                req.reason,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('dd MMM').format(createdAt),
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Nama user (sama untuk semua)
                          Text(
                            widget.user.nama,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 4),
                          // For: ...
                          Text(
                            'For: $forText',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 8),
                          // status chip di kanan bawah
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _filter.color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _filter.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
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
