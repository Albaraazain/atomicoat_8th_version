// lib/features/auth/repository/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../../../enums/user_role.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (!doc.exists) return null;

      final userData = doc.data()!;
      return User(
        id: firebaseUser.uid,
        email: userData['email'] as String,
        name: userData['name'] as String,
        role: _parseUserRole(userData['role']),
        status: userData['status'] as String,
        machineSerial: userData['machineSerial'] as String,
      );
    });
  }

  UserRole _parseUserRole(dynamic roleString) {
    if (roleString == null) return UserRole.user;
    try {
      return UserRole.values.firstWhere(
        (role) => role.toString().split('.').last == roleString,
        orElse: () => UserRole.user,
      );
    } catch (e) {
      print('Error parsing UserRole: $e');
      return UserRole.user;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String machineSerial,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'name': name,
        'role': UserRole.user.toString().split('.').last,
        'status': 'pending',
        'machineSerial': machineSerial,
      });
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc =
          await _firestore.collection('users').doc(credential.user!.uid).get();

      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      final status = userDoc.data()!['status'] as String;
      if (status != 'approved' && status != 'active') {
        await signOut();
        throw Exception('Your account is pending approval.');
      }
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Exception _handleAuthException(dynamic e) {
    if (e is firebase_auth.FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return Exception('No user found with this email.');
        case 'wrong-password':
          return Exception('Wrong password provided.');
        case 'email-already-in-use':
          return Exception('Email is already registered.');
        default:
          return Exception(e.message ?? 'Authentication error occurred.');
      }
    }
    return Exception('An unexpected error occurred.');
  }
}
