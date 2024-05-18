import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:knack/presentation/view/screens/bottom_navigation_bar.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/main_page.dart';
import 'package:knack/presentation/view/style/text_style.dart';
import 'package:knack/presentation/view/widgets/custom_snackbar.dart';

class BuildProfile extends StatefulWidget {
  final String email;
  final String password;
  BuildProfile({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  State<BuildProfile> createState() => _BuildProfileState();
}

class _BuildProfileState extends State<BuildProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _selectedAvatar; // Variable to hold the selected avatar URL

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0XFFF1F1F1),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: screenHeight / 20,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            // LottieBuilder.asset(
            //   "lib/assets/profile.json",
            //   width: screenWidth / 2,
            //   height: screenHeight / 6,
            // ),
            SvgPicture.asset(
              "lib/assets/profile.svg",
              width: screenHeight / 5,
              height: screenHeight / 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create Profile !",
                  style: text_style_h.copyWith(fontSize: screenWidth / 18),
                ),
                Text(
                  "Ready to create",
                  style: text_style_n.copyWith(fontSize: screenWidth / 25),
                ),
                Text(
                  "your unique profile?",
                  style: text_style_n.copyWith(fontSize: screenWidth / 25),
                ),
              ],
            ),
          ]),

          // Avatar placeholder
          Column(
            children: [
              GestureDetector(
                  onTap: () {
                    _showAvatarSelectionDialog(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    
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
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            "choose an avatar",
            style: text_style_h.copyWith(fontSize: 15),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text("What should we call you ?",
                    style: text_style_h.copyWith(fontSize: 18)),
                Row(
                  children: [
                    Expanded(
                      flex:
                          2, // Adjust the flex value according to your preference
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name",
                              style: text_style_n.copyWith(
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _nameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth / 25),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Age",
                              style: text_style_n.copyWith(
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            controller: _ageController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _adduser;
                    _goToHome();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 25,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    width: 370,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5), color: g),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Let's get started",
                          style: text_style_n.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w900),
                        ),
                        Icon(
                          Icons.navigate_next,
                          size: 30,
                        )
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  _goToHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => MainPage(),
    ));
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

  Future addUserDetails(
      String name, int age, String email, String? avatar) async {
    if (avatar == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Avatar can't be Empty")));
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: widget.password);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "id": FirebaseAuth.instance.currentUser!.uid,
        "name": name,
        "avatar": avatar,
        "age": age.toString(),
        "email": email
      });
    } on FirebaseException catch (e) {
      CustomSnackBar(content: e.toString());
    }
  }

  void _adduser() {
    addUserDetails(_nameController.text.trim(), int.parse(_ageController.text),
        widget.email, _selectedAvatar);
  }
}
