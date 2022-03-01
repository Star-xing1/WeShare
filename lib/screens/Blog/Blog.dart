import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:hive/hive.dart';
import 'package:lab4/screens/Welcome/welcome_screen.dart';
import 'package:lab4/utils/Date.dart';
import 'package:lab4/utils/URL.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:oktoast/oktoast.dart';
import 'package:unicons/unicons.dart';
import '../../constants.dart';
import 'components/poster_me.dart';
import 'components/poster_posts.dart';

// import 'components/ReadOnlyProfile.dart';

class Blog extends StatefulWidget {
  Blog({Key? key, required this.email}) : super(key: key);
  String email;

  @override
  BlogState createState() {
    return new BlogState();
  }
}

class BlogState extends State<Blog> {
  String email = '';
  String username = '';
  String _avaterURL = 'http://120.24.55.61:8080/images/defaultavatar.jpg';
  var postList = [];
  var infoList = [];
  Color mainColor = const Color(0xff3C3261);
  EasyRefreshController easyRefreshController = new EasyRefreshController();

  Future<String> getData() async {
    //获取数据
    String getUrl = baseURL + '/post/getAll';
    Dio dio = new Dio();

    var response = await dio.get(getUrl);

    print('POSTRespone ${response.statusCode}');

    if (response.statusCode == 200) {
      print(response.data);
      setState(() {
        postList = response.data;
      });
    } else {
      showToast("服务器或网络错误！");
    }
    return "OK";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    findByEmail();
    getData().then((result) async {
      print("同步");
      print(postList);
      String getUrl;
      Dio dio;
      int index = 0;
      while (index < postList.length) {
        getUrl = baseURL +
            '/profile/findByinfoId?infoId=' +
            postList[index]["infoId"].toString();
        dio = new Dio();

        var response = await dio.get(getUrl);
        if (response.statusCode == 200) {
          setState(() {
            infoList.add(response.data);
          });
        }
        index++;
      }
    });
    super.initState();
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
    if (infoList == null) return CircularProgressIndicator();
    print("开始");
    print(postList);
    return new Scaffold(
      backgroundColor: Colors.white,
      endDrawer: new Drawer(
          //侧面栏
          child: ListView(
        //一个列表// 抽屉可能在高度上超出屏幕，所以使用 ListView 组件包裹起来，实现纵向滚动效果
        // 干掉顶部灰色区域
        padding: EdgeInsets.all(0),
        // 所有抽屉中的子组件都定义到这里：
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(username,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            accountEmail: Text(email,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(_avaterURL),
            ),
            decoration: BoxDecoration(color: kDarkPrimaryThemeColor //背景图片
                ), //美化当前控件
          ),
          ListTile(
            title: Text('关于项目',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
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
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
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
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: new Text(
          'WeShare',
          style: new TextStyle(
              color: mainColor,
              fontFamily: 'Merienda',
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Builder(
            builder: (context) => CircleAvatar(
              child: new FlatButton(
                child: new Text(''),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
              backgroundImage: NetworkImage(
                  "http://120.24.55.61:8080/images/WeSharelogo.png"),
              radius: 20,
            ),
          ),
        ],
      ),
      body: EasyRefresh(
        controller: easyRefreshController,
        onRefresh: () async {
          postList.clear();
          getData().then((result) async {
            String getUrl;
            Dio dio;
            int index = 0;
            infoList.clear();
            print(infoList);
            while (index < postList.length) {
              getUrl = baseURL +
                  '/profile/findByinfoId?infoId=' +
                  postList[index]["infoId"].toString();
              dio = new Dio();

              var response = await dio.get(getUrl);
              if (response.statusCode == 200) {
                setState(() {
                  infoList.add(response.data);
                });
              }
              index++;
            }
          });
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
        child: ListView.separated(
            itemBuilder: (context, index) {
              return Card(
                elevation: 0,
                color: Theme.of(context).cardColor,
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                          child: new FlatButton(
                            child: new Text(''),
                            onPressed: () {
                              if (widget.email == infoList[index]['email']) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Posterme(
                                            email: infoList[index]['email'])));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Posterposts(
                                            email: infoList[index]['email'])));
                              }
                            },
                          ),
                          radius: 30,
                          backgroundImage:
                              NetworkImage(infoList[index]['path']),
                        ),
                        title: Text(infoList[index]['username'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                        subtitle: Text(
                            RelativeDateFormat.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                        postList[index]['createdAt'])
                                    .toLocal()),
                            // DateTime.fromMillisecondsSinceEpoch(postList[index]['createdAt']).toString().substring(0, 16),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)),
                        trailing: IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.more_horiz,
                              color: Theme.of(context).iconTheme.color,
                            )),
                      ),
                      postList[index]['description']!.isEmpty
                          ? const SizedBox.shrink()
                          : Text(
                              postList[index]['description']!,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              textAlign: TextAlign.left,
                            ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          postList[index]['img_url']!,
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: null,
                                  icon: Icon(UniconsLine.thumbs_up,
                                      color:
                                          Theme.of(context).iconTheme.color)),
                              IconButton(
                                  onPressed: null,
                                  icon: Icon(UniconsLine.comment_lines,
                                      color: Theme.of(context).iconTheme.color))
                            ],
                          ),
                          IconButton(
                              onPressed: null,
                              icon: Icon(
                                UniconsLine.telegram_alt,
                                color: Theme.of(context).iconTheme.color,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: postList.length),
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
      });
    } else {
      showToast("服务器或网络错误！");
    }
  }
}
