// class UserModel {
//   final String id;
//   final String nama;
//   final String email;
//   final String position;
//   final String avatarUrl;

//   UserModel({
//     required this.id,
//     required this.nama,
//     required this.email,
//     required this.position,
//     required this.avatarUrl,
//   });

//   // Factory constructor buat dari JSON
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'] ?? '',
//       nama: json['nama'] ?? '',
//       email: json['email'] ?? '',
//       position: json['position'] ?? '',
//       avatarUrl: json['avatarUrl'] ?? '',
//     );
//   }

//   // Convert ke JSON (buat disimpen di storage)
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'nama': nama,
//       'email': email,
//       'position': position,
//       'avatarUrl': avatarUrl,
//     };
//   }
// }

// // File: lib/Models/user_model.dart
// import 'package:cloud_firestore/cloud_firestore.dart';

// /// Model untuk user yang kita simpan di koleksi "users" di Firestore.
// /// Asumsi struktur dokumen "users/{uid}" memiliki minimal field:
// //   - nama     (String)
// //   - position (String)
// //   - email    (String)
// class UserModel {
//   final String uid;
//   final String nama;
//   final String position;
//   final String email;

//   UserModel({
//     required this.uid,
//     required this.nama,
//     required this.position,
//     required this.email,
//   });

//   /// Factory constructor: dari DocumentSnapshot (Firestore) → UserModel
//   factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
//     final data = doc.data()!;
//     return UserModel(
//       uid: doc.id,
//       nama: data['nama'] as String? ?? '',
//       position: data['position'] as String? ?? '',
//       email: data['email'] as String? ?? '',
//     );
//   }

//   /// (Opsional) jika Anda perlu meng‐ubah UserModel kembali ke Map untuk update/insert:
//   Map<String, dynamic> toMap() {
//     return {'nama': nama, 'position': position, 'email': email};
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserModel {
//   final String uid;
//   final String nama;
//   final String position;
//   final String email;

//   UserModel({
//     required this.uid,
//     required this.nama,
//     required this.position,
//     required this.email,
//   });

//   factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
//     final data = doc.data()!;
//     return UserModel(
//       uid: doc.id,
//       nama: data['nama'] as String? ?? '',
//       position: data['position'] as String? ?? '',
//       email: data['email'] as String? ?? '',
//     );
//   }
// }

// File: lib/models/User.dart

// import 'package:cloud_firestore/cloud_firestore.dart';

// /// Model user sesuai struktur Firestore di koleksi "users"
// class UserModel {
//   final String uid;
//   final String nama;
//   final String position;
//   final String email;

//   UserModel({
//     required this.uid,
//     required this.nama,
//     required this.position,
//     required this.email,
//   });

//   factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
//     final data = doc.data()!;
//     return UserModel(
//       uid: doc.id,
//       nama: data['nama'] as String? ?? '',
//       position: data['position'] as String? ?? '',
//       email: data['email'] as String? ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {'nama': nama, 'position': position, 'email': email};
//   }
// }

// File: lib/models/User.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String nama;
  final String email;
  final String position;

  UserModel({
    required this.uid,
    required this.nama,
    required this.email,
    required this.position,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      uid: doc.id,
      nama: data['nama'] as String,
      email: data['email'] as String,
      position: data['position'] as String,
    );
  }
}
