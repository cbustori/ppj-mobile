import 'package:flutter/material.dart';

class PPJAppBar extends AppBar {
  final String titleName;
  final Widget trailingButton;
  final bool backButtonVisible;
  final Widget bottomTab;
  PPJAppBar(
      {this.titleName,
      this.backButtonVisible,
      this.trailingButton,
      this.bottomTab})
      : super(
          title: Text(titleName),
          bottom: bottomTab,
          automaticallyImplyLeading:
              backButtonVisible != null ? backButtonVisible : false,
          elevation: 0.1,
          actions: <Widget>[
            trailingButton != null ? trailingButton : Container()
          ],
        );
}
