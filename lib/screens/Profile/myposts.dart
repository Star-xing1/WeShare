import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lab4/screens/Profile/Profile.dart';
import 'package:lab4/utils/Date.dart';
import 'package:lab4/utils/URL.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:oktoast/oktoast.dart';
import 'package:unicons/unicons.dart';

class Myposts extends StatefulWidget {
  Myposts({Key? key, required this.email}) : super(key: key);
  String email;

  @override
  _MypostsState createState() => _MypostsState();
}

class _MypostsState extends State<Myposts> {
  var postList = [];
  String email = '';
  String username = '';
  String _avaterURL = 'http://120.24.55.61:8080/images/defaultavatar.jpg';
  int infoId = -1;
  EasyRefreshController easyRefreshController = new EasyRefreshController();
  @override
  void initState() {
    super.initState();
    getData();
  }

  _getRequests() async {
    print('进入函数');
    setState(() {
      findByEmail();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: false,
              pinned: true,
              expandedHeight: 320,
              flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                _avaterURL,
                fit: BoxFit.cover,
              )),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          // CircleAvatar(
                          //   radius: 40,
                          //   backgroundImage: NetworkImage(_avaterURL == null
                          //       ? "https://s2.loli.net/2021/12/22/vCLNSYTPoybF7Xu.jpg"
                          //       : _avaterURL),
                          // ),
                          TextButton(
                              style: ButtonStyle(
                                  //圆角
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.67))),
                                  //边框
                                  side: MaterialStateProperty.all(
                                    BorderSide(
                                        color: Colors.black, width: 0.67),
                                  ),
                                  //背景
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.indigoAccent)),
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyProfile(email: email)))
                                    .then((val) => _getRequests());
                              },
                              child: Text(
                                "查看/编辑资料",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14),
                              ))
                        ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        "我的推文",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff886EE4),
                          fontSize: 20,
                        ),
                      ),
                    ]),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(vertical: 10),
                    //     child: Text(
                    //       username,
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 20,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              )
            ]))
          ];
        },
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
                            radius: 30,
                            backgroundImage: NetworkImage(_avaterURL),
                          ),
                          title: Text(username,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
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
                              onPressed: () {
                                Dialogs.materialDialog(
                                    msg: '你确定吗？你不能撤销删除',
                                    title: "删除",
                                    color: Colors.white,
                                    context: context,
                                    actions: [
                                      IconsOutlineButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        text: '取消',
                                        iconData: UniconsLine.cancel,
                                        textStyle:
                                            TextStyle(color: Colors.grey),
                                        iconColor: Colors.grey,
                                      ),
                                      IconsButton(
                                        onPressed: () {
                                          deletepost(postList[index]['postid']);
                                          Navigator.pop(context);
                                          setState(() {
                                            getData();
                                          });
                                        },
                                        text: '删除',
                                        iconData: UniconsLine.trash_alt,
                                        color: Colors.red,
                                        textStyle:
                                            TextStyle(color: Colors.white),
                                        iconColor: Colors.white,
                                      ),
                                    ]);
                                // deletepost(postList[index]['postid']);
                                initState();
                              },
                              icon: Icon(
                                UniconsLine.trash_alt,
                                color: Colors.red,
                              )),
                        ),
                        postList[index]['description']!.isEmpty
                            ? const SizedBox.shrink()
                            : Text(
                                postList[index]['description']!,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
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
                                        color:
                                            Theme.of(context).iconTheme.color))
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
      ),
    ));
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
        infoId = response.data["infoId"];
      });
    } else {
      showToast("服务器或网络错误！");
    }
  }

  Future<String> getData() async {
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
        infoId = response.data["infoId"];
      });
    } else {
      showToast("服务器或网络错误！");
    }
    //获取数据
    String getUrl = baseURL + '/post/getByInfoId?infoId=' + infoId.toString();
    response = await dio.get(getUrl);

    print('POSTRespone ${response.statusCode}');

    if (response.statusCode == 200) {
      // showToast("succeed!",position:ToastPosition.center,
      //     backgroundColor: Colors.grey);
      print(response.data);
      setState(() {
        postList = response.data;
      });
    } else {
      showToast("服务器或网络错误！");
    }
    return "OK";
  }

  void deletepost(int postid) async {
    String deleteUrl =
        baseURL + '/post/deleteByPostId?postid=' + postid.toString();
    Dio dio = new Dio();

    var response = await dio.delete(deleteUrl);

    print('Respone ${response.statusCode}');
    print(response.data);
    if (response.statusCode == 200) {
      print("删除成功");
      showToast("删除成功！",
          position: ToastPosition.center, backgroundColor: Colors.grey);
    } else {
      showToast("服务器或网络错误！");
    }
  }
}
