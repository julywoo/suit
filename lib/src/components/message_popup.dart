import 'dart:io';

import 'package:bykak/src/components/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get.dart';

class MessagePopup extends StatefulWidget {
  final String? title;
  final String? message;
  final Function()? okCallback;
  final Function()? cancleCallback;

  const MessagePopup(
      {Key? key,
      required this.title,
      required this.message,
      required this.okCallback,
      this.cancleCallback})
      : super(key: key);

  @override
  State<MessagePopup> createState() => _MessagePopupState();
}

class _MessagePopupState extends State<MessagePopup> {
  bool kisweb = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthVal = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              width: widthVal < 481 ? widthVal * 0.95 : 420,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.message!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        child: ElevatedButton(
                          onPressed: widget.okCallback,
                          child: Text('??????'),
                          style: TextButton.styleFrom(
                            primary: Colors.white, //?????????
                            onSurface: Colors.white, //onpressed??? null?????? ??????
                            backgroundColor: HexColor('#172543'),
                            shadowColor: Colors.white, //????????? ??????
                            elevation: 1, // ?????? ?????????
                            textStyle: TextStyle(fontSize: 16),
                            //padding: EdgeInsets.all(16.0),
                            side: BorderSide(
                                color: HexColor('#172543'), width: 1.0), //???
                            shape:
                                StadiumBorder(), // : ????????????, CircleBorder : ??????????????????, StadiumBorder : ???????????? ????????????,
                            alignment: Alignment.center,
                          ), //???????????? ??????
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 140,
                        child: ElevatedButton(
                          onPressed: widget.cancleCallback, child: Text('??????'),
                          style: TextButton.styleFrom(
                            primary: HexColor('#172543'), //?????????
                            onSurface: Colors.white, //onpressed??? null?????? ??????
                            backgroundColor: Colors.white,
                            shadowColor: Colors.white, //????????? ??????
                            elevation: 1, // ?????? ?????????
                            textStyle: TextStyle(fontSize: 16),
                            //padding: EdgeInsets.all(16.0),
                            side: BorderSide(
                                color: HexColor('#172543'), width: 1.0), //???
                            shape:
                                StadiumBorder(), //BeveledRectangleBorder : ????????????, CircleBorder : ??????????????????, StadiumBorder : ???????????? ????????????,
                            alignment: Alignment.center,
                          ), //???????????? ??????
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
