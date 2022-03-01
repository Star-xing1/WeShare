import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lab4/utils/URL.dart';
import 'package:oktoast/oktoast.dart';
import 'package:unicons/unicons.dart';

import '../../../constants.dart';

class PosterProfile extends StatefulWidget {
  PosterProfile({Key? key, required this.email}) : super(key: key);
  String email;

  @override
  PosterProfileState createState() {
    return new PosterProfileState();
  }
}

class PosterProfileState extends State<PosterProfile> {
  String _asURL ='http://120.24.55.61:8080/images/defaultavatar.jpg';

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              automaticallyImplyLeading: false,
              title: IconButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  icon: Icon(
                    UniconsLine.angle_left,
                    size: 30.0,
                  )),
              backgroundColor: Colors.white,
            ),
            preferredSize: Size.fromHeight(45)),
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
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                            ),
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
                                          border: OutlineInputBorder(
                                        /*边角*/
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30), //边角为30
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.deepPurpleAccent,
                                          width: 5, //边线宽度
                                        ),
                                      )),
                                      controller: emailContr,
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
                                        border: OutlineInputBorder(
                                          /*边角*/
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30), //边角为30
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                Colors.deepPurpleAccent, //边线颜色
                                            width: 5, //边线宽度
                                          ),
                                        ),
                                      ),
                                      controller: usernameContr,
                                      enabled: false,
                                      autofocus: false,
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
                                        border: OutlineInputBorder(
                                          /*边角*/
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30), //边角为30
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                Colors.deepPurpleAccent, //边线颜色
                                            width: 5, //边线宽度
                                          ),
                                        ),
                                      ),
                                      enabled: false,
                                      controller: nameContr,
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
                                        border: OutlineInputBorder(
                                          /*边角*/
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30), //边角为30
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                Colors.deepPurpleAccent, //边线颜色
                                            width: 5, //边线宽度
                                          ),
                                        ),
                                      ),
                                      enabled: false,
                                      controller: telephoneContr,
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
                                          border: OutlineInputBorder(
                                            /*边角*/
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30), //边角为30
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors
                                                  .deepPurpleAccent, //边线颜色
                                              width: 5, //边线宽度
                                            ),
                                          ),
                                        ),
                                        enabled: false,
                                        controller: ageContr,
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30), //边角为30
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                Colors.deepPurpleAccent, //边线颜色
                                            width: 5, //边线宽度
                                          ),
                                        ),
                                      ),
                                      enabled: false,
                                      controller: jobContr,
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
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

  //获取数据
  void findByEmail() async {
    print(widget.email);
    String findUrl = baseURL + '/profile/findByEmail?email=' + widget.email;
    Dio dio = new Dio();

    var response = await dio.get(findUrl);

    print('Respone ${response.statusCode}');
    print(response.data);
    if (response.statusCode == 200) {
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
}
