import 'package:flutter/material.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});
  @override
  _AttendanceHistoryScreenState createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  String? _month;
  int _currentIndex = 0;
  final List<String> _months = const [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance History')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Good Afternoon, Dustin Henderson', style: const TextStyle(fontSize:16, fontWeight: FontWeight.w600)),
          const SizedBox(height:4),
          Text('Fri, 05 Apr 2025', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height:24),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(children: [
                Expanded(child: Column(children:[
                  Text('Length of work', style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height:8),
                  const Text('0.22', style: TextStyle(fontSize:24,fontWeight: FontWeight.bold)),
                  Text('Year', style: TextStyle(color: Colors.grey[700])),
                ])),
                Container(width:1, height:60, color: Colors.grey[300]),
                Expanded(child: Column(children:[
                  Text('Rest of leave', style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height:8),
                  const Text('1', style: TextStyle(fontSize:24,fontWeight: FontWeight.bold)),
                  Text('Day', style: TextStyle(color: Colors.grey[700])),
                ])),
              ]),
            ),
          ),
          const SizedBox(height:24),
          Text('Attendance this month', style: const TextStyle(fontSize:16,fontWeight: FontWeight.w600)),
          const SizedBox(height:12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children:[
            _stat('18','Present'),
            _stat('0','Sick'),
            _stat('0','Leave'),
            _stat('0','Alpha'),
          ]),
          const SizedBox(height:32),
          Text('Device log today', style: const TextStyle(fontSize:16,fontWeight: FontWeight.w600)),
          const SizedBox(height:12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                _logRow('Check in','06:58'),
                const SizedBox(height:8),
                _logRow('Check out','17:00'),
                const SizedBox(height:8),
                _logRow('Break out','12:00'),
                const SizedBox(height:8),
                _logRow('Break in','13:00'),
              ]),
            ),
          ),
          const SizedBox(height:32),
          Text('Month history', style: const TextStyle(fontSize:16,fontWeight: FontWeight.w600)),
          const SizedBox(height:12),
          DropdownButton<String>(
            isExpanded: true,
            value: _month,
            hint: const Text('Choose'),
            items: _months.map((m)=>DropdownMenuItem(value:m,child:Text(m))).toList(),
            onChanged:(v)=>setState(()=>_month=v),
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF22577A),
        unselectedItemColor: Colors.grey,
        onTap:(i)=>setState(()=>_currentIndex=i),
        items:[
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Request'),
        ],
      ),
    );
  }

  Widget _stat(String c, String l) => Column(children:[
    Text(c, style: const TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
    const SizedBox(height:4),
    Text(l, style: TextStyle(color: Colors.grey[700])),
  ]);

  Widget _logRow(String t, String tm) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children:[ Text(t), Text(tm, style: const TextStyle(fontWeight: FontWeight.bold)) ]
  );
}
