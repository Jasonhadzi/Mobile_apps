import 'package:counter_app/models/user.dart';
import 'package:counter_app/screens/home/main_page.dart';
import 'package:counter_app/services/database.dart';
import 'package:counter_app/shared/constants.dart';
import 'package:counter_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  static const routeName = '/settings';
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  String error = '';
  String storeName = '';
  String area = '';
  int maxAmount = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Settings'),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Settings',
                          style: TextStyle(fontSize: 30),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Store Name'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter a name' : null,
                          onChanged: (val) {
                            setState(() {
                              storeName = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Area'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an area' : null,
                          onChanged: (val) {
                            setState(() {
                              area = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText:
                                  'Max amount of people inside the store'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter a number' : null,
                          onChanged: (val) {
                            setState(() {
                              maxAmount = int.parse(val);
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          color: Colors.blue[200],
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              try {
                                await DatabaseService(uid: user.uid)
                                    .updateUserData(storeName, area, maxAmount);

                                Navigator.pushNamed(
                                    context, MainPage.routeName);
                              } catch (e) {
                                setState(() {
                                  error = 'Please try again';
                                  loading = false;
                                });
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
