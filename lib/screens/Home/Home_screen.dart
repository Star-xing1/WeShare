import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lab4/screens/Blog/Blog.dart';
import 'package:lab4/screens/Blog/creat_post.dart';
import 'package:lab4/screens/Community/Community.dart';
import 'package:lab4/screens/Profile/myposts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:dio/dio.dart';
import 'package:lab4/utils/URL.dart';
import 'package:unicons/unicons.dart';

class home extends StatefulWidget {
  home({Key? key, required this.email}) : super(key: key);
  String email;

  @override
  homeState createState() => homeState();
}

//自定义的主页
class homeState extends State<home> {
  String email = '';
  String username = '';
  String _avaterURL = 'http://120.24.55.61:8080/images/defaultavatar.jpg';
  int info_id = -1;
  @override
  void initState() {
    super.initState();
    findByEmail();
  }

  @override
  Widget build(BuildContext context) {
    // 在Flutter中的每一个类都是一个控件
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: Container(
          //底部导航栏
          //美化
          height: 50, //一般tabbar的高度为50
//        borderRadius: BorderRadius.circular(50),
          child: TabBar(
            unselectedLabelStyle:
                TextStyle(height: 0, fontSize: 10, color: Color(0xff886EE4)),
            tabs: <Widget>[
              Tab(
                  icon:
                      Icon(UniconsLine.rss_alt, color: Colors.deepPurpleAccent),
                  child: Text(
                    "动态",
                    style: TextStyle(
                        height: 0, fontSize: 10, color: Color(0xff886EE4)),
                  )),
              Tab(
                  icon: Icon(UniconsLine.plus_square,
                      color: Colors.deepPurpleAccent),
                  child: Text(
                    "发布",
                    style: TextStyle(
                        height: 0, fontSize: 10, color: Color(0xff886EE4)),
                  )),
              Tab(
                  icon: Icon(UniconsLine.users_alt,
                      color: Colors.deepPurpleAccent),
                  child: Text(
                    "社区",
                    style: TextStyle(
                        height: 0, fontSize: 10, color: Color(0xff886EE4)),
                  )),
              Tab(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(_avaterURL),
                  foregroundColor: Colors.deepPurpleAccent,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Blog(
              email: widget.email,
            ),
            CreatePostView(email: widget.email, info_id: info_id),
            Community(
              email: widget.email,
            ),
            Myposts(email: widget.email),
          ],
        ),
      ),
    );
  }

  void findByEmail() async {
    print(widget.email);
    String findUrl = baseURL + '/profile/findByEmail?email=' + widget.email;
    Dio dio = new Dio();

    var response = await dio.get(findUrl);

    print('Respone ${response.statusCode}');
    print(response.data);
    if (response.statusCode == 200) {
      setState(() {
        _avaterURL = response.data["path"];
        email = response.data["email"];
        username = response.data["username"];
        info_id = response.data["infoId"];
      });
    } else {
      showToast("服务器或网络错误！");
    }
  }
}
