import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

import '../constant.dart';
import 'root_scaffold.dart';

class CustomAppBar {
  static getAppBar(String title, BuildContext context) {
    return GradientAppBar(
      title: Text(title),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.5, 1.0],
        colors: [Constant.primary, Constant.ascent],
      ),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          RootScaffold.openDrawer(context);
        },
      ),
    );
  }
}
