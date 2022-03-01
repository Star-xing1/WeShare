import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:unicons/unicons.dart';
import '../../../constants.dart';
import '../../components/rounded_button.dart';
import 'package:lab4/utils/Check.dart';
import 'package:lab4/utils/URL.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:lab4/screens/SignUp/signup_screen.dart';
import 'package:lab4/screens/Home/Home_screen.dart';
import 'package:dio/dio.dart';
import 'package:blobs/blobs.dart';
import 'package:email_validator/email_validator.dart';
import 'package:oktoast/oktoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email = '';
  String password = '';
  TextEditingController mailTextController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  late FocusNode myFocusNode;
  @override
  void dispose() {
    mailTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();
  }

  TextEditingController passwordTextController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.keyboard_backspace_rounded),
          onPressed: () {
            //页面路由
            Navigator.of(context).pop(true);
          }),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(children: [
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(child: Lottie.asset('assets/login.json')),
                  TextFormField(
                    //focusNode: myFocusNode,
                    controller: mailTextController,
                    validator: (email) => !EmailValidator.validate('$email')
                        ? 'Enter a valid email'
                        : null,
                    autofillHints: [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: '请输入您的邮箱',
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    controller: passwordTextController,
                    obscureText: true,
                    validator: (pwd) => pwd.toString().length == 0
                        ? 'Password cannot be empty'
                        : null,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      prefixIcon: Icon(UniconsLine.lock),
                      hintText: '请输入您的密码',
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  RoundedButton(
                    color: kDarkPrimaryThemeColor,
                    title: '登 录',
                    onPressed: () async {
                      //校验
                      print("下面是Email校验");
                      if (!isEmail(email)) {
                        showToast("请保证邮箱正确！",
                            position: ToastPosition.center,
                            backgroundColor: Colors.grey);
                      } else if (password == null || password == "") {
                        showToast("密码不能为空！",
                            position: ToastPosition.center,
                            backgroundColor: Colors.grey);
                      } else {
                        print("try to Login");
                        login(email, password, context);
                      }
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
                          fontWeight: FontWeight.w100,
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
                            // decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

//登录页
void login(String email, String password, BuildContext context) async {
  String loginURL = baseURL + '/user/login';
  Dio dio = new Dio();

  var response =
      await dio.post(loginURL, data: {'email': email, 'password': password});
  print('Respone ${response.statusCode}');
  print(response.data);

  if (response.statusCode == 200) {
    //状态码200 请求是成功的
    if (response.data.toString() == "The email is not verified") {
      showToast("该邮箱未验证！",
          position: ToastPosition.center, backgroundColor: Colors.grey);
    } else if (response.data.toString() == "Incorrect password. Try again") {
      showToast("密码错误，请重试！",
          position: ToastPosition.center, backgroundColor: Colors.grey);
    } else if (response.data.toString() ==
        "Your Acount don't exist, Please register!") {
      showToast("该账号不存在，请先注册！",
          position: ToastPosition.center, backgroundColor: Colors.grey);
    } else if (response.data == "Succeed! Welcome back!") {
      // Navigator.pop(context);
      // Navigator.pop(context);
      // Navigator.push(context;
      //     MaterialPageRoute(builder: (context) => home(email: email)));
      var box = Hive.box('logindata');
      box.put("signedIn", true);
      box.put("signedInMail", email);
      showToast("登录成功! 欢迎来到WeShare！",
          position: ToastPosition.center, backgroundColor: Colors.grey);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
        return home(email: email);
      }), (route) => false);
    }
  } else {
    showToast("服务器或网络错误！");
  }
}
