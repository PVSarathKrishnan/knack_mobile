import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:knack/data/models/user_model.dart';

class UserRepo {
  Future<UserModel> getUser() async {
    try {
      print("user 1");
      User? user = FirebaseAuth.instance.currentUser;
      print("user 2");
      print(user!.uid);
      final dataset = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      print(dataset);
      print("user 3   " + user.uid);
      final user1 = dataset.data();
      print(user1);
      print("user 4 ;" + user1.toString());
      final users = UserModel(
          id: user1!["id"],
          name: user1['name'],
          email: user1['email'],
          age: user1['age'],
          avatar: user1["avatar"]);
      print("user 5 id :" + user.uid);
      return users;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("failed with error ${e.code} : ${e.message}");
      }
      return UserModel(id: "", name: "", email: "", age: "", avatar: "");
    } catch (e) {
      print("errorrrrrrrrrrrrrr");
      throw Exception(e.toString());
    }
  }
}
