// // File: lib/HomePage.dart

// import 'package:flutter/material.dart';
// import 'AttendanceHistory.dart';
// import 'EmployeeAttendance.dart';
// import 'ProfilePage.dart';
// import 'RequestLeave.dart';
// import '../models/User.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'Login.dart';

// class HomePage extends StatelessWidget {
//   final UserModel user;

//   const HomePage({super.key, required this.user});

//   String getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour >= 5 && hour < 12) return 'Good morning';
//     if (hour >= 12 && hour < 18) return 'Good afternoon';
//     return 'Good evening';
//   }

//   void _showMoreMenu(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildMoreOption(
//                 Icons.feedback,
//                 'Criticism/ Suggestions',
//                 context,
//               ),
//               _buildMoreOption(Icons.qr_code, 'Employee Attendance', context),
//               _buildMoreOption(
//                 Icons.calendar_month,
//                 'Attendance History',
//                 context,
//               ),
//               _buildMoreOption(
//                 Icons.edit_note,
//                 'Attendance Correction',
//                 context,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMoreOption(IconData icon, String label, BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, size: 30),
//       title: Text(label, style: const TextStyle(fontSize: 16)),
//       onTap: () {
//         Navigator.pop(context); // tutup modal
//         if (label == 'Attendance History') {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const AttendanceMonitoringPage(),
//             ),
//           );
//         } else if (label == 'Employee Attendance') {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const EmployeeAttendancePage(),
//             ),
//           );
//         }
//         // Tambahkan navigasi untuk opsi lain sesuai kebutuhan
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Gunakan SingleChildScrollView agar kolom bisa discroll saat konten terlalu panjang
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // === HEADER & SCHEDULE ===
//               Container(
//                 color: Colors.blue,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Kolom Greeting + Nama + Position
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           getGreeting(),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           user.nama,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           user.position,
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Avatar & Tombol Logout
//                     Row(
//                       children: [
//                         const CircleAvatar(
//                           radius: 24,
//                           backgroundImage: NetworkImage(
//                             'https://i.pravatar.cc/150?img=3',
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         IconButton(
//                           icon: const Icon(Icons.logout, color: Colors.white),
//                           onPressed: () async {
//                             // Logout dari Firebase Auth
//                             await FirebaseAuth.instance.signOut();
//                             // Kembalikan ke login (atau sesuai logika aplikasi Anda)
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const LoginScreen(),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // === WORKING SCHEDULE & CHECK-IN ===
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: const [
//                           Text(
//                             "Working Schedule",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "Thu, 04 Apr 2025",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       const Text(
//                         "07:00 - 16:00",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) => const EmployeeAttendancePage(),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text(
//                             "Check In",
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // === FEATURE ICONS ===
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _featureButton(Icons.list_alt, "Attendance\nList"),
//                     _featureButton(
//                       Icons.assignment,
//                       "Request\nLeave",
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RequestLeavePage(user: user),
//                           ),
//                         );
//                       },
//                     ),
//                     _featureButton(Icons.qr_code_scanner, "Scan\nQR"),
//                     _featureButton(
//                       Icons.grid_view,
//                       "More",
//                       onTap: () => _showMoreMenu(context),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // === ATTENDANCE HISTORY (CONTOH HARD‐CODED) ===
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Attendance",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text("View All", style: TextStyle(color: Colors.blue)),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 8),

//               // Beberapa card contoh (jika lebih banyak, tambahkan ListView di dalam Column, atau bungkus dengan Column + List.generate)
//               _attendanceCard("Fri, 05 Apr 2025", "07:30", "14:30"),
//               _attendanceCard("Mon, 08 Apr 2025", "09:30", "17:00"),

//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),

//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         onTap: (index) {
//           if (index == 2) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => ProfilePage(user: user)),
//             );
//           }
//           // Jika index == 1 (Request) atau index == 0, sesuaikan logika navigasi di sini jika perlu
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications),
//             label: 'Request',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }

//   Widget _featureButton(IconData icon, String label, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, size: 28),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _attendanceCard(String date, String start, String end) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.location_on, size: 18, color: Colors.red),
//               const SizedBox(width: 6),
//               Text("Start Day\n$start", style: const TextStyle(fontSize: 14)),
//             ],
//           ),
//           Row(
//             children: [
//               const Icon(Icons.location_on, size: 18, color: Colors.red),
//               const SizedBox(width: 6),
//               Text("End Day\n$end", style: const TextStyle(fontSize: 14)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// File: lib/HomePage.dart

// import 'package:flutter/material.dart';
// import 'AttendanceHistory.dart';
// import 'EmployeeAttendance.dart';
// import 'ProfilePage.dart';
// import 'RequestLeave.dart';
// import '../models/User.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'Login.dart';

// class HomePage extends StatelessWidget {
//   final UserModel user;

//   const HomePage({super.key, required this.user});

//   String getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour >= 5 && hour < 12) return 'Good morning';
//     if (hour >= 12 && hour < 18) return 'Good afternoon';
//     return 'Good evening';
//   }

//   void _showMoreMenu(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildMoreOption(
//                 Icons.feedback,
//                 'Criticism/ Suggestions',
//                 context,
//               ),
//               _buildMoreOption(Icons.qr_code, 'Employee Attendance', context),
//               _buildMoreOption(
//                 Icons.calendar_month,
//                 'Attendance History',
//                 context,
//               ),
//               _buildMoreOption(
//                 Icons.edit_note,
//                 'Attendance Correction',
//                 context,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMoreOption(IconData icon, String label, BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, size: 30),
//       title: Text(label, style: const TextStyle(fontSize: 16)),
//       onTap: () {
//         Navigator.pop(context); // tutup modal
//         if (label == 'Attendance History') {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const AttendanceMonitoringPage(),
//             ),
//           );
//         } else if (label == 'Employee Attendance') {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const EmployeeAttendancePage(),
//             ),
//           );
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // SingleChildScrollView dengan bottom padding agar tidak tertutup oleh bottomNavigationBar
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(
//             top: 16,
//             left: 0,
//             right: 0,
//             bottom: kBottomNavigationBarHeight + 16,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // === HEADER & SCHEDULE ===
//               Container(
//                 color: Colors.blue,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Kolom Greeting + Nama + Position
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           getGreeting(),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           user.nama,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           user.position,
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Avatar & Tombol Logout
//                     Row(
//                       children: [
//                         const CircleAvatar(
//                           radius: 24,
//                           backgroundImage: NetworkImage(
//                             'https://i.pravatar.cc/150?img=3',
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         IconButton(
//                           icon: const Icon(Icons.logout, color: Colors.white),
//                           onPressed: () async {
//                             // Logout dari FirebaseAuth
//                             await FirebaseAuth.instance.signOut();
//                             // Kembali ke LoginScreen
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const LoginScreen(),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // === WORKING SCHEDULE & CHECK-IN ===
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: const [
//                           Text(
//                             "Working Schedule",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "Thu, 04 Apr 2025",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       const Text(
//                         "07:00 - 16:00",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) => const EmployeeAttendancePage(),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text(
//                             "Check In",
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // === FEATURE ICONS ===
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _featureButton(Icons.list_alt, "Attendance\nList"),
//                     _featureButton(
//                       Icons.assignment,
//                       "Request\nLeave",
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RequestLeavePage(user: user),
//                           ),
//                         );
//                       },
//                     ),
//                     _featureButton(Icons.qr_code_scanner, "Scan\nQR"),
//                     _featureButton(
//                       Icons.grid_view,
//                       "More",
//                       onTap: () => _showMoreMenu(context),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // === ATTENDANCE HISTORY (CONTOH HARD‐CODED) ===
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Attendance",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text("View All", style: TextStyle(color: Colors.blue)),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 8),

//               // Beberapa card contoh
//               _attendanceCard("Fri, 05 Apr 2025", "07:30", "14:30"),
//               _attendanceCard("Mon, 08 Apr 2025", "09:30", "17:00"),

//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),

//       // BottomNavigationBar tetap di sini
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         onTap: (index) {
//           if (index == 2) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => ProfilePage(user: user)),
//             );
//           }
//           // Jika index == 1 (Request) atau index == 0, sesuaikan logika navigasi jika perlu
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications),
//             label: 'Request',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }

//   Widget _featureButton(IconData icon, String label, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, size: 28),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _attendanceCard(String date, String start, String end) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.location_on, size: 18, color: Colors.red),
//               const SizedBox(width: 6),
//               Text("Start Day\n$start", style: const TextStyle(fontSize: 14)),
//             ],
//           ),
//           Row(
//             children: [
//               const Icon(Icons.location_on, size: 18, color: Colors.red),
//               const SizedBox(width: 6),
//               Text("End Day\n$end", style: const TextStyle(fontSize: 14)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// File: lib/HomePage.dart

import 'package:flutter/material.dart';
import 'AttendanceHistory.dart';
import 'EmployeeAttendance.dart';
import 'ProfilePage.dart';
import 'RequestLeave.dart';
import '../models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login.dart';

class HomePage extends StatelessWidget {
  final UserModel user;

  const HomePage({super.key, required this.user});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good morning';
    if (hour >= 12 && hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMoreOption(
                Icons.feedback,
                'Criticism/ Suggestions',
                context,
              ),
              _buildMoreOption(Icons.qr_code, 'Employee Attendance', context),
              _buildMoreOption(
                Icons.calendar_month,
                'Attendance History',
                context,
              ),
              _buildMoreOption(
                Icons.edit_note,
                'Attendance Correction',
                context,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoreOption(IconData icon, String label, BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        if (label == 'Attendance History') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AttendanceMonitoringPage(),
            ),
          );
        } else if (label == 'Employee Attendance') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmployeeAttendancePage(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // ListView menggantikan SingleChildScrollView + Column
        child: ListView(
          padding: const EdgeInsets.only(
            top: 16,
            left: 0,
            right: 0,
            bottom: 16, // spasi ekstra di bawah
          ),
          children: [
            // === HEADER & SCHEDULE ===
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getGreeting(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.nama,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.position,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=3',
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // === WORKING SCHEDULE & CHECK-IN ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Working Schedule",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Thu, 04 Apr 2025",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "07:00 - 16:00",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const EmployeeAttendancePage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Check In",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // === FEATURE ICONS ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _featureButton(Icons.list_alt, "Attendance\nList"),
                  _featureButton(
                    Icons.assignment,
                    "Request\nLeave",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestLeavePage(user: user),
                        ),
                      );
                    },
                  ),
                  _featureButton(Icons.qr_code_scanner, "Scan\nQR"),
                  _featureButton(
                    Icons.grid_view,
                    "More",
                    onTap: () => _showMoreMenu(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // === ATTENDANCE HISTORY (CONTOH HARD‐CODED) ===
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Attendance",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("View All", style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Contoh kartu absen
            _attendanceCard("Fri, 05 Apr 2025", "07:30", "14:30"),
            _attendanceCard("Mon, 08 Apr 2025", "09:30", "17:00"),

            const SizedBox(height: 16),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfilePage(user: user)),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Request',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _featureButton(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _attendanceCard(String date, String start, String end) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.red),
              const SizedBox(width: 6),
              Text("Start Day\n$start", style: const TextStyle(fontSize: 14)),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.red),
              const SizedBox(width: 6),
              Text("End Day\n$end", style: const TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
