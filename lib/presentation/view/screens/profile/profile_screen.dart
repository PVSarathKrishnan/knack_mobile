import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:knack/presentation/utils/loading_widget.dart';
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
                      child: Container(
                        width: screenWidth - screenWidth / 4,
                        height: screenHeight / 2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                "https://i.pinimg.com/564x/56/e8/31/56e831d1ca7f230b57ef96bd564c18a8.jpg",
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
                              height: 10,
                            ),
                            Container(
                                width: screenWidth / 5,
                                child: Image.network(_avatar)),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                width: screenWidth / 2.5,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                                255, 57, 57, 57)
                                            .withOpacity(.4)),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _userName,
                                    style: text_style_n,
                                  ),
                                )),
                            SizedBox(height: 20.0),
                            _buildProfileItem('Email', _userEmail),
                            _buildProfileItem('Age', _userAge.toString()),
                          ],
                        ),
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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