import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'models/User.dart';
import 'screens/Login.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AttendifyApp());
}

class AttendifyApp extends StatelessWidget {
  const AttendifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendify App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF22577A),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final firebaseUser = authSnapshot.data;
          if (firebaseUser != null) {
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(firebaseUser.uid)
                      .get(),
              builder: (context, userDocSnapshot) {
                if (userDocSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (!userDocSnapshot.hasData || !userDocSnapshot.data!.exists) {
                  return const Scaffold(
                    body: Center(child: Text('User profile not found')),
                  );
                }
                final userModel = UserModel.fromFirestore(
                  userDocSnapshot.data!,
                );
                return MainScreen(user: userModel);
              },
            );
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
