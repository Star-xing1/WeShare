import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:lab4/screens/Blog/components/poster_me.dart';
import 'package:lab4/screens/Blog/components/poster_posts.dart';
import 'package:lab4/utils/URL.dart';
import 'package:oktoast/oktoast.dart';
import 'package:unicons/unicons.dart';

import 'components/SearchBar.dart';

class Manager extends StatefulWidget {
  Manager({Key? key, required this.email}) : super(key: key);
  String email;

  @override
  ManagerState createState() {
    return new ManagerState();
  }
}

class ManagerState extends State<Manager> {
  var personList = [];
  Color mainColor = const Color(0xff3C3261);
  late String searchUsername;
  EasyRefreshController easyRefreshController = new EasyRefreshController();

  void getData() async {
    //获取数据
    String getUrl = baseURL + '/profile/findAll';
    Dio dio = new Dio();

    var response = await dio.get(getUrl);

    print('Respone ${response.statusCode}');

    if (response.statusCode == 200) {
      setState(() {
        //必须要通过这个来更新数据,否则将不会刷新页面
        personList = response.data;
      });
    } else {
      showToast("服务器或网络错误！");
    }
  }

  void _Search(dynamic) async {
    if (searchUsername == null || searchUsername == "") {
      //获取数据
      String getUrl = baseURL + '/profile/findAll';
      Dio dio = new Dio();

      var response = await dio.get(getUrl);

      print('Respone ${response.statusCode}');

      if (response.statusCode == 200) {
        setState(() {
          //必须要通过这个来更新数据,否则将不会刷新页面
          personList = response.data;
        });
      }
    } else {
      print("Searching");
      print("Text:" + searchUsername);
      //获取数据
      String getUrl =
          baseURL + '/profile/findByUsernameLike?username=' + searchUsername;
      Dio dio = new Dio();

      var response = await dio.get(getUrl);

      print('Respone ${response.statusCode}');

      if (response.statusCode == 200) {
        setState(() {
          //必须要通过这个来更新数据,否则将不会刷新页面
          personList = response.data;
        });
      } else {
        showToast("服务器或网络错误！");
      }
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new SearchBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              UniconsLine.angle_left,
              size: 30.0,
            )),
        onChanged: (value) {
          setState(() {
            searchUsername = value;
          });
        },
        onSearch: _Search,
      ),
      body: EasyRefresh(
        controller: easyRefreshController,
        onRefresh: () async {
          getData();
          // 设置两秒后关闭刷新，时间可以随便设置，根据项目需求，正常在请求成功后，也要关闭
          await Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              // 控制器关闭刷新功能
              easyRefreshController.finishRefresh(success: true);
            });
          });
        },
        // onLoad: () async {
        //   // 设置两秒后关闭加载，时间可以随便设置，根据项目需求，正常在请求成功后，也要关闭
        //   await Future.delayed(const Duration(seconds: 1), () {
        //     setState(() {
        //       // 控制器关闭加载功能，还可以设置没有更多数据noMore，可以根据需求自己变更，这里同样也需要在数据请求成功进行关闭。
        //       easyRefreshController.finishLoad(success: true);
        //     });
        //   });
        // },
        header: MaterialHeader(),
        // footer: MaterialFooter(),
        child: new ListView.builder(
            itemCount: personList == null ? 0 : personList.length,
            itemBuilder: (context, i) {
              return new FlatButton(
                child: getManagerCell(i, personList),
                padding: const EdgeInsets.all(0.0),
                onPressed: () {
                  print(personList[i]['path']);
                  if (widget.email == personList[i]['email']) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Posterme(email: personList[i]['email'])));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Posterposts(email: personList[i]['email'])));
                  }
                },
                color: Colors.white,
              );
            }),
      ),
    );
  }

  Widget getManagerCell(i, persons) {
    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(0.0),
              child: new Container(
                margin: const EdgeInsets.all(16.0),
                child: new Container(
                  width: 70.0,
                  height: 70.0,
                ),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  color: Colors.grey,
                  image: new DecorationImage(
                      image: new NetworkImage(persons[i]["path"] == null
                          ? defaultAsURL
                          : persons[i]["path"]),
                      fit: BoxFit.cover),
                  boxShadow: [
                    new BoxShadow(
                        color: mainColor,
                        blurRadius: 5.0,
                        offset: new Offset(2.0, 5.0))
                  ],
                ),
              ),
            ),
            new Expanded(
                child: new Container(
              margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: new Column(
                children: [
                  new Text(
                    persons[i]['username'],
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Arvo',
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  new Padding(padding: const EdgeInsets.all(2.0)),
                  new Text(
                    persons[i]['email'],
                    maxLines: 3,
                    style: new TextStyle(
                        color: const Color(0xff8785A4), fontFamily: 'Arvo'),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            )),
          ],
        ),
        new Container(
          width: 300.0,
          height: 0.5,
          color: const Color(0xD2D2E1ff),
          margin: const EdgeInsets.all(16.0),
        )
      ],
    );
  }
}
