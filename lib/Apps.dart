// import 'package:flutter/material.dart';

// void main() {
//   runApp(const AttendifyApp());
// }

// class AttendifyApp extends StatelessWidget {
//   const AttendifyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Employee Dashboard',
//       debugShowCheckedModeBanner: false,
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   final List<AppItem> apps = const [
//     AppItem("Criticism/\nSuggestions", Icons.chat_outlined),
//     AppItem("Employee\nattendance", Icons.qr_code),
//     AppItem("Attendance\nHistory", Icons.calendar_today),
//     AppItem("Attendance\nCorrection", Icons.receipt_long),
//     AppItem("Payroll", Icons.attach_money),
//     AppItem("Overtime", Icons.access_time),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // Top Banner
//           Container(
//             width: double.infinity,
//             color: const Color(0xFF1E5B98),
//             padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Morning,",
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                     Text(
//                       "Dustin Henderson",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const CircleAvatar(
//                   radius: 28,
//                   backgroundColor: Colors.purpleAccent,
//                   // Untuk image asli bisa gunakan:
//                   // backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
//                 ),
//               ],
//             ),
//           ),

//           // Main Content
//           Expanded(
//             child: SingleChildScrollView(
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Title & Close
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: const [
//                         Text(
//                           "Apps",
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Icon(Icons.close, size: 28),
//                       ],
//                     ),
//                     const SizedBox(height: 20),

//                     // App Grid (responsif)
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: apps.length,
//                       gridDelegate:
//                           const SliverGridDelegateWithMaxCrossAxisExtent(
//                             maxCrossAxisExtent: 180, // ukuran max per item
//                             mainAxisSpacing: 20,
//                             crossAxisSpacing: 20,
//                             childAspectRatio: 1,
//                           ),
//                       itemBuilder: (context, index) {
//                         return AppIcon(app: apps[index]);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AppItem {
//   final String title;
//   final IconData icon;

//   const AppItem(this.title, this.icon);
// }

// class AppIcon extends StatelessWidget {
//   final AppItem app;

//   const AppIcon({super.key, required this.app});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Icon(app.icon, color: Colors.white, size: 30),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           app.title,
//           textAlign: TextAlign.center,
//           style: const TextStyle(fontSize: 14),
//         ),
//       ],
//     );
//   }
// }
