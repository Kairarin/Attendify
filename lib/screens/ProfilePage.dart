// import 'package:flutter/material.dart';
// import '../models/User.dart';

// class ProfilePage extends StatelessWidget {
//   final UserModel user;

//   const ProfilePage({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile"),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const CircleAvatar(
//               radius: 50,
//               backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               user.nama,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               user.email,
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Position: ${user.position}",
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 40),
//             ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: const Icon(Icons.arrow_back),
//               label: const Text("Back to Home"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 minimumSize: const Size(double.infinity, 48),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // File: lib/screens/ProfilePage.dart

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/User.dart';
// import 'Login.dart';
// import '../app.dart'; // MainScreen di sini
// // import '../widgets/BottomBar.dart';  // <<< Hapus import ini

// class ProfilePage extends StatelessWidget {
//   final UserModel user;

//   const ProfilePage({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile"),
//         backgroundColor: Colors.blue,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               const CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(
//                   'https://down-id.img.susercontent.com/file/sg-11134201-22100-7aoyvztvl9ive1',
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 user.nama,
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 user.email,
//                 style: const TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Position: ${user.position}",
//                 style: const TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 40),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   // Kembali ke Home (tab pertama MainScreen)
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => MainScreen(user: user),
//                     ),
//                   );
//                 },
//                 icon: const Icon(Icons.arrow_back),
//                 label: const Text("Back to Home"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   minimumSize: const Size(double.infinity, 48),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       // Hapus bottomNavigationBar di sini—`MainScreen` sudah menampilkan sendiri.
//     );
//   }
// }

// File: lib/screens/ProfilePage.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/User.dart';
import '../app.dart'; // Untuk MainScreen
import 'Login.dart';

class ProfilePage extends StatelessWidget {
  final UserModel user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white24,
                child: ClipOval(
                  child: Image.network(
                    'https://i.pravatar.cc/150?img=3',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.nama,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                "Position: ${user.position}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  // Kembali ke Home (MainScreen) → switch ke tab pertama ("Home")
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => MainScreen(user: user)),
                  );
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back to Home"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
