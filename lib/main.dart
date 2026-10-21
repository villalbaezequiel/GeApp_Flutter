import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/ui/global/utils/text_style_utils.dart';
import 'package:voting_app/ui/splash_screen.dart';

import 'services/main_model.dart';
import 'ui/scpl_client_fetch.dart';
import 'ui/add_friend.dart';
import 'ui/escrutinio.dart';
import 'ui/friends_list.dart';
import 'ui/global/utils/constant.dart';
import 'ui/help.dart';
import 'ui/home.dart';
import 'ui/login.dart';
import 'ui/my_voting_table.dart';
import 'ui/reset_password.dart';
import 'ui/sign_up.dart';

void main() async {
  runApp(MyApp());

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    MainModel model = MainModel();
    return ScopedModel(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GeApp',
        theme: ThemeData(
          primaryColor: Constant.primary,
          scaffoldBackgroundColor: Constant.bgColor,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Constant.ascent,
          ),
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyleUtils.bottonAndAppBarStyle,
          ),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(foregroundColor: Colors.white),
        ),
        home: SplashScreen(model),
        routes: <String, WidgetBuilder>{
          '/home': (context) => Home(model),
          '/scpl/fetch_client': (context) => ScplFetchClient(model),
          '/add_friend': (context) => AddFriend(model),
          '/friends_list': (context) => FriendsList(model),
          '/my_voting_table_list': (context) => MyVotingTableList(model),
          '/escrutinio': (context) => Escrutinio(model),
          '/help': (context) => Help(),
          '/login': (context) => Login(model),
          '/reset_password': (context) => ResetPassword(model),
          '/sign_up': (context) => SignUp(model),
          '/splash_screen': (context) => SplashScreen(model),
        },
      ),
    );
  }
}
