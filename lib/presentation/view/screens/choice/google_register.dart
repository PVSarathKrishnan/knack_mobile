import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knack/presentation/view/screens/bottom_navigation_bar.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/main_page.dart';
import 'package:knack/presentation/view/style/text_style.dart';

class GoogleRegisterScreen extends StatefulWidget {
  const GoogleRegisterScreen({Key? key}) : super(key: key);

  @override
  State<GoogleRegisterScreen> createState() => _GoogleRegisterScreenState();
}

class _GoogleRegisterScreenState extends State<GoogleRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  String? _selectedAvatar;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0XFFFAFBFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        "lib/assets/3dgoogle.png",
                        height: 170,
                        width: 170,
                      ),
                    ),
                    Text("Register here", style: text_style_h),
                    Text("This won't take too long,\nenter your details here!",
                        style:
                            text_style_n.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          _showAvatarSelectionDialog(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 73, 73, 73)
                                    .withOpacity(0.2), // Shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 4, // Blur radius
                                offset: Offset(
                                    0, 2), // Shadow position, vertically down
                              ),
                            ],
                          ),
                          child: _selectedAvatar != null
                              ? Image.network(
                                  _selectedAvatar!,
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 90,
                                )
                              : CircleAvatar(
                                  backgroundColor: g,
                                  radius: 50,
                                  child: Icon(
                                    Icons.person_add_alt_sharp,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                        )),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name",
                                style: text_style_n,
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: nameController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Age", style: text_style_n),
                              SizedBox(height: 5),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: ageController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addUserDetails(nameController.text.trim(), ageController.text,
                    user!.email.toString());
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                width: screenWidth - screenWidth / 7,
                height: screenHeight / 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), color: g),
                child: Center(
                    child: Text(
                  "Finish",
                  style: text_style_n.copyWith(
                      fontSize: 22, fontWeight: FontWeight.w900),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future addUserDetails(String name, String age, String email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'id': FirebaseAuth.instance.currentUser!.uid,
      "name": name,
      "age": age,
      "email": email,
    });
    _goToHome();
  }

  _goToHome() {
    // Navigate to the home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  void _showAvatarSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            color: Colors.transparent,
            height: 400,
            padding: EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: avatars.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = avatars[index];
                    });
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(avatars[index]),
                    radius: 30,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
