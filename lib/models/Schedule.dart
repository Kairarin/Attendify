import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String id;
  final DateTime meetingDate;
  final String startTime; // format "HH:mm"
  final String endTime; // format "HH:mm"
  final String description;
  final bool isWFH;

  Schedule({
    required this.id,
    required this.meetingDate,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.isWFH,
  });

  factory Schedule.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Schedule(
      id: doc.id,
      meetingDate: DateTime.parse(data['meeting_date'] as String),
      startTime: data['start_time'] as String,
      endTime: data['end_time'] as String,
      description: data['description'] as String,
      isWFH: data['isWFH'] as bool? ?? false,
    );
  }
}
