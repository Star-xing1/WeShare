# :bulb:跨多平台的知识社区软件WeShare

跨多平台的知识社区软件WeShare
[后端源代码](https://github.com/Star-xing1/weshare_backend)

:smiley:**前端项目**

欢迎界面展示：

<img src="https://s2.loli.net/2022/03/01/oND6Rtk4nFVTU81.jpg" style="zoom: 25%;" />

## :cookie:技术栈

使用Flutter(flutter SDK>=2.12.0 <3.0.0)框架开发(依赖包详见源码配置文件pubspec.yaml)

后端：SpringBoot、Redis、MySQL



## :lollipop:Features

1. **登录/注册**

基于后端Java Mail使用邮箱注册，并加密存储用户密码

2. **自动登录**

基于Hive数据库保持登录状态

3. **个人资料**

DIY个人信息、头像等

4. **动态发布、点赞、评论、状态更新**

随时随地发布动态，分享自己的知识、寻求帮助；点赞、评论他人推文寻求灵感的碰撞；为推文更新状态（已解决/未解决）帮助寻找有效信息

TIPS：增删查改工作均已完成

5. **社区**

根据需求精确/模糊搜索用户，查看TA的信息



## 安装使用

1. **使用本仓库Releases提供的APK直接安装**
2. **配置Flutter开发环境，确认flutter SDK版本>=2.12.0 <3.0.0**

键入 `flutter run --no-sound-null-safety`进入调试状态，将安装APP至连接的真机或模拟机中，键入 `flutter build apk --no-sound-null-safety` 打包APP生成APK，然后在build目录找到app-release.apk，此即为所需的发行版本。

> IOS版本敬请期待	~~其实是IOS有点麻烦~~



## 项目展示

见仓库中演示MP4



## 项目后续

项目持续开发中，本项目后续将会基于用户与推文的特点，引入基于NeuralCF的深度学习推荐模型为每位用户推荐最感兴趣的推文，同时将基于Kafka消息队列引入消息通知，使用分布式设计进一步优化并发量与响应速度等等。



## :cake:特别鸣谢

- abuanwar072 (GitHub)

- bimsina (GitHub)

- Ghana Tech Lab (GitHub)

- NSVEGUR (GitHub)
