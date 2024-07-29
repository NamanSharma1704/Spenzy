// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spenzy/core/app_export.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1D1F2C),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _signOut(context);
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFF1D1F2C),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "SPENZY",
                style: theme.textTheme.displayLarge,
              ),
            ),
            SizedBox(height: 20.0),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/img_unsplash_2lowvivhz_e.png'),
            ),
            SizedBox(height: 12.0),
            _buildUserInfo(context, "Name"),
            SizedBox(height: 12.0),
            _buildUserInfo(context, "Age"),
            SizedBox(height: 12.0),
            _buildUserInfo(context, "Sex"),
            SizedBox(height: 12.0),
            _buildUserInfo(context, "Email"),
            SizedBox(height: 24.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    // Add any other content here if needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        color: Color(0xFF1D1F2C),
        child: _buildRowWithImages(context),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, String label) {
    return FutureBuilder<DocumentSnapshot>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;

            String value = "";
            if (label == "Age" && data != null && data.containsKey('age')) {
              value = data['age'].toString();
            } else if (label == "Sex" && data != null && data.containsKey('sex')) {
              value = data['sex'];
            } else if (label == "Name") {
              value = FirebaseAuth.instance.currentUser?.displayName ?? "John Doe";
            } else if (label == "Email") {
              value = FirebaseAuth.instance.currentUser?.email ?? "john.doe@example.com";
            }

            return Container(
              decoration: BoxDecoration(
                color: Color(0xFF1D1F2C),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.teal),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              height: 40,
              child: Row(
                children: [
                  Text(
                    label + ": ",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(value, style: TextStyle(color: Colors.white)),
                ],
              ),
            );
          }
        } else {
          return Container(); // Placeholder container
        }
      },
    );
  }

  Future<DocumentSnapshot> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    }
    throw Exception('User is not authenticated');
  }


  // Call this method when the user updates their age, sex, and username

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login screen and remove all routes from the stack
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginScreen, (route) => false);
    } catch (e) {
      print("Error signing out: $e");
      // Show error dialog or message if sign out fails
    }
  }

  void onTapImgIconsHome(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.expenseChartScreen);
  }

  void onTapImgIconsList(BuildContext context) {
    // Check if the current page is already the list page
    if (ModalRoute.of(context)!.settings.name != AppRoutes.listScreen) {
      Navigator.pushNamed(context, AppRoutes.listScreen);
    }
  }

  void onTapImgIconsMaleUserFortyEight(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profileScreen);
  }

  Widget _buildRowWithImages(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            onTapImgIconsHome(context);
          },
          child: CustomImageView(
            imagePath: ImageConstant.imgIcons8Home482,
            height: 28,
            width: 28,
          ),
        ),
        GestureDetector(
          onTap: () {
            onTapImgIconsMaleUserFortyEight(context);
          },
          child: CustomImageView(
            imagePath: ImageConstant.imgIcons8MaleUser48,
            height: 28,
            width: 28,
          ),
        ),
        GestureDetector(
          onTap: () {
            onTapImgIconsList(context);
          },
          child: CustomImageView(
            imagePath: ImageConstant.imgIcons8List481,
            height: 28,
            width: 28,
          ),
        ),
      ],
    );
  }
}
