import 'package:book_story/pages/custom_drawer/home_drawer.dart';
import 'package:flutter/cupertino.dart';

class DrawerMenu {
  DrawerMenu({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
}