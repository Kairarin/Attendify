import 'package:flutter/material.dart';
import 'main.dart';
import 'feedback_details_page.dart'; // you’ll implement this later

/// Data model for a feedback item
class FeedbackItem {
  final String name;
  final String subject;
  final String timestamp;

  FeedbackItem({
    required this.name,
    required this.subject,
    required this.timestamp,
  });
}

/// Sample data — replace with your real source
final List<FeedbackItem> feedbackList = [
  FeedbackItem(
    name: 'John Doe',
    subject: 'The fingerprint scanner at the front office often fails to detect during rush hours.',
    timestamp: 'April 12, 2025 - 09:15 AM',
  ),
  FeedbackItem(
    name: 'Jane Smith',
    subject: 'Requesting an update to the leave policy regarding family emergencies. It’s currently unclear and confusing.',
    timestamp: 'April 11, 2025 - 04:42 PM',
  ),
];

/// Admin view of all feedback
class AdminFeedbackScreen extends StatelessWidget {
  const AdminFeedbackScreen({Key? key}) : super(key: key);

  /// Replace every character of the name with “*”
  String _censorName(String name) =>
      List.filled(name.length, '*').join();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback & Complaints'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: feedbackList.length,
        itemBuilder: (context, index) {
          final item = feedbackList[index];
          return GestureDetector(
            onTap: () {
              // feedback details here
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Censored name
                    Text(
                      _censorName(item.name),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Sent date
                    Text(
                      item.timestamp,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subject of the feedback
                    Text(
                      item.subject,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // match EmployeeManagementPage’s index
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => MainNav(initialIndex: i)),
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
