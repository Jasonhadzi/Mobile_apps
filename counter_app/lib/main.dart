import 'package:counter_app/models/user.dart';
import 'package:counter_app/screens/home/edit_form.dart';
import 'package:counter_app/screens/home/main_page.dart';
import 'package:counter_app/screens/home/settings_form.dart';
import 'package:counter_app/services/auth.dart';
import 'package:counter_app/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Wrapper(),
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          Wrapper.routeName: (context) => Wrapper(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          SettingsForm.routeName: (context) => SettingsForm(),
          MainPage.routeName: (context) => MainPage(),
          EditForm.routeName: (context) => EditForm(),
        },
      ),
    );
  }
}
