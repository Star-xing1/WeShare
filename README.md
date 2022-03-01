# :bulb:WeShare

社交软件APP

:smiley:**前端项目**

欢迎界面展示：

<img src="https://s2.loli.net/2022/03/01/oND6Rtk4nFVTU81.jpg" style="zoom: 25%;" />

## :cookie:技术栈

使用Flutter(flutter SDK>=2.12.0 <3.0.0)框架开发(依赖包详见源码配置文件pubspec.yaml)

## :lollipop:Features

1. **登录/注册**

基于后端Java Mail使用邮箱注册

 	2. **自动登录**

基于hive数据库保持登录状态

3. **个人资料**

DIY个人信息、头像

4. **动态发布**

随时随地发布动态，分享自己的故事

5. **社区**

根据需求精确/模糊搜索用户，查看TA的信息

## 安装使用

1. **使用本仓库提供的APK直接安装**
2. **配置Flutter开发环境，确认flutter SDK版本>=2.12.0 <3.0.0**

键入 `flutter run --no-sound-null-safety`进入调试状态，将安装APP至连接的真机或模拟机中，键入 `flutter build apk --no-sound-null-safety` 打包APP生成APK，然后在build目录找到app-release.apk，此即为所需的发行版本。

> IOS版本敬请期待	~~其实是IOS有点麻烦~~

## 项目展示

[WeShare 应用展示_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1GP4y1E7Ge?p=1&share_medium=android&share_plat=android&share_session_id=e38efb1a-e5d3-490c-97ed-d823aa6ba3b0&share_source=QQ&share_tag=s_i&timestamp=1641435625&unique_k=sCykvFY)

## 项目结构

```
├─lib
│  │  constants.dart
│  │  main.dart
│  │
│  ├─components
│  │      account_check.dart
│  │      input_field.dart
│  │      password_field.dart
│  │      rounded_button.dart
│  │      text_field_container.dart
│  │
│  ├─screens
│  │  ├─Blog
│  │  │  │  Blog.dart
│  │  │  │  creat_post.dart
│  │  │  │  utils.dart
│  │  │  │
│  │  │  └─components
│  │  │          poster_detail.dart
│  │  │          poster_me.dart
│  │  │          poster_posts.dart
│  │  │
│  │  ├─Community
│  │  │  │  Community.dart
│  │  │  │  Manager.dart
│  │  │  │
│  │  │  └─components
│  │  │          PersonCell.dart
│  │  │          PersonInfo.dart
│  │  │          SearchBar.dart
│  │  │
│  │  ├─Home
│  │  │      Home_screen.dart
│  │  │
│  │  ├─Login
│  │  │      login_screen.dart
│  │  │
│  │  ├─Profile
│  │  │      myposts.dart
│  │  │      Profile.dart
│  │  │
│  │  ├─SignUp
│  │  │      background.dart
│  │  │      body.dart
│  │  │      or_divider.dart
│  │  │      signup_screen.dart
│  │  │      social_icon.dart
│  │  │
│  │  ├─Splash
│  │  │      splash_screen.dart
│  │  │
│  │  ├─VideoCall
│  │  │      VideoCall.dart
│  │  │      VideoPage.dart
│  │  │
│  │  └─Welcome
│  │          welcome_screen.dart
│  │
│  └─utils
│          Check.dart
│          Color.dart
│          Date.dart
│          URL.dart
```

总共 9 个主要的页面，依次是 Splash（加载页面）-> Welcome（欢迎界面）-> SignUp（注册界面）Login（登录界面）-> Blog（推文界面）create_post（发布界面）Community（社区界面）VideoCall（视频通话界面）Profile（个人资料界面）

## :cake:特别鸣谢

- abuanwar072 (GitHub)

- bimsina (GitHub)

- Ghana Tech Lab (GitHub)

- NSVEGUR (GitHub)
