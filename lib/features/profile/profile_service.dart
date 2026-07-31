import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'profile_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save user profile
  Future<void> saveProfile(UserProfile profile) async {
    await _firestore
        .collection('users')
        .doc(profile.uid)
        .set(profile.toMap());
  }

  /// Get current user's profile
  Future<UserProfile?> getProfile() async {
    final user = _auth.currentUser;

    if (user == null) return null;

    final doc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) return null;

    return UserProfile.fromMap(doc.data()!);
  }

  /// Update user profile
  Future<void> updateProfile(UserProfile profile) async {
    await _firestore
        .collection('users')
        .doc(profile.uid)
        .update(profile.toMap());
  }
}