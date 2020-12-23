import 'package:counter_app/screens/authentication/register.dart';
import 'package:counter_app/screens/authentication/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // The number of tabs / content sections to display.
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Register'),
              Tab(text: 'Sign In'),
            ],
          ),
          title: Text('Customers Counter'),
        ),
        body: TabBarView(
          children: [
            Register(),
            SignIn(),
          ],
        ),
      ), // Complete this code in the next step.
    );
  }
}
