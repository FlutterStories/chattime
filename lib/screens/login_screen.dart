import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/my_button.dart';
import 'package:flash_chat/screens/chating_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
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
    controller.addListener(() {
      setState(() {
        // It's just to update the build method
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
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/checkin-1.jpg'),
              fit: BoxFit.cover,
              //colorFilter: ColorFilter.mode(Colors.white, BlendMode.dstATop),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 50,
                  width: double.infinity,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 100,
                    color: Colors.green.withOpacity(controller.value),
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
                      buttonName: "Login",
                      buttonColor: Colors.green.withOpacity(controller.value),
                      onTap: () async {
                        //TODO Add Login facility from firebase
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email!, password: password!);
                          if (user != null) {
                            Navigator.pushNamed(context, ChattingScreen.id);
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      buttonTextSize: controller.value * 25,
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
