import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:weshare/screens/Blog/components/poster_detail.dart';
import 'package:weshare/screens/Blog/components/poster_me.dart';
import 'package:weshare/screens/Blog/components/poster_posts.dart';
import 'package:weshare/utils/Date.dart';
import 'package:weshare/utils/URL.dart';
import 'package:oktoast/oktoast.dart';
import 'package:unicons/unicons.dart';

import '../../../constants.dart';

class PostDetail extends StatefulWidget {
  PostDetail({Key? key, required this.postID,required this.email}) : super(key: key);
  int  postID;
  String email;

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  var postList = [];
  String email = '';
  String username = '';
  String _avaterURL = 'http://120.24.55.61:8080/images/defaultavatar.jpg';
  int infoID = -1;
  var giveLikeList=[];
  var likeList=[];
  var infoList=[];
  Color mainColor = const Color(0xff3C3261);
  EasyRefreshController easyRefreshController = new EasyRefreshController();


  @override
  void initState() {
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
        //获取每篇推文的点赞列表
        getUrl = baseURL +
            '/post/allLikes?postId=' +
            postList[index]["postid"].toString();
        dio = new Dio();

        response = await dio.get(getUrl);
        if (response.statusCode == 200) {
          print(response.data["data"]);
          if(response.data["data"]["likeList"]!=null)
          {
            int pos=0;int flag=0;
            while(pos<response.data["data"]["likeList"].length)
            {
              if(response.data["data"]["likeList"][pos]["userId"]==infoID)
              {
                flag=1;
                setState(() {
                  giveLikeList.add(1);
                });
              }
              pos++;
            }
            if(flag==0)
            {
              setState(() {
                giveLikeList.add(0);
              });
            }
          }
          else
          {
            setState(() {
              giveLikeList.add(0);
            });
          }
          setState(() {
            likeList.add(response.data);
          });
        }
        index++;

      }
    });
    super.initState();
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
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(
              UniconsLine.angle_left,
              size: 30.0,
            )),
        title: new Text(
          '详情',
          style: new TextStyle(
              color: mainColor,
              fontFamily: 'Merienda',
              fontWeight: FontWeight.bold),
        )
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
    email: infoList[index]['email'],myemail: widget.email,)));
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
    infoList[index]['job']+"   "+RelativeDateFormat.format(
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
    height: 300,
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
                onPressed: ()
                async {
                  if(giveLikeList[index]==0)
                    {
                      String likeUrl = baseURL + '/post/like';
                      Dio dio = new Dio();
                      FormData formData = FormData.fromMap({"userId": infoID, "postId": postList[index]["postid"]});
                      var response = await dio.post(likeUrl,data: formData);
                      if (response.statusCode == 200) {
                        setState(() {
                          giveLikeList[index]=1;
                          postList[index]["likes"]++;
                        });
                        showToast("点赞成功！");
                      } else {
                        showToast("服务器或网络错误！");
                      }
                    }
                  else
                    {
                      String dislikeUrl = baseURL + '/post/disableLike';
                      Dio dio = new Dio();
                      FormData formData = FormData.fromMap({"userId": infoID, "postId": postList[index]["postid"]});
                      var response = await dio.delete(dislikeUrl,data: formData);
                      if (response.statusCode == 200) {
                        setState(() {
                          giveLikeList[index]=0;
                          postList[index]["likes"]--;
                        });
                        showToast("取消点赞成功！");
                      } else {
                        showToast("服务器或网络错误！");
                      }
                    }
                },
                icon: Icon(giveLikeList[index]==0?Icons.thumb_up_off_alt:Icons.thumb_up,
                   //giveLikeList[index]==0?Icons.thumb_up_off_alt:Icons.thumb_up,
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
    ),
    Row(
    children: [
    Text(postList[index]["likes"].toString()+"人觉得很赞",
    style: TextStyle(
    color: kSecondaryThemeColor,
    fontFamily: 'Merienda',
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    ),)
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
        infoID = response.data["infoId"];
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
        infoID = response.data["infoId"];
      });
    } else {
      showToast("服务器或网络错误！");
    }
    //获取数据
    String getUrl = baseURL + '/post/getByPostId?postId='+ widget.postID.toString();
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
}
