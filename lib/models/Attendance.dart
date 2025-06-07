// lib/models/Attendance.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final String id;
  final String userId;
  final String scheduleId;
  final String evidence; // misalnya "lat,lon"
  final Timestamp? createdAt;

  Attendance({
    required this.id,
    required this.userId,
    required this.scheduleId,
    required this.evidence,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'schedule_id': scheduleId,
      'evidence': evidence,
      'created_at': FieldValue.serverTimestamp(),
    };
  }

  // Jika ingin membuat factory dari Firestore, tambahkan juga:
  factory Attendance.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Attendance(
      id: doc.id,
      userId: data['user_id'] as String,
      scheduleId: data['schedule_id'] as String,
      evidence: data['evidence'] as String,
      createdAt: data['created_at'] as Timestamp?,
    );
  }
}
