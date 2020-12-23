import 'package:counter_app/models/user.dart';
import 'package:counter_app/services/database.dart';
import 'package:counter_app/shared/constants.dart';
import 'package:counter_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditForm extends StatefulWidget {
  static const routeName = '/edit_form';
  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();

  String error = '';
  String _currentStoreName;
  String _currentArea;
  int _currentMaxAmount;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
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
                            'Edit Settings',
                            style: TextStyle(fontSize: 30),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue:
                                _currentStoreName ?? userData.storeName,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Store Name'),
                            validator: (val) =>
                                val.isEmpty ? 'Enter a name' : null,
                            onChanged: (val) {
                              setState(() {
                                _currentStoreName = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue: _currentArea ?? userData.area,
                            decoration:
                                textInputDecoration.copyWith(hintText: 'Area'),
                            validator: (val) =>
                                val.isEmpty ? 'Enter an area' : null,
                            onChanged: (val) {
                              setState(() {
                                _currentArea = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue:
                                userData.maxAmountOfPeople.toString() ??
                                    _currentMaxAmount.toString(),
                            decoration: textInputDecoration.copyWith(
                                hintText:
                                    'Max amount of people inside the store'),
                            validator: (val) =>
                                val.isEmpty ? 'Enter a number' : null,
                            onChanged: (val) {
                              setState(() {
                                _currentMaxAmount = int.parse(val);
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
                                try {
                                  await DatabaseService(uid: userData.uid)
                                      .updateUserData(
                                          _currentStoreName ??
                                              userData.storeName,
                                          _currentArea ?? userData.area,
                                          _currentMaxAmount ??
                                              userData.maxAmountOfPeople);

                                  Navigator.pop(context);
                                } catch (e) {
                                  setState(() {
                                    error = 'Please try again';
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
          } else {
            return Loading();
          }
        });
  }
}
