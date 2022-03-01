import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

const kSecondaryThemeColor = Color(0xff886EE4);
const kPrimaryThemeColor = Color(0xfff3f4f9);
const kDarkPrimaryThemeColor = Color(0xff886EE4);
const kLightPrimaryThemeColor = Color(0xff886EE4);
const kAccentColor = Color(0xFF000000);
const kSecondaryTextColor = Color(0xFF545454);
const kBlobColor = Color(0xFFADB5BD);

const kMessageTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    hintText: '  Gossip here...',
    fillColor: kLightPrimaryThemeColor,
    filled: true,
    hintStyle: TextStyle(
      fontFamily: 'NotoSans',
      color: kSecondaryTextColor,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide.none,
    ));

const kTextFieldDecoration = InputDecoration(
  prefixIcon: Icon(
    UniconsLine.envelope,
  ),
  focusColor: Colors.white,
  hintText: 'Enter a value',
  hintStyle: TextStyle(fontFamily: 'NotoSans', color: kBlobColor),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: UnderlineInputBorder(),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kBlobColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kBlobColor, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);
const kSearchTextFieldDecoration = InputDecoration(
  prefixIcon: Icon(
    Icons.search,
    color: Colors.black,
    size: 30,
  ),
  hintText: 'Search by mail',
  hintStyle: TextStyle(fontFamily: 'NotoSans', color: Colors.black),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: InputBorder.none,
);
