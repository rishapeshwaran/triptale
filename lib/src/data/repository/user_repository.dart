import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dtos/user_profile_dto.dart';

Future<bool> addUserToFirestore(UserModel user, WidgetRef ref) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // using uid as document ID
        .set(user.toJson());
    ref.read(userProvider.notifier).state = user;

    print('User added successfully');
    return true;
  } catch (e) {
    print('Error adding user: $e');
    return false;
  }
}

Future<UserModel?> getUserByUid(String uid, WidgetRef ref) async {
  try {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      final user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      ref.read(userProvider.notifier).state = user;
      return user;
    } else {
      print("User not found");
      return null;
    }
  } catch (e) {
    print("Error fetching user: $e");
    return null;
  }
}

final userProvider = StateProvider<UserModel?>((ref) {
  return null;
});
