import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:knack/presentation/utils/loading_widget.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/style/text_style.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _userName;
  late String _userEmail;
  late String _userAge;
  late String _avatar;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    String userEmail = widget.user.email!;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      setState(() {
        _userName = userData['name'];
        _userEmail = userEmail;
        _userAge = userData['age'];
        _avatar = userData['avatar'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: _isLoading
            ? Center(
                child: LoadingWidget(
                option: 1,
              ))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight / 8,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: screenWidth - screenWidth / 4,
                            height: screenHeight / 2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://i.pinimg.com/564x/2e/68/c0/2e68c0a20083097aeb2c5db03ab4a0d6.jpg",
                                  ),
                                  fit: BoxFit.cover),
                              border: Border.all(
                                  color: const Color.fromARGB(255, 57, 57, 57)
                                      .withOpacity(.4)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                Container(
                                    width: screenWidth / 5,
                                    child: Image.network(_avatar)),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name",
                                      style: text_style_n,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextViewWidget(
                                        screenWidth: screenWidth,
                                        userName: _userName),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      style: text_style_n,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextViewWidget(
                                        screenWidth: screenWidth,
                                        userName: _userEmail),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Age",
                                      style: text_style_n,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextViewWidget(
                                        screenWidth: screenWidth,
                                        userName: _userAge),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              height: screenHeight / 9,
                              bottom: screenHeight / 3,
                              right: screenWidth / 4,
                              child: InkWell(
                                onTap: () {
                                  _editProfile(context);
                                },
                                child: CircleAvatar(
                                    maxRadius: 15,
                                    backgroundColor: g.withOpacity(.8),
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                    )),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }

  Widget _buildProfileItem(String label, String value) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile(BuildContext context) async {
    final TextEditingController nameController =
        TextEditingController(text: _userName);
    final TextEditingController ageController =
        TextEditingController(text: _userAge.toString());
    final String avatar = _avatar;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                        child: Image.network(
                          _avatar,
                          fit: BoxFit.cover,
                          width: 90,
                          height: 90,
                        ))),
              ],
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "choose an avatar",
              style: text_style_h.copyWith(fontSize: 15),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  _userName = value;
                });
              },
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              onChanged: (value) {
                setState(() {
                  _userAge = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateProfile();
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _updateProfile() async {
    try {
      // Update user profile in Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.user.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String documentId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(documentId)
            .update({
          'name': _userName,
          'age': _userAge,
          'avatar': _avatar,
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User document not found!')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $error')));
    }
  }

 void _showAvatarSelectionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String selectedAvatar = _avatar;
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
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
                        selectedAvatar = avatars[index];
                      });
                      this.setState(() {
                        _avatar = avatars[index];
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(avatars[index]),
                      radius: 30,
                      child: selectedAvatar == avatars[index]
                          ? Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    },
  );
}

}

class TextViewWidget extends StatelessWidget {
  const TextViewWidget({
    super.key,
    required this.screenWidth,
    required String userName,
  }) : _userName = userName;

  final double screenWidth;
  final String _userName;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(minWidth: screenWidth / 2, maxWidth: screenWidth / 2),
      child: IntrinsicWidth(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromARGB(255, 57, 57, 57).withOpacity(.4)),
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                _userName,
                style: text_style_n.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '$_userName\'s Profile',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  Image.network(_avatar),
                  SizedBox(height: 20.0),
                  _buildProfileItem('Name', _userName),
                  _buildProfileItem('Email', _userEmail),
                  _buildProfileItem('Age', _userAge.toString()),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () => _editProfile(context),
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            ), */