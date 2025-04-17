import 'package:flutter/material.dart';

class EmployeeOvertimeScreen extends StatelessWidget {
  const EmployeeOvertimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {
        'date': '4/22/2025',
        'checkIn': '07:27',
        'checkOut': '18:36',
        'unattended': 7,
        'attended': 3,
        'status': 'Pending',
      },
      {
        'date': '4/12/2025',
        'checkIn': '07:00',
        'checkOut': '19:00',
        'unattended': 0,
        'attended': 4,
        'status': 'Accepted',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overtime'),
        leading: BackButton(onPressed: () => Navigator.pushNamed(context, '/')),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (_, i) {
          final item = data[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: const Color(0xFFFDF5F5),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${item['date']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Check-in: ${item['checkIn']}'),
                  Text('Check-out: ${item['checkOut']}'),
                  const SizedBox(height: 8),
                  Text('${item['unattended']} Work Hours Unattended', style: const TextStyle(color: Colors.red)),
                  Text('${item['attended']} Hours Overtime Attended', style: const TextStyle(color: Colors.green)),
                  const SizedBox(height: 12),
                  if (item['status'] == 'Pending')
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Accept'),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22577A)),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Decline'),
                        ),
                      ],
                    )
                  else
                    Text('Status: ${item['status']}', style: const TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF22577A),
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          switch (i) {
            case 0: Navigator.pushNamed(context, '/'); break;
            case 1: Navigator.pushNamed(context, '/schedule'); break;
            case 2: Navigator.pushNamed(context, '/career'); break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
