import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void failAlert(String msg) {
  Fluttertoast.showToast(
      webBgColor: "linear-gradient(to right, #F44336, #F44336)",
      webPosition: "center",
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xffF44336),
      textColor: Colors.white,
      fontSize: 16.0);
}

Widget toast = Container(
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25.0),
    color: Colors.greenAccent,
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.check),
      SizedBox(
        width: 12.0,
      ),
      Text("This is a Custom Toast"),
    ],
  ),
);

void resultAlert(String msg) {
  Fluttertoast.showToast(
      webBgColor: "linear-gradient(to right, #F44336, #F44336)",
      webPosition: "center",
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xffF44336),
      textColor: Colors.white,
      fontSize: 16.0);
}

String dateFormat(String date) {
  String formattedDate = date.substring(0, 4) +
      '-' +
      date.substring(4, 6) +
      '-' +
      date.substring(6, 8);
  return formattedDate;
}

String phoneMaskingFormat(String phoneNumber) {
  String formattedPhone = '';
  if (phoneNumber.length == 11) {
    formattedPhone = phoneNumber.substring(0, 3) +
        '-***' +
        phoneNumber.substring(6, 7) +
        '-' +
        phoneNumber.substring(7, 11);
    // '-' +
    // phoneNumber.substring(7, 11);
  } else if (phoneNumber.length == 10) {
    formattedPhone = phoneNumber.substring(0, 3) +
        '-**' +
        phoneNumber.substring(5, 6) +
        '-' +
        phoneNumber.substring(6, 10);
    // '-' +
    // phoneNumber.substring(7, 11);
  } else {
    phoneNumber = '올바른 연락처 양식이 아닙니다.';
  }

  return formattedPhone;
}

String numberFormat(int number) {
  String formattedNumber =
      NumberFormat('###,###,###,###').format(number).replaceAll(' ', '');
  return formattedNumber;
}
