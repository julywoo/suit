import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// var f = NumberFormat('###,###,###,###');

// class NumberForamt extends NumberFormat {
//   NumberForamt(final String numberVal) : super(_getColorFromHex(numberVal));

//   static String _getColorFromHex(String numberVal) {
//     return f.format(numberVal);
//   }
// }

String moneyFormatText(String moneyVal) {
  if (moneyVal == null || moneyVal == "") {
    moneyVal = "0";
  } else {
    moneyVal = moneyVal;
  }
  int changeVal = int.parse(moneyVal);
  var _moneyFormat = NumberFormat('###,###,###,###,###');
  return _moneyFormat.format(changeVal);
}

String moneyFormat(int moneyVal) {
  if (moneyVal == null || moneyVal == "") {
    moneyVal = 0;
  } else {
    moneyVal = moneyVal;
  }
  var _moneyFormat = NumberFormat('###,###,###,###,###');
  return _moneyFormat.format(moneyVal);
}

final firestore = FirebaseFirestore.instance;
User? auth = FirebaseAuth.instance.currentUser;
String userType = "";
String tailorShop = "";
Future<String> getUserData() async {
  try {
    var userData =
        await firestore.collection('users').doc(auth!.email.toString()).get();

    tailorShop = userData['storeName'];
    return tailorShop.toString();
  } catch (e) {
    return tailorShop.toString();
  }
}
