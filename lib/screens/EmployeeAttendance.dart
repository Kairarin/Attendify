// import 'package:flutter/material.dart';
// import 'AttendanceHistory.dart';

// class EmployeeAttendancePage extends StatelessWidget {
//   const EmployeeAttendancePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Employee Attendance"),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Placeholder untuk Map
//             Container(
//               height: 200,
//               color: Colors.grey.shade300,
//               child: const Center(child: Text("Map Placeholder")),
//             ),

//             // Attendance Time
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.black12),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 children: [
//                   const Text(
//                     "Attendance Time",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Column(
//                         children: [
//                           const Text(
//                             "Check In",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                           const SizedBox(height: 6),
//                           const Text("07:03", style: TextStyle(fontSize: 20)),
//                           const SizedBox(height: 6),
//                           ElevatedButton(
//                             onPressed: () {},
//                             child: const Text("Check In"),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           const Text(
//                             "Check Out",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                           const SizedBox(height: 6),
//                           const Text("15:03", style: TextStyle(fontSize: 20)),
//                           const SizedBox(height: 6),
//                           ElevatedButton(
//                             onPressed: () {},
//                             child: const Text("Check Out"),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // Scan QR Button
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   child: const Text("Scan QR"),
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Today's Schedule
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   children: const [
//                     Icon(Icons.access_time, color: Colors.black54),
//                     SizedBox(width: 10),
//                     Text("07:03 - 15:00"),
//                     Spacer(),
//                     Icon(Icons.location_on_outlined, color: Colors.red),
//                     SizedBox(width: 4),
//                     Text("1 Locations"),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Attendance History Button
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const AttendanceMonitoringPage(),
//                       ),
//                     );
//                   },
//                   child: const Text("Attendance History"),
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }

// File: lib/screens/EmployeeAttendance.dart

import 'package:flutter/material.dart';
import 'AttendanceHistory.dart';

class EmployeeAttendancePage extends StatelessWidget {
  const EmployeeAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Attendance"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      // Ganti SingleChildScrollView + Column menjadi ListView
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          children: [
            // --- Placeholder untuk Map ---
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text("Map Placeholder")),
            ),

            const SizedBox(height: 16),

            // --- Attendance Time Card ---
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Attendance Time",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Check In",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          const Text("07:03", style: TextStyle(fontSize: 20)),
                          const SizedBox(height: 6),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("Check In"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Check Out",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          const Text("15:03", style: TextStyle(fontSize: 20)),
                          const SizedBox(height: 6),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("Check Out"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- Scan QR Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Scan QR"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ),

            const SizedBox(height: 16),

            // --- Today's Schedule ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.access_time, color: Colors.black54),
                  SizedBox(width: 10),
                  Text("07:03 - 15:00"),
                  Spacer(),
                  Icon(Icons.location_on_outlined, color: Colors.red),
                  SizedBox(width: 4),
                  Text("1 Locations"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- Attendance History Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceMonitoringPage(),
                    ),
                  );
                },
                child: const Text("Attendance History"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),

      // Jika memang tidak menginginkan BottomNavigationBar di halaman ini,
      // hapus atau komentar bagian ini. Namun jika tetap ingin,
      // pastikan konten ListView punya padding bottom yang cukup
      // agar tombol/lainya tidak tertutup.
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.grey,
      //   onTap: (index) {
      //     // navigasi jika dibutuhkan
      //   },
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Request'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      // ),
    );
  }
}
