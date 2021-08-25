import 'package:flash_chat/screens/chating_screen.dart';
import 'package:flutter/material.dart';
import '../my_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

class RegistrationScreen extends StatefulWidget {
  static final String id = "registration_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  String? email;
  String? password;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = ColorTween(begin: Colors.yellow, end: Colors.redAccent)
        .animate(controller);
    animation.addListener(() {
      setState(() {
        // It's here just to build state again and again when animation changes.
      });
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/registration.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Column(
              // blue column
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 70, right: 70),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    size: 100,
                    color: animation.value,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      // Email TextField
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (value) {
                          email = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.white38,
                        style: kTextFieldStyle,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: "Enter your email"),
                      ),
                    ),
                    Padding(
                      // Password TextField
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: true,
                        cursorColor: Colors.white38,
                        style: kTextFieldStyle,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: "Enter your password"),
                      ),
                    ),
                    LoginRegisButton(
                      buttonColor: animation.value,
                      buttonName: "Registration",
                      buttonTextSize: controller.value * 22,
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email!, password: password!);
                          if (newUser != null) {
                            Navigator.pushNamed(context, ChattingScreen.id);
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
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
}
