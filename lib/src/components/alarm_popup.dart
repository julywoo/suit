import 'dart:io';

import 'package:bykak/src/app.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get.dart';

class AlarmPopup extends StatefulWidget {
  final String? title;
  //final List? alarmList;
  //final String? message;
  final Function()? okCallback;
  final Function()? cancleCallback;

  const AlarmPopup(
      {Key? key,
      required this.title,
      //required this.alarmList,
      //required this.message,
      required this.okCallback,
      this.cancleCallback})
      : super(key: key);

  @override
  State<AlarmPopup> createState() => _AlarmPopupState();
}

class _AlarmPopupState extends State<AlarmPopup> {
  String _searchText = "";

  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool kisweb = true;
  bool resdState = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  final firestore = FirebaseFirestore.instance;
  User? auth = FirebaseAuth.instance.currentUser;
  String userName = "";
  List alarmList = [];

  getData() async {
    try {
      var alarmResult = await firestore
          .collection('alarms')
          .where('recvUserList', isEqualTo: auth!.email.toString())
          .where('readState', isEqualTo: "N")
          .orderBy('sendDate', descending: true)
          .get();

      for (var doc in alarmResult.docs) {
        setState(() {
          alarmList.add(doc);
        });
      }
    } catch (e) {}
  }

  void changeAlarmState(String docId, alarmList, index) {
    try {
      FirebaseFirestore.instance.collection('alarms').doc(docId).set({
        //'suitDesign': _suitDesign!.toJson(),
        'readState': "Y"
      }, SetOptions(merge: true));
    } catch (e) {}

    setState(() {
      alarmList[index]['readState'] == "Y";
    });

    // DocumentReference doc =
    //     FirebaseFirestore.instance.collection('alarms').doc(docId);

    // return FirebaseFirestore.instance
    //   ..runTransaction((transaction) async {
    //     DocumentSnapshot snapshot = await transaction.get(doc);
    //     if (!snapshot.exists) {
    //       throw Exception('Does not exists');
    //     }

    //     // //기존 갑을 가져와 1을 더해준다.
    //     // int currentLikes = snapshot.data()['likes'] + 1;
    //     String alarmReadState = "Y";

    //     //직접 값을 더하지 말고 transaction을 통해서 더하자!
    //     transaction.update(doc, {'readState': "Y"});
    //     return alarmReadState;
    //   });
    // try {
    //   FirebaseFirestore.instance.collection('alarms').doc(docId).update({
    //     //'suitDesign': _suitDesign!.toJson(),
    //     'readState': "Y"
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    var widthVal = MediaQuery.of(context).size.width;
    var heightVal = MediaQuery.of(context).size.height;
    //List alarmList = widget.alarmList!;
    return Material(
      color: Colors.transparent,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.white,
                //padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                width: widthVal < 481 ? widthVal * 0.95 : 420,
                height: heightVal * 0.9,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                              onPressed: widget.okCallback,
                              icon: Icon(Icons.close)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(top: 10),
                    //           child: TextField(
                    //             focusNode: focusNode,
                    //             style: TextStyle(fontSize: 16),
                    //             autofocus: true,
                    //             controller: _filter,
                    //             decoration: InputDecoration(
                    //                 filled: true,
                    //                 fillColor: Colors.white,
                    //                 prefixIcon: Icon(
                    //                   Icons.search,
                    //                   color: Colors.black87,
                    //                 ),
                    //                 hintText: '검색',
                    //                 labelStyle:
                    //                     TextStyle(color: Colors.black38),
                    //                 border: OutlineInputBorder(
                    //                     borderSide: BorderSide(
                    //                         color: HexColor('#172543')),
                    //                     borderRadius: BorderRadius.all(
                    //                         Radius.circular(10))),
                    //                 enabledBorder: OutlineInputBorder(
                    //                     borderSide: BorderSide(
                    //                         color: HexColor('#172543')),
                    //                     borderRadius: BorderRadius.all(
                    //                         Radius.circular(10))),
                    //                 focusedBorder: OutlineInputBorder(
                    //                     borderSide: BorderSide(
                    //                         color: HexColor('#172543')),
                    //                     borderRadius: BorderRadius.all(
                    //                         Radius.circular(10)))),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    alarmList.length < 1
                        ? Expanded(
                            flex: 1,
                            child: Container(
                                child: Center(
                              child: Text('알림이 없습니다.'),
                            )),
                          )
                        : Expanded(
                            child: ListView.separated(
                            itemCount: alarmList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                color: alarmList[index]['readState'] == "Y"
                                    ? Colors.black12
                                    : Colors.white,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                // color: Colors.amber,
                                child: GestureDetector(
                                  onTap: () {
                                    changeAlarmState(
                                        alarmList[index]
                                            .reference
                                            .id
                                            .toString(),
                                        alarmList,
                                        index);
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              alarmList[index]['sendUser'] +
                                                  '님으로부터 알림',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              alarmList[index]['sendDate'],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          alarmList[index]['sendMsg'],
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        // Text(alarmList[0].reference.id),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                              height: 0.5,
                              color: Colors.black26,
                            ),
                          )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
