import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main.dart'; // untuk akses MainNav

class LeaveRequest {
  final String type;
  final String name;
  final DateTime forDate;
  final String requestDate;
  bool isExpanded;

  LeaveRequest({
    required this.type,
    required this.name,
    required this.forDate,
    required this.requestDate,
    this.isExpanded = false,
  });
}

class LeaveRequestsPage extends StatefulWidget {
  const LeaveRequestsPage({Key? key}) : super(key: key);
  @override
  State<LeaveRequestsPage> createState() => _LeaveRequestsPageState();
}

class _LeaveRequestsPageState extends State<LeaveRequestsPage> {
  List<LeaveRequest> leaveRequests = [
    LeaveRequest(
        type: "Annual Leave",
        name: "Lebron James",
        forDate: DateTime(2025, 4, 26),
        requestDate: "15 Apr"),
    LeaveRequest(
        type: "Annual Leave",
        name: "michael Reeves",
        forDate: DateTime(2025, 7, 10),
        requestDate: "15 Apr"),
    LeaveRequest(
        type: "Wedding Leave",
        name: "Dustin Henderson",
        forDate: DateTime(2025, 6, 5),
        requestDate: "15 Apr"),
    LeaveRequest(
        type: "Business Trip < 7 Days",
        name: "Jason Momoa",
        forDate: DateTime(2025, 4, 23),
        requestDate: "15 Apr"),
    LeaveRequest(
        type: "Attendance Correction",
        name: "Dustin Henderson",
        forDate: DateTime(2025, 3, 10),
        requestDate: "12 Mar"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Requests"),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filter Section
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt),
                  label: const Text("Filter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Request Type ⌄"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Leave Request Cards
            ...leaveRequests.map((request) {
              return Card(
                color: Colors.pink.shade50,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(request.type,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(height: 2),
                                Text(request.name),
                                Text(
                                  "For: ${DateFormat('dd MMM yyyy').format(request.forDate)}",
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      request.isExpanded = !request.isExpanded;
                                    });
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(Icons.info_outline, size: 16),
                                      SizedBox(width: 4),
                                      Text("Details"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Date + Action
                          Column(
                            children: [
                              Text(
                                request.requestDate,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  Icon(Icons.cancel, color: Colors.red, size: 28),
                                  SizedBox(width: 8),
                                  Icon(Icons.check_circle,
                                      color: Colors.blue, size: 28),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      // Expanded Content
                      if (request.isExpanded) ...[
                        const Divider(),
                        const Text("Detailed Description:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const Text("No description"),
                        const SizedBox(height: 8),
                        const Text("Photo Evidence:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const Text("No photo uploaded"),
                      ]
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Schedule=1, tapi karena kita di LeaveRequests, set ke 0/1/2 sesuai urutan di MainNav
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (idx) {
          // navigasi via MainNav
          if (idx != 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainNav()),
            );
          }
        },
      ),
    );
  }
}
