import 'package:book_story/pages/custom_drawer/home_drawer.dart';
import 'package:flutter/cupertino.dart';

class DrawerMenu {
  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;

  DrawerMenu({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });
}