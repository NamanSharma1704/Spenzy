// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:spenzy/core/app_export.dart';
import 'package:spenzy/widgets/custom_outlined_button.dart';
import 'package:spenzy/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 31),
                Container(
                  decoration: AppDecoration.outlineBlackF,
                  child: Text(
                    "SPENZY",
                    style: theme.textTheme.displayLarge,
                  ),
                ),
                SizedBox(height: 56),
                Text(
                  "LOG IN",
                  style: theme.textTheme.displayMedium,
                ),
                SizedBox(height: 64),
                CustomTextFormField(
                  width: 290,
                  controller: userNameController,
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(188, 188, 188, 0.22),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 16,
                  ),
                ),
                SizedBox(height: 40),
                CustomTextFormField(
                  width: 290,
                  controller: passwordController,
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(188, 188, 188, 0.22),
                  ),
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.visiblePassword,
                  obscureText: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 16,
                  ),
                ),
                SizedBox(height: 7),
                GestureDetector(
                  onTap: () {
                    onTapForgotPassword(context);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 80),
                      child: Text(
                        "Forgotten Password ?",
                        style: CustomTextStyles.bodySmallJura,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Center(
                  child: CustomOutlinedButton(
                    height: 45,
                    width: 183,
                    text: "Log In",
                    onPressed: () {
                      onTapLogin(context);
                    },
                  ),
                ),
                SizedBox(height: 11),
                GestureDetector(
                  onTap: () {
                    onTapTxtCreateAccount(context);
                  },
                  child: Text(
                    "Create Account .",
                    style: CustomTextStyles.bodySmallJura,
                  ),
                ),
                SizedBox(height: 210),
                CustomImageView(
                  imagePath: ImageConstant.imgOutputOnlinepn,
                  height: 52,
                  width: 52,
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Navigates to the profileScreen when the action is triggered.
  void onTapLogin(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userNameController.text,
        password: passwordController.text,
      );

      // If login is successful, navigate to the next screen
      Navigator.pushNamed(context, AppRoutes.expenseChartScreen);

    } catch (e) {
      // If there is an error with login, show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
  /// Navigates to the signupScreen when the action is triggered.
  void onTapTxtCreateAccount(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.signupScreen);
  }

  /// Navigates to the reset password screen when the action is triggered.
  void onTapForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.resetPasswordScreen);
  }
}
