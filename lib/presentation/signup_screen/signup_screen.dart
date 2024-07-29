import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spenzy/core/app_export.dart';
import 'package:spenzy/widgets/custom_outlined_button.dart';
import 'package:spenzy/widgets/custom_text_form_field.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController userDetailsController = TextEditingController();
  final TextEditingController userCredentialsController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    SizedBox(height: 31.v),
                    Container(
                      decoration: AppDecoration.outlineBlackF,
                      child: Text(
                        "SPENZY",
                        style: theme.textTheme.displayLarge,
                      ),
                    ),
                    SizedBox(height: 55.v),
                    Text(
                      "SIGN UP",
                      style: theme.textTheme.displayMedium,
                    ),
                    SizedBox(height: 60.v),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 49),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildUserDetails(context),
                          _buildUserCredentials(context),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.v),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 49),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildPassword(context),
                          _buildConfirmPassword(context),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.v),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 49),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAge(context),
                          _buildSex(context),
                        ],
                      ),
                    ),
                    SizedBox(height: 28),
                    _buildEmail(context),
                    SizedBox(height: 63),
                    _buildCreateAccount(context),
                    SizedBox(height: 40),
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
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildUserDetails(BuildContext context) {
    return CustomTextFormField(
      width: 120.h,
      controller: userDetailsController,
      hintText: "Name",
      hintStyle: TextStyle(
        color: Color.fromRGBO(188, 188, 188, 0.22),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
    );
  }

  /// Section Widget
  Widget _buildUserCredentials(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 22.h),
      child: CustomTextFormField(
        width: 120.h,
        controller: userCredentialsController,
        hintText: "Username",
        hintStyle: TextStyle(
          color: Color.fromRGBO(188, 188, 188, 0.22),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a username';
          }
          return null;
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return CustomTextFormField(
      width: 120.h,
      controller: passwordController,
      hintText: "Password",
      textInputType: TextInputType.visiblePassword,
      obscureText: true,
      hintStyle: TextStyle(
        color: Color.fromRGBO(188, 188, 188, 0.22),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        return null;
      },
    );
  }

  /// Section Widget
  Widget _buildConfirmPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 22.h),
      child: CustomTextFormField(
        width: 120.h,
        controller: confirmPasswordController,
        hintText: "Confirm",
        textInputType: TextInputType.visiblePassword,
        obscureText: true,
        hintStyle: TextStyle(
          color: Color.fromRGBO(188, 188, 188, 0.22),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildAge(BuildContext context) {
    return CustomTextFormField(
      width: 120.h,
      controller: ageController,
      hintText: "Age",
      textInputType: TextInputType.number,
      hintStyle: TextStyle(
        color: Color.fromRGBO(188, 188, 188, 0.22),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your age';
        }
        return null;
      },
    );
  }

  /// Section Widget
  Widget _buildSex(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 22.h),
      child: Container(
        height: 62,
        width: 120.h,
        decoration: BoxDecoration(
          border: Border.all(color:appTheme.tealA400, width: 2.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: DropdownButtonFormField<String>(
          value: sexController.text.isNotEmpty ? sexController.text : null,
          onChanged: (String? value) {
            sexController.text = value ?? "";
          },
          items: <String>['Male', 'Female', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(value),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            hintText: "Sex",
            hintStyle: TextStyle(
              color: Color.fromRGBO(188, 188, 188, 0.22),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your sex';
            }
            return null;
          },
          dropdownColor: Color(0XFF272938),
          icon: SizedBox.shrink(),
          elevation: 16,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }


  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 50.h, right: 48.h),
      child: CustomTextFormField(
        controller: emailController,
        hintText: "Email",
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.emailAddress,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 17.v),
        hintStyle: TextStyle(
          color: Color.fromRGBO(188, 188, 188, 0.22),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an email';
          }
          if (!EmailValidator.validate(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildCreateAccount(BuildContext context) {
    return CustomOutlinedButton(
      height: 50,
      width: 140.h,
      text: "Create Account",
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          onTapCreateAccount(context);
        }
      },
    );
  }

  void onTapCreateAccount(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await userCredential.user!.updateDisplayName(userDetailsController.text);

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'age': int.parse(ageController.text),
        'sex': sexController.text,
        'username': userCredentialsController.text,
      });

      Navigator.pushNamed(context, AppRoutes.profileScreen);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
