// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../services/auth_service.dart';
// import '../models/User.dart';
// import 'HomePage.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     final email = _emailController.text.trim();
//     final pass = _passwordController.text.trim();

//     if (email.isEmpty || pass.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill in both Email and Password')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final authService = AuthService();
//       final userModel = await authService.signInWithEmail(email, pass);

//       if (userModel == null) {
//         // Artinya: user Auth berhasil, tapi profil di Firestore tidak ditemukan
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('User profile not found.')),
//         );
//         setState(() => _isLoading = false);
//         return;
//       }

//       // Jika login & fetch profil sukses, navigasi ke HomePage langsung:
//       // Kita “replace” karena tidak ingin kembali ke LoginScreen lewat tombol back.
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomePage(user: userModel)),
//       );
//     } on FirebaseAuthException catch (e) {
//       String message;
//       switch (e.code) {
//         case 'user-not-found':
//           message = 'No user found for that email.';
//           break;
//         case 'wrong-password':
//           message = 'Wrong password provided.';
//           break;
//         default:
//           message = e.message ?? 'Login error';
//       }
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(message)));
//       setState(() => _isLoading = false);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         width: double.infinity,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               const SizedBox(height: 80),
//               Image.asset(
//                 'assets/images/LoginImage.jpg',
//                 width: 200,
//                 height: 200,
//                 fit: BoxFit.cover,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Welcome to Attendify App',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'LOGIN',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                   suffixIcon: Icon(Icons.visibility_off),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _login,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF22577A),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child:
//                       _isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                             'Login',
//                             style: TextStyle(color: Colors.white, fontSize: 16),
//                           ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextButton(
//                 onPressed: () {
//                   // OPTIONAL: jika ingin implement “Forgot Password”
//                   // if (_emailController.text.isNotEmpty) {
//                   //   AuthService().sendPasswordReset(_emailController.text.trim());
//                   // }
//                 },
//                 child: const Text(
//                   'Forget Password?',
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both Email and Password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      final userCred = await authService.signInWithEmail(email, pass);
      if (userCred == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed: user not found')),
        );
      }
      // Setelah login, StreamBuilder di main.dart akan otomatis mengganti ke MainScreen
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        default:
          message = e.message ?? 'Login error';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/LoginImage.jpg',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Attendify App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'LOGIN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22577A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // TODO: implement forgot password logic
                },
                child: const Text(
                  'Forget Password?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
