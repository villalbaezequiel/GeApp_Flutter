import 'package:flutter/material.dart';

class RootScaffold {
  static openDrawer(BuildContext context) {
    final ScaffoldState scaffoldState =
        context.rootAncestorStateOfType(TypeMatcher<ScaffoldState>());
    scaffoldState.openDrawer();
  }

  static ScaffoldState of(BuildContext context) {
    final ScaffoldState scaffoldState =
        context.rootAncestorStateOfType(TypeMatcher<ScaffoldState>());
    return scaffoldState;
  }
}

class RootDrawer {
  static DrawerControllerState of(BuildContext context) {
    final DrawerControllerState drawerControllerState =
        context.rootAncestorStateOfType(TypeMatcher<DrawerControllerState>());
    return drawerControllerState;
  }
}
