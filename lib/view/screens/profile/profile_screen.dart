import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knack/view/screens/collections.dart';
import 'package:knack/view/style/text_style.dart';
import 'package:knack/view/widgets/custom_snackbar.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  late String _userName;
  late String _userEmail;
  late int _userAge;


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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenHeight / 15,
                      ),
                      Text(
                        'Profile',
                        style: text_style_h,
                      ),
                      profileBox('Name', _userName),
                      profileBox('Email', _userEmail),
                      profileBox('Age', _userAge.toString()),
                      SizedBox(height: screenHeight / 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.black)),
                            onPressed: () {
                              _editProfile(context);
                            },
                            child: Text('Edit Profile'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget profileBox(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      padding: EdgeInsets.all(12.0),

      decoration: BoxDecoration(
        color: g,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          TextFormField(
            readOnly: true, // Disable editing
            controller:
                TextEditingController(text: value), // Use TextEditingController
            style: TextStyle(fontSize: 16), // Set text style
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none, // Remove border
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context) async {
    final TextEditingController nameController =
        TextEditingController(text: _userName);
    final TextEditingController ageController =
        TextEditingController(text: _userAge.toString());

    final result = await showDialog(

      context: context,
      builder: (context) => AlertDialog(
        elevation: 20,
        backgroundColor: Color.fromARGB(255, 238, 238, 238),
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              textInputAction: TextInputAction.next,
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              onChanged: (value) {
                setState(() {
                  _userName = value;
                });
              },
            ),
            SizedBox(height: 8.0),
            TextField(
              keyboardType: TextInputType.number,
              controller: ageController,
              decoration: InputDecoration(
                labelText: 'Age',
              ),
              onChanged: (value) {
                setState(() {
                  _userAge = int.tryParse(value) ?? _userAge;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateProfile();
              Navigator.pop(context, 'Save');
            },
            child: Text('Save'),
          ),
        ],
      ),
    );

    print('Dialog result: $result');
  }

  void _updateProfile() async {
    try {
      // Update user profile in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.user.email)
          .limit(1)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          String documentId = querySnapshot.docs.first.id;
          FirebaseFirestore.instance
              .collection('users')
              .doc(documentId)
              .update({
            'name': _userName,
            'age': _userAge,
          }).then((_) {
            setState(() {
              // Update local state variables
              _userName = _userName;
              _userAge = _userAge;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(content: 'Profile updated successfully!')
                  as SnackBar, // Use CustomSnackBar
            );
            print('Profile updated successfully!');
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(content: 'Failed to update profile: $error')
                  as SnackBar, // Use CustomSnackBar
            );
            print('Failed to update profile: $error');
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(content: 'User document not found!')
                as SnackBar, // Use CustomSnackBar
          );
          print('User document not found!');
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(content: 'Error updating profile: $error')
            as SnackBar, // Use CustomSnackBar
      );
      print('Error updating profile: $error');
    }
  }
}
