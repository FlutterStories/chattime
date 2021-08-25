import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registeration_screen.dart';
import 'package:flutter/material.dart';
import '../my_button.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    controller.forward();
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    animation.addListener(() {
      setState(() {
        // This must have to call so that changes can occur in the app.
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/chattime.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.auto_awesome,
                size: animation.value * 100,
                color: Colors.deepOrange,
              ),
              Row(
                children: [
                  MyButton(
                    name: "Login",
                    onPressed: () {
                      // Takes us to login page
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                  ),
                  SizedBox(width: 10),
                  MyButton(
                    name: "Sign Up",
                    onPressed: () {
                      // Takes us to registration page
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
