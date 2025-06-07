import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/User.dart';
import '../models/Feedback.dart';

class ComplainPage extends StatefulWidget {
  final UserModel user;
  const ComplainPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ComplainPage> createState() => _ComplainPageState();
}

class _ComplainPageState extends State<ComplainPage> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  Future<void> _sendFeedback() async {
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();
    if (subject.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill both subject & message')),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      await FirebaseFirestore.instance.collection('feedback').add({
        'user_id': widget.user.uid,
        'subject': subject,
        'message': message,
        'created_at': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback sent successfully')),
      );
      _subjectController.clear();
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sending feedback: $e')));
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criticism / Suggestions'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Provide your criticism and suggestions for this mobile attendance application.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),

            // Subject
            const Text(
              'Subject',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                hintText: 'Enter subject',
                border: border,
                enabledBorder: border,
                focusedBorder: border.copyWith(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Message
            const Text(
              'Message',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _messageController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Write here…',
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border.copyWith(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Send button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isSending
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text('Send', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
