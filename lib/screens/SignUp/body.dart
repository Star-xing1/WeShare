import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lab4/constants.dart';
import 'package:lab4/Screens/Login/login_screen.dart';
import 'package:unicons/unicons.dart';
import './background.dart';
import './or_divider.dart';
import './social_icon.dart';
import 'package:lab4/components/rounded_button.dart';
import 'package:lab4/components/input_field.dart';
import 'package:lab4/components/password_field.dart';
import 'package:lab4/utils/Check.dart';
import 'package:lab4/utils/URL.dart';
import 'package:lab4/utils/color.dart';
import 'package:oktoast/oktoast.dart';

//import '../../Home/Home.dart';

TextEditingController _editingController = new TextEditingController();

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String yzmText = "获取验证码";
  late Timer countDownTimer;
  String email = "";
  String username = "";
  String password = "";
  TextEditingController makeSureControl = new TextEditingController();
  String token = "";
  @override
  void dispose() {
    // TODO: implement dispose
    countDownTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Flexible(child: Lottie.asset('assets/register.json')),
            Text(
              "注册",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            // SvgPicture.asset(
            //   "assets/icons/signup.svg",
            //   height: size.height * 0.35,
            // ),
            RoundedInputField(
              hintText: "邮箱",
              icon: UniconsLine.envelope,
              onChanged: (value) {
                email = value;
              },
            ),
            RoundedInputField(
              hintText: "用户名",
              icon: UniconsLine.user,
              onChanged: (value) {
                username = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                password = value;
              },
              myHintText: "密码",
              myController: _editingController,
            ),
            RoundedPasswordField(
              myController: makeSureControl,
              myHintText: "确认密码",
              onChanged: (String value) {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 35.0)),
                Expanded(
                  child: RoundedInputField(
                    hintText: "验证码",
                    icon: UniconsLine.comment_alt_verify,
                    onChanged: (value) {
                      token = value;
                    },
                  ),
                ),
                Expanded(
                  child: RoundedButton(
                    title: yzmText,
                    color: colorButton2,
                    onPressed: () {
                      //校验
                      if (yzmText == '获取验证码') {
                        print("下面是signup校验");
                        if (!isEmail(email)) {
                          showToast('请保证邮箱正确！',
                              position: ToastPosition.center,
                              backgroundColor: Colors.grey);
                        } else if (!isUsername(username)) {
                          // showToast("请按照规则输入用户名");
                          showToast("用户名为5~10位、英文字母开头;只包含英文字母、数字、_且至少有一个大写英文字母！",
                              position: ToastPosition.center,
                              backgroundColor: Colors.grey);
                        } else if (!isPassword(password)) {
                          showToast("密码为6~12位且只包含英文字母、数字和下划线！",
                              position: ToastPosition.center,
                              backgroundColor: Colors.grey);
                        } else if (!(makeSureControl.text == password)) {
                          makeSureControl.clear();
                          showToast("请确认第二次输入与第一次输入相同!",
                              position: ToastPosition.center,
                              backgroundColor: Colors.grey);
                        } else {
                          print("try to send");
                          if (yzmText == "获取验证码") {
                            yzmGet();
                            send();
                          }
                        }
                      }
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 40.0)),
              ],
            ),
            RoundedButton(
              title: "注册",
              color: kSecondaryThemeColor,
              onPressed: () {
                //注册
                SignUp(context);
              },
            ),
            SizedBox(height: size.height * 0.03),
            // AlreadyHaveAnAccountCheck(
            //   login: false,
            //   press: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) {
            //           return LoginScreen();
            //         },
            //       ),
            //     );
            //   },
            // ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  //注册
  void SignUp(BuildContext context) async {
    String loginURL = baseURL + '/user/register';
    Dio dio = new Dio();

    var response = await dio.post(loginURL + "?token=" + token,
        data: {'email': email, 'password': password, "username": username});

    print('Respone ${response.statusCode}');
    print(response.data);

    if (response.statusCode == 200) {
      if (response.data.toString() == "The user already exists!") {
        showToast("邮箱已注册！",
            position: ToastPosition.center, backgroundColor: Colors.grey);
      } else if (response.data.toString() ==
          "Wrong verification code!Please try again") {
        showToast("验证码错误，请重试！",
            position: ToastPosition.center, backgroundColor: Colors.grey);
      } else if (response.data.toString() ==
          "Please Send verification code first!") {
        showToast("请先输入验证码！",
            position: ToastPosition.center, backgroundColor: Colors.grey);
      } else if (response.data == "Sign up is successful!") {
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.push(context;
        //     MaterialPageRoute(builder: (context) => home(email: email)));
        showToast("注册成功！",
            position: ToastPosition.center, backgroundColor: Colors.grey);
        Navigator.push(
          //跳转到login界面
          context,
          MaterialPageRoute(
            //自带动画 向上滑动并淡出，推出相反
            builder: (context) {
              return LoginScreen();
            },
          ),
        );
      }
    } else {
      showToast("服务器或网络错误！");
    }
  }

  //发生验证码
  void send() async {
    String sendURL = baseURL + "/user/send";
    Dio dio = new Dio();
    print("username:" + username);
    var response = await dio.post(sendURL,
        data: {'email': email, 'password': password, "username": username});
    print('Respone ${response.statusCode}');
    print(response.data);
    //成功发生送验证码
    if (response.data != 'The mail has been sent!') {
      setState(() {
        yzmText = '获取验证码';
        countDownTimer.cancel();
      });
    }
    if (response.statusCode == 200) {
      showToast(response.data.toString(),
          position: ToastPosition.center, backgroundColor: Colors.grey);
      token = response.data.toString();
    } else {
      showToast("服务器或网络错误！");
    }
  }

  yzmGet() {
    //countDownTimer.cancel();//如果已存在先取消置空
    countDownTimer = new Timer.periodic(new Duration(seconds: 1), (t) {
      setState(() {
        if (60 - t.tick > 0) {
          //60-t.tick代表剩余秒数，如果大于0，设置yzmText为剩余秒数，否则重置yzmText，关闭countTimer
          yzmText = "${60 - t.tick}秒后重新发送";
        } else {
          yzmText = '获取验证码';
          countDownTimer.cancel();
        }
      });
    });
  }
}
