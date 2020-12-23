import 'package:counter_app/models/user.dart';
import 'package:counter_app/screens/authentication/authenticate.dart';
import 'package:counter_app/screens/home/main_page.dart';
import 'package:counter_app/screens/home/settings_form.dart';
import 'package:counter_app/services/database.dart';
import 'package:counter_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  static const routeName = '/wrapper';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return FutureBuilder<dynamic>(
          future: DatabaseService(uid: user.uid).checkIfItsFirstTime(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == true) {
              return SettingsForm();
            } else if (snapshot.data == false) {
              return MainPage();
            } else {
              return Loading();
            }
          });
    }
  }
}
