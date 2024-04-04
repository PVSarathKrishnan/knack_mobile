import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knack/view/screens/collections.dart';
import 'package:knack/view/style/text_style.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSigningOut = false;
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NAME: ${_currentUser.displayName}',
              style: text_style_h,
            ),
            SizedBox(height: 16.0),
            Text(
              'EMAIL: ${_currentUser.email}',
              style: text_style_n,
            ),
            SizedBox(height: 16.0),
            _currentUser.emailVerified
                ? Text('Email verified', style: text_style_n.copyWith(color: g))
                : Text('Email not verified',
                    style: text_style_n.copyWith(color: Colors.red)),
            // Add widgets for verifying email
            // and, signing out the user
          ],
        ),
      ),
    );
  }
}
