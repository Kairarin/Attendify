// lib/models/Feedback.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String userId;
  final String subject;
  final String message;
  final DateTime? createdAt;

  FeedbackModel({
    this.id = '',
    required this.userId,
    required this.subject,
    required this.message,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'user_id': userId,
    'subject': subject,
    'message': message,
    'created_at': FieldValue.serverTimestamp(),
  };

  factory FeedbackModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return FeedbackModel(
      id: doc.id,
      userId: data['user_id'] as String,
      subject: data['subject'] as String,
      message: data['message'] as String,
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
    );
  }
}
