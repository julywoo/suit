import 'dart:io';

import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get.dart';

class ConsultTypingPopup extends StatefulWidget {
  final String? title;
  final String? message;
  final Function(String returnVal)? okCallback;
  final Function()? cancleCallback;

  const ConsultTypingPopup(
      {Key? key,
      required this.title,
      required this.message,
      required this.okCallback,
      this.cancleCallback})
      : super(key: key);

  @override
  State<ConsultTypingPopup> createState() => _ConsultTypingPopupState();
}

class _ConsultTypingPopupState extends State<ConsultTypingPopup> {
  bool kisweb = true;
  @override
  void initState() {
    super.initState();
  }

  String returnVal = '';
  final controller = TextEditingController();
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
                  CustomTextFormField(hint: '', controller: controller),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              returnVal = controller.text.toString();
                            });
                            widget.okCallback!(returnVal);
                          },

                          child: Text('확인'),
                          style: TextButton.styleFrom(
                            primary: Colors.white, //글자색
                            onSurface: Colors.white, //onpressed가 null일때 색상
                            backgroundColor: HexColor('#172543'),
                            shadowColor: Colors.white, //그림자 색상
                            elevation: 1, // 버튼 입체감
                            textStyle: TextStyle(fontSize: 16),
                            //padding: EdgeInsets.all(16.0),
                            side: BorderSide(
                                color: HexColor('#172543'), width: 1.0), //선
                            shape:
                                StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                            alignment: Alignment.center,
                          ), //글자위치 변경
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 140,
                        child: ElevatedButton(
                          onPressed: widget.cancleCallback, child: Text('취소'),
                          style: TextButton.styleFrom(
                            primary: HexColor('#172543'), //글자색
                            onSurface: Colors.white, //onpressed가 null일때 색상
                            backgroundColor: Colors.white,
                            shadowColor: Colors.white, //그림자 색상
                            elevation: 1, // 버튼 입체감
                            textStyle: TextStyle(fontSize: 16),
                            //padding: EdgeInsets.all(16.0),
                            side: BorderSide(
                                color: HexColor('#172543'), width: 1.0), //선
                            shape:
                                StadiumBorder(), //BeveledRectangleBorder : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                            alignment: Alignment.center,
                          ), //글자위치 변경
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
