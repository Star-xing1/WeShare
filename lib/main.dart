import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lab4/screens/Splash/splash_screen.dart';
import 'package:lab4/utils/color.dart';
import 'package:oktoast/oktoast.dart';
import 'constants.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('logindata');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeShare',
      theme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.black),
          primaryColor: kPrimaryColor, //主题色
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: kPrimaryThemeColor,
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          inputDecorationTheme: const InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              labelStyle: TextStyle(color: Colors.black)),
          buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.dark(primary: Colors.white),
              textTheme: ButtonTextTheme.primary)),
      home: EntranceAnimationScreen(),
    ));
  }
}
