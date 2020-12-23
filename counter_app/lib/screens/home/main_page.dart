import 'package:counter_app/models/user.dart';
import 'package:counter_app/screens/home/edit_form.dart';
import 'package:counter_app/services/auth.dart';
import 'package:counter_app/services/database.dart';
import 'package:counter_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main_page';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  int _n = 0;

  int totalSum = 0;

  void add(int maxValue) {
    setState(() {
      if (_n < maxValue) {
        _n++;
        totalSum = totalSum + 1;
        print(totalSum);
      }
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  void reset() {
    setState(() {
      _n = 0;
    });
  }

  currentProgressColor(double progress) {
    if (progress >= 0.6 && progress < 0.8) {
      return Colors.orange;
    }
    if (progress >= 0.8) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userdata = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text("Customers Counter"),
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: () async {
                        await _auth.signOut();
                      },
                      icon: Icon(Icons.person),
                      label: Text('Log Out'))
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(top: 35),
                        child: Text(userdata.storeName ?? '',
                            style: TextStyle(fontSize: 35.0))),
                    SizedBox(
                      height: 40,
                    ),
                    CircularPercentIndicator(
                      radius: 250.0,
                      lineWidth: 25.0,
                      percent: _n / (userdata.maxAmountOfPeople ?? 1),
                      animation: true,
                      animateFromLastPercent: true,
                      center: Text('$_n', style: TextStyle(fontSize: 60.0)),
                      progressColor: currentProgressColor(
                          _n / (userdata.maxAmountOfPeople ?? 0)),
                      circularStrokeCap: CircularStrokeCap.round,
                      footer: Text('Customer(s) inside the store',
                          style: TextStyle(fontSize: 25.0)),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: FloatingActionButton(
                            heroTag: 'btn1',
                            onPressed: minus,
                            child: Icon(
                                const IconData(0xe15b,
                                    fontFamily: 'MaterialIcons'),
                                color: Colors.black),
                            backgroundColor: Colors.blue[200],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: FloatingActionButton(
                            heroTag: 'btn2',
                            onPressed: () async {
                              add(userdata.maxAmountOfPeople);
                              print('total sum inside: $totalSum');
                              await DatabaseService(uid: userdata.uid)
                                  .addTransaction(
                                date: DateFormat("dd-MM-yyyy")
                                    .format(DateTime.now()),
                              );
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                            backgroundColor: Colors.blue[200],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    RaisedButton(
                      onPressed: reset,
                      child: Text(
                        'Reset',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      color: Colors.blue[200],
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'btn3',
                child: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, EditForm.routeName);
                },
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
