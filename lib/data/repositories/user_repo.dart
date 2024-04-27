import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:knack/data/models/user_model.dart';

class UserRepo {
  Future<UserModel> getUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final data = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();

      final u = data.data();

      final users = UserModel(
          id: u!["id"], name: u["name"], email: u["email"], age: u["age"]);

      return users;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("failed with error ${e.code} : ${e.message}");
      }
      return UserModel(
          id: "", name: "", email: "", age: "",);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
