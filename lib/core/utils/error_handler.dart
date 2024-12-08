// lib/core/utils/error_handler.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class ErrorHandler {
  static String handleError(dynamic error) {
    if (error is firebase_auth.FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'Email is already registered.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled.';
        case 'weak-password':
          return 'The password provided is too weak.';
        default:
          return error.message ?? 'An authentication error occurred.';
      }
    }

    return error.toString();
  }

  static String handleFirestoreError(dynamic error) {
    if (error is Exception) {
      return 'Database error: ${error.toString()}';
    }
    return 'An unexpected error occurred.';
  }
}
