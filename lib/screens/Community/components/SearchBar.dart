import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  SearchBar({
    Key? key,
    required this.leading,
    this.hintText: '请输入用户名',
    required this.onChanged,
    required this.onSearch,
  }) : super(key: key);
  // 最前面的组件
  final Widget leading;

  // 提示文字
  final String hintText;

  // 输入框内容改变
  final ValueChanged onChanged;

  // 点击键盘搜索
  final ValueChanged onSearch;

  @override
  _SearchBarState createState() => _SearchBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  // 取消输入框编辑
  void _onCancelInput() {
    setState(() {
      _controller.clear();
      _focusNode.unfocus();
    });
  }

  void _onInputChanged(String value) {
    setState(() {});
    if (widget.onChanged != null) widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);
    final ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;
    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    double left = 0;
    double right = 0;
    if (!canPop && !hasDrawer && widget.leading == null) left = 15;
    if (_controller.text.isEmpty) right = 15;
    return AppBar(
      titleSpacing: 0,
      leading: widget.leading,
      title: Container(
        margin: EdgeInsets.only(right: right, left: left),
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.search,
                size: 22,
                color: Color(0xFF999999),
              ),
            ),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                controller: _controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: widget.hintText ?? '请输入关键字',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF999999),
                  ),
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF333333),
                  height: 1.3,
                ),
                textInputAction: TextInputAction.search,
                onChanged: _onInputChanged,
                onSubmitted: widget.onSearch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
