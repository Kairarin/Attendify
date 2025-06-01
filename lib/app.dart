// File: lib/MainScreen.dart

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'screens/Login.dart';
// import 'screens/AttendanceHistory.dart';
// import 'screens/EmployeeAttendance.dart';
// import 'screens/ProfilePage.dart';
// import 'screens/RequestLeave.dart';
// import 'models/User.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'widgets/BottomBar.dart';

// class MainScreen extends StatefulWidget {
//   final UserModel user;

//   const MainScreen({Key? key, required this.user}) : super(key: key);

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;

//   late final List<Widget> _pages;

//   @override
//   void initState() {
//     super.initState();

//     _pages = [
//       HomeContent(user: widget.user),
//       const RequestLeavePage(),
//       ProfilePage(user: widget.user),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex],
//       bottomNavigationBar: CustomBottomNavBar(
//         currentIndex: _currentIndex,
//         onTap: (newIndex) {
//           setState(() {
//             _currentIndex = newIndex;
//           });
//         },
//       ),
//     );
//   }
// }

// class HomeContent extends StatelessWidget {
//   final UserModel user;

//   const HomeContent({Key? key, required this.user}) : super(key: key);

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
//         Navigator.pop(context);
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
//     return SafeArea(
//       child: Column(
//         children: [
//           // === HEADER ===
//           Container(
//             color: Colors.blue,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Kolom Greeting + Nama + Position
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       getGreeting(),
//                       style: const TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       user.nama,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       user.position,
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Avatar & Tombol Logout
//                 Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 24,
//                       backgroundImage: NetworkImage(
//                         'https://i.pravatar.cc/150?img=3',
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     IconButton(
//                       icon: const Icon(Icons.logout, color: Colors.white),
//                       onPressed: () async {
//                         // Logout dari FirebaseAuth
//                         await FirebaseAuth.instance.signOut();
//                         // Arahkan ke LoginScreen (hapus stack)
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const LoginScreen(),
//                           ),
//                           (route) => false,
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 12),

//           // === WORKING SCHEDULE & CHECK-IN ===
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: const [
//                     Text(
//                       "Working Schedule",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       "Thu, 04 Apr 2025",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   "07:00 - 16:00",
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const EmployeeAttendancePage(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       backgroundColor: Colors.blue,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: const Text(
//                       "Check In",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),

//           // === FEATURE ICONS ===
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _featureButton(Icons.list_alt, "Attendance\nList"),
//                 _featureButton(
//                   Icons.assignment,
//                   "Request\nLeave",
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const RequestLeavePage(),
//                       ),
//                     );
//                   },
//                 ),
//                 _featureButton(Icons.qr_code_scanner, "Scan\nQR"),
//                 _featureButton(
//                   Icons.grid_view,
//                   "More",
//                   onTap: () => _showMoreMenu(context),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 24),

//           // === ATTENDANCE HISTORY (CONTOH HARD-CODED) ===
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Attendance",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text("View All", style: TextStyle(color: Colors.blue)),
//               ],
//             ),
//           ),

//           _attendanceCard("Fri, 05 Apr 2025", "07:30", "14:30"),
//           _attendanceCard("Mon, 08 Apr 2025", "09:30", "17:00"),
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

// File: lib/app.dart  (atau MainScreen.dart)

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/Login.dart';
import 'screens/AttendanceHistory.dart';
import 'screens/EmployeeAttendance.dart';
import 'screens/ProfilePage.dart';
import 'screens/RequestLeave.dart'; // ← perbarui nama file
import 'models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/BottomBar.dart'; // ← CustomBottomNavBar

class MainScreen extends StatefulWidget {
  final UserModel user;

  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomeContent(user: widget.user),
      RequestLeavePage(user: widget.user), // ← index 1 = RequestLeave
      ProfilePage(user: widget.user), // ← index 2 = Profile
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
      ),
    );
  }
}

/// HomeContent: isi halaman Home (seperti yang sudah Anda miliki)
class HomeContent extends StatelessWidget {
  final UserModel user;

  const HomeContent({Key? key, required this.user}) : super(key: key);

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
        Navigator.pop(context); // tutup modal
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
    return SafeArea(
      child: Column(
        children: [
          // === HEADER ===
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Kolom Greeting + Nama + Position
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getGreeting(),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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

                // Avatar & Tombol Logout
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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmployeeAttendancePage(),
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
                    // Kalau klik Request dari HomeContent, kita ubah index jadi 1 di MainScreen
                    final parentState =
                        context.findAncestorStateOfType<_MainScreenState>();
                    parentState?.setState(() {
                      parentState._currentIndex = 1;
                    });
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

          _attendanceCard("Fri, 05 Apr 2025", "07:30", "14:30"),
          _attendanceCard("Mon, 08 Apr 2025", "09:30", "17:00"),
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
