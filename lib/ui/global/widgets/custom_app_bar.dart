import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

import '../constant.dart';

class CustomAppBar {
  static getAppBar(BuildContext context, Widget titleWidget) {
    return GradientAppBar(
      title: titleWidget,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.5, 1.0],
        colors: [Constant.primary, Constant.ascent],
      ),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          // RootScaffold.openDrawer(context);
        },
      ),
    );
  }
}
