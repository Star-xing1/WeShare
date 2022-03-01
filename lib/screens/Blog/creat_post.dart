import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lab4/constants.dart';
import 'package:lab4/screens/Home/Home_screen.dart';
import 'package:lab4/utils/URL.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:oktoast/oktoast.dart';
import './utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicons/unicons.dart';

class CreatePostView extends StatefulWidget {
  CreatePostView({Key? key, required this.email, required this.info_id})
      : super(key: key);
  String email;
  int info_id;

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController _postTxtController = TextEditingController();

  File? _postImageFile;
  late String postimg_url;
  bool isLoading = false;

  ///select image from camera or gallery
  selectImage(ImageSource imageSource) async {
    var file = await ImagePicker.pickImage(source: imageSource);
    File? croppedFile = await myImageCropper(file.path);
    setState(() {
      _postImageFile = croppedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '分享你的新鲜事',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : TextButton(
                  onPressed: () async {
                    if (_postImageFile != null) {
                      Dialogs.materialDialog(
                          msg: '你确定发布推文吗？',
                          title: "发布",
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
                                setState(() {
                                  isLoading = true;
                                });
                                _upLoadImage(_postImageFile!).then((result) {
                                  submitPost(postimg_url,
                                      _postTxtController.text, widget.info_id);
                                });
                                Navigator.pop(context);
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              text: '确定',
                              iconData: UniconsLine.check_circle,
                              color: Colors.blueAccent,
                              textStyle: TextStyle(color: Colors.white),
                              iconColor: Colors.white,
                            ),
                          ]);
                    } else {
                      //no image file selected
                      showToast("请选择一张图片！",
                          position: ToastPosition.center,
                          backgroundColor: Colors.grey);
                    }
                  },
                  child: const Text(
                    'Share',
                    style: TextStyle(
                      color: kSecondaryThemeColor,
                      fontFamily: 'Merienda',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '选择一张图片',
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              selectImage(ImageSource.camera);
                            },
                            icon: const Icon(UniconsLine.camera),
                            label: const Text('拍照')),
                        const Divider(),
                        TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              selectImage(ImageSource.gallery);
                            },
                            icon: const Icon(UniconsLine.picture),
                            label: const Text('从相册选择')),
                      ],
                    );
                  });
            },
            child: _postImageFile == null
                ? Image.asset(
                    'assets/placeholder.jpg',
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    _postImageFile!,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            minLines: 1,
            maxLines: 10,
            controller: _postTxtController,
            decoration: InputDecoration(
                hintText: '请输入你的描述',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: Icon(
                  Icons.add_comment,
                  color: Colors.deepPurple,
                ),
                enabledBorder: OutlineInputBorder(
                  /*边角*/
                  borderRadius: BorderRadius.all(
                    Radius.circular(30), //边角为30
                  ),
                  borderSide: BorderSide(
                    color: Colors.black, //边线颜色为黄色
                    width: 2, //边线宽度为2
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.green, //边框颜色为绿色
                  width: 5, //宽度为5
                )),
                label: Text(
                  '描述',
                  style: Theme.of(context).textTheme.bodyText1,
                )),
          )
        ],
      ),
    );
  }

  //上传图片
  Future _upLoadImage(File image) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);

    FormData formdata = FormData.fromMap(
        {"file": await MultipartFile.fromFile(path, filename: name)});

    Dio dio = new Dio();
    var response = await dio.post<String>(
        baseURL + "/image/postimg_upload?email=" + widget.email,
        data: formdata);
    if (response.statusCode == 200) {
      showToast("图片上传成功！",
          position: ToastPosition.center, backgroundColor: Colors.grey);
    }
    setState(() {
      postimg_url = response.data!;
    });
  }

  Future<void> submitPost(
      String img_url, String description, int info_id) async {
    print(info_id);
    Dio dio = new Dio();
    var response = await dio.post<String>(baseURL + "/post/create", data: {
      'img_url': img_url,
      'description': description,
      'infoId': info_id
    });
    if (response.statusCode == 200) {
      showToast(response.data.toString(),
          position: ToastPosition.center, backgroundColor: Colors.grey);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => home(email: widget.email)));
    } else {
      showToast("上传失败！",
          position: ToastPosition.center, backgroundColor: Colors.grey);
    }
  }
}
