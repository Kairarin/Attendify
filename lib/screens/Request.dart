// import 'package:flutter/material.dart';

// class LeaveRequest {
//   final String type;
//   final String employeeName;
//   final DateTime forDate;
//   final DateTime requestDate;
//   String status;

//   LeaveRequest({
//     required this.type,
//     required this.employeeName,
//     required this.forDate,
//     required this.requestDate,
//     required this.status,
//   });
// }

// class RequestPage extends StatefulWidget {
//   @override
//   _RequestPageState createState() => _RequestPageState();
// }

// class _RequestPageState extends State<RequestPage> {
//   int _selectedIndex = 1;
//   bool showAwaiting = true;
//   final List<LeaveRequest> requests = [
//     LeaveRequest(
//       type: 'Annual Leave',
//       employeeName: 'Dustin Henderson',
//       forDate: DateTime(2025, 4, 26),
//       requestDate: DateTime(2025, 4, 15),
//       status: 'Approved',
//     ),
//     LeaveRequest(
//       type: 'Annual Leave',
//       employeeName: 'Dustin Henderson',
//       forDate: DateTime(2025, 7, 10),
//       requestDate: DateTime(2025, 4, 15),
//       status: 'Rejected',
//     ),
//     LeaveRequest(
//       type: 'Wedding Leave',
//       employeeName: 'Dustin Henderson',
//       forDate: DateTime(2025, 6, 5),
//       requestDate: DateTime(2025, 4, 15),
//       status: 'Approved',
//     ),
//     LeaveRequest(
//       type: 'Business Trip < 7 Days',
//       employeeName: 'Dustin Henderson',
//       forDate: DateTime(2025, 4, 23),
//       requestDate: DateTime(2025, 4, 15),
//       status: 'Awaiting',
//     ),
//     LeaveRequest(
//       type: 'Attendance Correction',
//       employeeName: 'Dustin Henderson',
//       forDate: DateTime(2025, 3, 10),
//       requestDate: DateTime(2025, 3, 12),
//       status: 'Approved',
//     ),
//   ];

//   Widget _buildStatusChip(String status) {
//     Color backgroundColor;
//     switch (status) {
//       case 'Approved':
//         backgroundColor = Colors.green;
//         break;
//       case 'Rejected':
//         backgroundColor = Colors.red;
//         break;
//       default: // Awaiting
//         backgroundColor = Colors.orange;
//     }
//     return Chip(
//       label: Text(status),
//       backgroundColor: backgroundColor.withOpacity(0.2),
//       labelStyle: TextStyle(color: backgroundColor),
//     );
//   }

//   void _updateStatus(int index, String newStatus) {
//     setState(() {
//       requests[index].status = newStatus;
//     });
//     // Tambahkan logika untuk update ke backend di sini
//   }

//   void _showStatusDialog(int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Update Status"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: Text('Approved'),
//                 onTap: () {
//                   _updateStatus(index, 'Approved');
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: Text('Rejected'),
//                 onTap: () {
//                   _updateStatus(index, 'Rejected');
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: Text('Awaiting'),
//                 onTap: () {
//                   _updateStatus(index, 'Awaiting');
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Request'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: showAwaiting ? Colors.blue : Colors.grey,
//                     ),
//                     onPressed: () => setState(() => showAwaiting = true),
//                     child: Text('Awaiting'),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: !showAwaiting ? Colors.blue : Colors.grey,
//                     ),
//                     onPressed: () => setState(() => showAwaiting = false),
//                     child: Text('App'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: requests.length,
//               itemBuilder: (context, index) {
//                 final request = requests[index];
//                 if ((showAwaiting && request.status != 'Awaiting') ||
//                     (!showAwaiting && request.status == 'Awaiting')) {
//                   return SizedBox.shrink();
//                 }
//                 return Card(
//                   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           request.type,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(request.employeeName),
//                         SizedBox(height: 4),
//                         Text(
//                           'For: ${request.forDate.day} ${_getMonthName(request.forDate.month)} ${request.forDate.year}',
//                         ),
//                         Text(
//                           'Requested on: ${request.requestDate.day} ${_getMonthName(request.requestDate.month)} ${request.requestDate.year}',
//                         ),
//                       ],
//                     ),
//                     trailing: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _buildStatusChip(request.status),
//                         if (showAwaiting) // Hanya tampilkan tombol edit untuk admin
//                           IconButton(
//                             icon: Icon(Icons.edit),
//                             onPressed: () => _showStatusDialog(index),
//                           ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.request_page), label: 'Request'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//         onTap: (index) => setState(() => _selectedIndex = index),
//       ),
//     );
//   }

//   String _getMonthName(int month) {
//     return [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//     ][month - 1];
//   }
// }
