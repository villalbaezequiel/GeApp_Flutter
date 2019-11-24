import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/ui/global/utils/text_style_utils.dart';
import 'package:voting_app/ui/splash_screen.dart';

import 'services/main_model.dart';
import 'ui/add_friend.dart';
import 'ui/escrutinio.dart';
import 'ui/friends_list.dart';
import 'ui/global/constant.dart';
import 'ui/help.dart';
import 'ui/home.dart';
import 'ui/login.dart';
import 'ui/my_voting_table.dart';
import 'ui/person.dart';
import 'ui/sign_up.dart';

Future main() async {
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
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
        title: 'Chubut al Frente',
        theme: ThemeData(
          primaryColor: Constant.primary,
          accentColor: Constant.ascent,
          scaffoldBackgroundColor: Constant.bgColor,
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(
              title: TextStyleUtils.bottonAndAppBarStyle,
            ),
          ),
          fontFamily: 'Helvetica',
        ),
        home: SplashScreen(model),
        routes: <String, WidgetBuilder>{
          '/home': (context) => Home(model),
          '/add_friend': (context) => AddFriend(model),
          '/friends_list': (context) => FriendsList(model),
          '/my_voting_table_list': (context) => MyVotingTableList(model),
          '/person_details': (context) => PersonDetails(model),
          '/escrutinio': (context) => Escrutinio(model),
          '/help': (context) => Help(),
          '/login': (context) => Login(model),
          '/sign_up': (context) => SignUp(model),
          '/splash_screen': (context) => SplashScreen(model),
        },
      ),
    );
  }
}
