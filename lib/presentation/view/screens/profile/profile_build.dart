import 'package:flutter/material.dart';
import 'package:knack/presentation/view/screens/bottom_navigation_bar.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/style/text_style.dart';
import 'package:lottie/lottie.dart';

class BuildProfile extends StatefulWidget {
  BuildProfile({super.key});

  @override
  State<BuildProfile> createState() => _BuildProfileState();
}

class _BuildProfileState extends State<BuildProfile> {
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
              height: 130,
            ),
            LottieBuilder.asset("lib/assets/profile.json"),
            Text(
              "Create Profile !",
              style: text_style_h.copyWith(fontSize: 40),
            ),

            SizedBox(
              height: 20,
            ),
            // Avatar placeholder
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
                        offset:
                            Offset(0, 2), // Shadow position, vertically down
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        g, // Change to your desired background color
                    child: Icon(
                      Icons.person_add_alt_sharp,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                )),
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
                      style: text_style_h.copyWith(fontSize: 22)),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    style: text_style_h.copyWith(fontSize: 18),
                    // controller: ,
                    // validator: ,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.white,
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: g)),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: _goToHome,
                    style: ElevatedButton.styleFrom(
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      width: 370,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12), color: g),
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
        ),
      ),
    );
  }

  _goToHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => BottomNavBarScreen(),
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
                    // Handle avatar selection
                    // saveProfileData("User's Name", avatars[index]);
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
