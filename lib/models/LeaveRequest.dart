import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LeaveRequest {
  final String id;
  final String userId;
  final String reason;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String evidenceUrl;
  final String status;

  LeaveRequest({
    this.id = '',
    required this.userId,
    required this.reason,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.evidenceUrl,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() => {
    'user_id': userId,
    'reason': reason,
    'description': description,
    'start_date': DateFormat('yyyy-MM-dd').format(startDate),
    'end_date': DateFormat('yyyy-MM-dd').format(endDate),
    'evidence': evidenceUrl,
    'status': status,
    'created_at': FieldValue.serverTimestamp(),
  };

  factory LeaveRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LeaveRequest(
      id: doc.id,
      userId: data['user_id'],
      reason: data['reason'],
      description: data['description'],
      startDate: DateTime.parse(data['start_date']),
      endDate: DateTime.parse(data['end_date']),
      evidenceUrl: data['evidence'],
      status: data['status'],
    );
  }
}
