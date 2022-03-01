import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:lab4/screens/Home/Home_screen.dart';
import 'package:lab4/screens/Welcome/welcome_screen.dart';
import 'package:lab4/utils/Check.dart';
import 'package:lab4/utils/URL.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:oktoast/oktoast.dart';
import 'package:unicons/unicons.dart';
import '../../constants.dart';

class MyProfile extends StatefulWidget {
  MyProfile({Key? key, required this.email}) : super(key: key);
  String email;

  @override
  MyProfileState createState() {
    return new MyProfileState();
  }
}

class MyProfileState extends State<MyProfile> {
  String email = '';
  String username = '';
  String _avaterURL = '';
  bool _status = true;
  String _asURL = 'http://120.24.55.61:8080/images/defaultavatar.jpg';

  final FocusNode myFocusNode = FocusNode();
  TextEditingController emailContr = new TextEditingController();
  TextEditingController usernameContr = new TextEditingController();
  TextEditingController nameContr = new TextEditingController();
  TextEditingController telephoneContr = new TextEditingController();
  TextEditingController ageContr = new TextEditingController();
  TextEditingController jobContr = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    findByEmail();
    super.initState();
  }

  @override
  void dispose() {
    // 销毁组件,释放内存
    myFocusNode.dispose();
    emailContr.dispose();
    usernameContr.dispose();
    nameContr.dispose();
    telephoneContr.dispose();
    ageContr.dispose();
    jobContr.dispose();

    super.dispose();
  }

  void Signout() async {
    print('退出账号');
    var box = Hive.box('logindata');
    box.put("signedIn", false);
    box.put("signedInMail", '');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) {
      return WelcomeScreen();
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              title: IconButton(
                  onPressed: () {
                    Navigator.pop(context, email);
                  },
                  icon: Icon(
                    UniconsLine.angle_left,
                    size: 30.0,
                  )),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(UniconsLine.setting),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              ],
              backgroundColor: Colors.white,
            ),
            preferredSize: Size.fromHeight(45)),
        endDrawer: Drawer(
            //侧面栏
            child: ListView(
          //一个列表// 抽屉可能在高度上超出屏幕，所以使用 ListView 组件包裹起来，实现纵向滚动效果
          // 干掉顶部灰色区域
          padding: EdgeInsets.all(0),
          // 所有抽屉中的子组件都定义到这里：
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(username,
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              accountEmail: Text(email,
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(_avaterURL),
              ),
              decoration: BoxDecoration(color: kDarkPrimaryThemeColor //背景图片
                  ), //美化当前控件
            ),
            ListTile(
              title: Text('关于项目',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              trailing: Icon(
                Icons.info,
                color: Colors.deepPurpleAccent,
              ),
              onTap: () {
                Dialogs.materialDialog(
                    color: Colors.white,
                    msg: '技术栈：Flutter+SpringBoot+MySQL\n\n（排名不分先后，按字母表排序）\n\n制作人：陈文洋、刘付星、唐纪斌\n\n'
                        '特别鸣谢：abuanwar072 (GitHub)\n                  '
                        'bimsina (GitHub)\n                  Ghana Tech Lab (GitHub)\n                  NSVEGUR (GitHub)',
                    title: '关于项目',
                    lottieBuilder: Lottie.asset(
                      'assets/congratulations.json',
                      fit: BoxFit.contain,
                    ),
                    context: context,
                    actions: [
                      IconsButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: '我知道了',
                        iconData: Icons.done,
                        color: Colors.blue,
                        textStyle: TextStyle(color: Colors.white),
                        iconColor: Colors.white,
                      ),
                    ]);
              },
            ),
            Divider(),
            ListTile(
              title: Text('退出',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              trailing: Icon(UniconsLine.signout, color: Colors.redAccent),
              onTap: () {
                Dialogs.materialDialog(
                    msg: '确定退出当前账号吗？',
                    title: "退出",
                    color: Colors.white,
                    context: context,
                    actions: [
                      IconsOutlineButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: '取消',
                        iconData: UniconsLine.cancel,
                        textStyle: TextStyle(color: Colors.grey),
                        iconColor: Colors.grey,
                      ),
                      IconsButton(
                        onPressed: () {
                          Signout();
                        },
                        text: '退出',
                        iconData: UniconsLine.sign_out_alt,
                        color: Colors.red,
                        textStyle: TextStyle(color: Colors.white),
                        iconColor: Colors.white,
                      ),
                    ]);
              },
            ),
          ],
        )),
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 250.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:
                              new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: new NetworkImage(_asURL),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _getAsEditIcon(),
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        '个人信息',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status
                                          ? _getEditIcon()
                                          : new Container(),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        '邮箱',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: "请输入您的电子邮件"),
                                      controller: emailContr,
                                      onChanged: (value) {
                                        print("inputEmail: " + value);
                                      },
                                      enabled: false,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        '用户名',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                        hintText: "请输入您的用户名",
                                      ),
                                      controller: usernameContr,
                                      onChanged: (value) {
                                        print("inputUsername: " + value);
                                      },
                                      enabled: !_status,
                                      autofocus: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        '姓名',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: "请输入您的姓名"),
                                      enabled: !_status,
                                      controller: nameContr,
                                      onChanged: (value) {
                                        print("inputName: " + value);
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        '电话',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: "请输入您的电话号码"),
                                      enabled: !_status,
                                      controller: telephoneContr,
                                      onChanged: (value) {
                                        print("inputTel: " + value);
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        '年龄',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        '工作',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: new TextField(
                                        decoration: const InputDecoration(
                                            hintText: "请输入您的年龄"),
                                        enabled: !_status,
                                        controller: ageContr,
                                        onChanged: (value) {
                                          print("inputAge: " + value);
                                        },
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: "请输入您的工作"),
                                      enabled: !_status,
                                      controller: jobContr,
                                      onChanged: (value) {
                                        print("inputJob: " + value);
                                      },
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          !_status ? _getActionButtons() : new Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("保存"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  //补充资料校验
                  if (!isUsername(usernameContr.text)) {
                    showToast("用户名为5~10位、英文字母开头;只包含英文字母、数字、下划线且至少有一个大写英文字母！",
                        position: ToastPosition.center,
                        backgroundColor: Colors.grey);
                  } else if (!isMobile(telephoneContr.text)) {
                    showToast("请输入正确的电话号码！",
                        position: ToastPosition.center,
                        backgroundColor: Colors.grey);
                  } else if (!isAge(ageContr.text)) {
                    showToast("请输入正确的年龄！",
                        position: ToastPosition.center,
                        backgroundColor: Colors.grey);
                  } else {
                    Dialogs.materialDialog(
                        msg: '你确定修改个人资料吗？',
                        title: "修改资料",
                        color: Colors.white,
                        context: context,
                        actions: [
                          IconsOutlineButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: '取消',
                            iconData: UniconsLine.cancel,
                            textStyle: TextStyle(color: Colors.grey),
                            iconColor: Colors.grey,
                          ),
                          IconsButton(
                            onPressed: () {
                              update();
                              Navigator.pop(context);
                              setState(() {
                                _status = true;
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              });
                            },
                            text: '确定',
                            iconData: UniconsLine.check_circle,
                            color: Colors.blueAccent,
                            textStyle: TextStyle(color: Colors.white),
                            iconColor: Colors.white,
                          ),
                        ]);
                  }
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("取消"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                    findByEmail();
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.deepPurpleAccent,
        radius: 14.0,
        child: new Icon(
          UniconsLine.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Widget _getAsEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.indigoAccent,
        radius: 20.0,
        child: new Icon(
          UniconsLine.image_edit,
          color: Colors.white,
          size: 18.0,
        ),
      ),
      onTap: () {
        getImage();
        // setState(() {
        //   _status = false;
        // });
      },
    );
  }

  //获取数据
  void findByEmail() async {
    print(widget.email);
    String findUrl = baseURL + '/profile/findByEmail?email=' + widget.email;
    Dio dio = new Dio();

    var response = await dio.get(findUrl);

    print('Respone ${response.statusCode}');
    print(response.data);
    if (response.statusCode == 200) {
      _avaterURL = response.data["path"];
      email = response.data["email"];
      username = response.data["username"];
      emailContr.text = response.data["email"];
      usernameContr.text = response.data["username"];
      nameContr.text = response.data["name"];
      telephoneContr.text = response.data["phone"];
      ageContr.text =
          (response.data["age"] == null) ? "" : response.data["age"].toString();
      jobContr.text = response.data["job"];
      setState(() {
        _asURL = response.data["path"];
      });
    } else {
      showToast("服务器或网络错误！");
    }
  }

  //修改
  void update() async {
    print('进入函数');
    String loginURL = baseURL + '/profile/update';
    Dio dio = new Dio();
    var response = await dio.post(loginURL, data: {
      "email": emailContr.text,
      "username": usernameContr.text,
      "name": nameContr.text,
      "phone": telephoneContr.text,
      "age": int.parse(ageContr.text), //转成int
      "job": jobContr.text
    });

    print('Respone ${response.statusCode}');
    print(response.data);
    if (response.statusCode == 200) {
      if (response.data.toString() == "succeed!") {
        showToast("资料更新成功！",
            position: ToastPosition.center, backgroundColor: Colors.grey);
      } else if (response.data.toString() == "The username has been used!") {
        showToast("更新失败，该用户名已经被使用！",
            position: ToastPosition.center, backgroundColor: Colors.grey);
      }
    } else {
      showToast("服务器或网络错误！");
      //试图重新获取数据以刷新页面
      findByEmail();
    }
    findByEmail();
  }

  //获取图片并上传
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    _upLoadImage(image); //上传图片
    findByEmail();
    setState(() {});
  }

  //上传图片
  void _upLoadImage(File image) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);

    FormData formdata = FormData.fromMap(
        {"file": await MultipartFile.fromFile(path, filename: name)});

    Dio dio = new Dio();
    var response = await dio.post<String>(
        baseURL + "/image/userinfo_update?email=" + widget.email,
        data: formdata);
    if (response.statusCode == 200) {
      if (response.data.toString() == "sucess") {
        showToast("头像更新成功！",
            position: ToastPosition.center, backgroundColor: Colors.grey);
      }
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
        return home(email: widget.email);
      }), (route) => false);

      findByEmail();
    }
  }
}
