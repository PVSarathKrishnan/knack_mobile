import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:knack/view/screens/chat/chat_screen.dart';
import 'package:knack/view/screens/collections.dart';
import 'package:knack/view/screens/courses/course_screen.dart';
import 'package:knack/view/screens/homescreen/home_screen.dart'; // Import CourseScreen
import 'package:knack/view/screens/profile/profile_screen.dart';
import 'package:line_icons/line_icons.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _selectedIndex = 0; // Track the selected tab index

  final List<Widget> _screens = [
    HomeScreen(),
    CourseScreen(),
    ChatScreen(),
    // ProfileScreen(user: ,)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(right: 15, left: 15, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: g,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            tabBackgroundColor: Colors.black,
            activeColor: g,
            color: Colors.black,
            gap: 9,
            rippleColor: Colors.white.withOpacity(.4),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: [
              GButton(
                icon: LineIcons.home,
                text: "Home",
              ),
              GButton(
                icon: LineIcons.bookOpen,
                text: "Courses",
              ),
              GButton(
                icon: LineIcons.telegram,
                text: "Chat",
              ),
              GButton(
                icon: LineIcons.personEnteringBooth,
                text: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
