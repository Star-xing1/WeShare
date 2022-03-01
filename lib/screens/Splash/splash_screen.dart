import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lab4/screens/Home/Home_screen.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:lab4/constants.dart';
import 'package:lab4/screens/Welcome/welcome_screen.dart';

class EntranceAnimationScreen extends StatefulWidget {
  static const String id = "entrance_animation_screen";
  @override
  _EntranceAnimationScreenState createState() =>
      _EntranceAnimationScreenState();
}

class _EntranceAnimationScreenState extends State<EntranceAnimationScreen> {
  bool signInAutomatically = false;
  String email = '';
  @override
  void initState() {
    print('............calling auto sign in.........');
    autoSignIn();
    super.initState();
  }

  autoSignIn() async {
    var box = Hive.box('logindata');
    signInAutomatically = box.get("signedIn",defaultValue: false);
    email = box.get("signedInMail",defaultValue: '');
    print(
        '................................signInAutoMatically: $signInAutomatically...................');
    print('signedInMail: $email');
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      backgroundColor: Colors.white,
      image: Image.asset('assets/splashLogo.gif'),
      loaderColor: Colors.white,
      photoSize: 160,
      loadingText: Text(
        'WeShare',
        style: TextStyle(
            color: kSecondaryThemeColor,
            fontFamily: 'Merienda',
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      navigateAfterSeconds:
          signInAutomatically ? home(email: email) : WelcomeScreen(),
      useLoader: false,
    );
  }
}
