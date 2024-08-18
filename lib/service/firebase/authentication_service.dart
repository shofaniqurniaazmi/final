import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutritrack/common/config/storage.dart';
import 'package:nutritrack/service/firebase/auth_exception_handler.dart';
import 'package:flutter/material.dart';

class AuthenticationService {
  AuthResultStatus status = AuthResultStatus.undefined;
  SecureStorage _secureStorage = SecureStorage();

  // Login dengan email dan password
  Future<AuthResultStatus> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (authResult.user != null) {
        await _secureStorage.saveUserId(authResult.user!.uid);
        status = AuthResultStatus.successful;
      } else {
        status = AuthResultStatus.undefined;
      }
    } catch (msg) {
      status = AuthExceptionHandler.handleException(msg);
    }
    return status;
  }

  // Signup user dengan email dan password
  Future<AuthResultStatus> signupWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final UserCredential authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (authResult.user != null) {
        _saveUserDetails(
          fullName: fullName,
          email: email,
          userId: authResult.user!.uid,
        );
        status = AuthResultStatus.successful;
      } else {
        status = AuthResultStatus.undefined;
      }
    } catch (msg) {
      status = AuthExceptionHandler.handleException(msg);
    }
    return status;
  }

  // Login dengan Google
  Future<AuthResultStatus> loginWithGoogle() async {
    try {
      // Memicu autentikasi Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (authResult.user != null) {
          _saveUserDetails(
            fullName: authResult.user!.displayName ?? '',
            email: authResult.user!.email!,
            userId: authResult.user!.uid,
          );
          await _secureStorage.saveUserId(authResult.user!.uid);
          status = AuthResultStatus.successful;
        } else {
          status = AuthResultStatus.undefined;
        }
      } else {
        status = AuthResultStatus.undefined;
      }
    } catch (msg) {
      status = AuthExceptionHandler.handleException(msg);
    }
    return status;
  }

  // Fungsi untuk menyimpan detail user ke Firestore
  void _saveUserDetails({
    required String fullName,
    required String email,
    required String userId,
  }) {
    FirebaseFirestore.instance.collection('users').doc(userId).set({
      'fullName': fullName,
      'email': email,
      'userId': userId,
      'classificationCompleted': false,
    });
  }

  // Fungsi untuk submit user classification
  Future<void> submitUserClassification({
    required String userId,
    required double weight,
    required double height,
    required int age,
    required String gender,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'weight': weight,
        'height': height,
        'age': age,
        'gender': gender,
        'classificationCompleted': true,
      });

      // Arahkan user ke halaman home setelah mengisi data classification
      context.go('/home');
    } catch (e) {
      print('Submit classification error: $e');
      // Handle error, seperti menampilkan snackbar atau dialog
    }
  }

  // Fungsi untuk mengecek apakah user sudah melengkapi data klasifikasi
  Future<bool> isClassificationCompleted(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        return userData['classificationCompleted'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking classificationCompleted: $e');
      return false;
    }
  }
}
