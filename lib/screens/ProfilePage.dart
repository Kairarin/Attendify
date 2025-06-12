import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/User.dart';
import '../screens/Login.dart';
import '../utils/DeviceActivity.dart';
import 'DeviceActivity.dart';

class ProfilePage extends StatelessWidget {
  final UserModel user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  Future<void> _doLogout(BuildContext context) async {
    if (!kIsWeb) {
      try {
        await DeviceActivityDb.instance.insert(
          DeviceActivity(
            user: user.uid,
            timestamp: DateTime.now(),
            activity: 'logout',
          ),
        );
      } catch (dbErr) {
        debugPrint('Could not record logout activity: $dbErr');
      }
    }

    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

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
                    errorBuilder:
                        (_, __, ___) => const Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.grey,
                        ),
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
              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeviceActivityPage(user: user),
                      ),
                    );
                  },
                  icon: const Icon(Icons.devices),
                  label: const Text("Device Activity"),
                ),
              ),
              const SizedBox(height: 16),


              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  onPressed: () => _doLogout(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
