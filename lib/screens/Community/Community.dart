import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lab4/screens/Blog/components/poster_me.dart';
import 'package:lab4/screens/Blog/components/poster_posts.dart';
import 'package:lab4/screens/Community/Manager.dart';
import 'package:lab4/utils/URL.dart';
import 'package:oktoast/oktoast.dart';
import 'package:unicons/unicons.dart';
import 'components/PersonCell.dart';

class Community extends StatefulWidget {
  Community({Key? key, required this.email}) : super(key: key);
  String email;

  @override
  CommunityState createState() {
    return new CommunityState();
  }
}

class CommunityState extends State<Community> {
  var personList = [];
  EasyRefreshController easyRefreshController = new EasyRefreshController();
  Color mainColor = const Color(0xff3C3261);

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

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: new Text(
          'Community',
          style: new TextStyle(
              color: mainColor,
              fontFamily: 'Merienda',
              fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Manager(email: widget.email)));
              },
              icon: Icon(
                UniconsLine.search,
                color: Colors.deepPurpleAccent,
              ))
        ],
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
                child: new PersonCell(i: i, persons: personList),
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
}
