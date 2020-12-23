import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_app/models/user.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  Future updateUserData(
      String storeName, String area, int maxAmountOfPeople) async {
    return await usersCollection.document(uid).setData({
      'storeName': storeName,
      'area': area,
      'maxAmountOfPeople': maxAmountOfPeople,
    });
  }

  //get specific document

  Future checkIfItsFirstTime() async {
    return await usersCollection
        .document(uid)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds['storeName'] == '' && ds['maxAmountOfPeople'] == 0) {
        print('user came for the 1st time');
        return true;
      } else {
        print('user has completed registration');
        return false;
      }
    });
  }

  Future addTransaction({String date}) async {
    dynamic previousSum;

    await usersCollection
        .document(uid)
        .collection('transactions')
        .document(date)
        .get()
        .then((DocumentSnapshot ds) async {
      ds.exists ? previousSum = ds['totalSum'] : previousSum = 0;

      return await usersCollection
          .document(uid)
          .collection('transactions')
          .document(date)
          .setData({'totalSum': previousSum + 1});
    });
    print(previousSum);
  }

  //userData from snapshots

  UserData _userDataFromSnapshots(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      area: snapshot.data['area'],
      storeName: snapshot.data['storeName'],
      maxAmountOfPeople: snapshot.data['maxAmountOfPeople'],
    );
  }

  //get user doc stream

  Stream<UserData> get userData {
    return usersCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshots);
  }
}
