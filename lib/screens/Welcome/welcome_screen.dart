import 'package:flutter/material.dart';
import 'package:lab4/constants.dart';
import 'package:lab4/screens/login/login_screen.dart';
import 'package:lab4/screens/SignUp/signup_screen.dart';
import 'package:lottie/lottie.dart';
import '../../../components/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blobs/blobs.dart';
import 'package:oktoast/oktoast.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  static const colorizeColors = [
    Colors.deepPurpleAccent,
    kDarkPrimaryThemeColor,
    kPrimaryThemeColor,
    kLightPrimaryThemeColor,
  ];
  static const colorizeTextStyle = TextStyle(
    fontSize: 35.0,
    fontFamily: 'Merienda',
    fontWeight: FontWeight.w900,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: -90,
            bottom: -100,
            child: Blob.random(
              size: 250,
              styles: BlobStyles(
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "WELCOME TO WeShare",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Flexible(child: Lottie.asset('assets/welcome.json')),
                Row(
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image.asset('images/earth.png'),
                        height: 100,
                      ),
                    ),
                    AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'WeShare',
                          textStyle: colorizeTextStyle,
                          colors: colorizeColors,
                        ),
                      ],
                      isRepeatingAnimation: true,
                      onTap: () {
                        print("Tap Event");
                        showToast("欢迎来到本项目，请开始你的奇妙之旅吧！",
                            backgroundColor: Colors.blueAccent);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 48.0,
                ),
                RoundedButton(
                  color: kSecondaryThemeColor,
                  title: '登 录',
                  onPressed: () {
                    Navigator.push(
                      //跳转到login界面
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "还没有账号!?",
                      style: TextStyle(
                        color: Color(0xFF6c757d),
                        fontFamily: 'NotoSans',
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpScreen();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        ' 立即注册',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'NotoSans',
                          fontSize: 20,
                          // decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            right: -90,
            top: -100,
            child: Blob.random(
              size: 250,
              styles: BlobStyles(
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
