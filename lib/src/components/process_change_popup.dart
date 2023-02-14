import 'dart:io';

import 'package:bykak/src/components/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProcessChangePopup extends StatefulWidget {
  final String? title;
  final String? message;
  final Function(int selectedVal)? okCallback;
  final Function()? cancleCallback;

  const ProcessChangePopup(
      {Key? key,
      required this.title,
      required this.message,
      required this.okCallback,
      this.cancleCallback})
      : super(key: key);

  @override
  State<ProcessChangePopup> createState() => _ProcessChangePopupState();
}

class _ProcessChangePopupState extends State<ProcessChangePopup> {
  bool kisweb = true;
  @override
  void initState() {
    checkPlatform();
    super.initState();
  }

  void checkPlatform() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        kisweb = false;
      } else {
        kisweb = true;
      }
    } catch (e) {
      print('platform check error');
      kisweb = true;
    }
  }

  int _selectedIndex = 0;
  List processOptionList = [
    '상담중',
    '상담완료',
    '요척',
    '원부자재입고',
    '재단',
    '가봉중', //공장
    '가봉완료', // 공장
    '가봉출고', // 공장 > 테일러샵
    '가봉입고/수정', // 테일러샵  (수정 후 제작 Or 중가봉)
    '중가봉중', //공장
    '중가봉완료', // 공장
    '중가봉출고', // 공장 > 테일러샵
    '중가봉입고/수정', // 테일러샵  (수정 후 제작 Or 중가봉)
    '봉제/작업자확인',
    '작업중',
    '제작완료',
    '고객전달완료'
  ];
  List processColorList = [
    '#e9473a',
    '#eb958e',
    '#465af1',
    '#8ecbeb',
    '#efba3c',
    '#1f1972',
    '#703ae9',
    '#bc8eeb',
    '#d5bfeb',
    '#1f1972',
    '#703ae9',
    '#bc8eeb',
    '#d5bfeb',
    '#e6501c',
    '#e8764e',
    '#f0b19b',
    '#a3a3a3',
  ];

  @override
  Widget build(BuildContext context) {
    var widthVal = MediaQuery.of(context).size.width;
    var heightVal = MediaQuery.of(context).size.height;
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
              width: widthVal < 481 ? widthVal * 0.95 : 360,
              height: 600,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      widget.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      widget.message!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customRadio(processOptionList[0], 0),
                              customRadio(processOptionList[1], 1),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customRadio(processOptionList[2], 2),
                              customRadio(processOptionList[3], 3)
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customRadio(processOptionList[4], 4),
                              customRadio(processOptionList[5], 5)
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customRadio(processOptionList[6], 6),
                              customRadio(processOptionList[7], 7),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customRadio(processOptionList[8], 8),
                              customRadio(processOptionList[9], 9)
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customRadio(processOptionList[10], 10),
                              customRadio(processOptionList[11], 11)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.okCallback!(_selectedIndex);
                        Get.back();
                      },
                      child: Text('선택'),
                      style: TextButton.styleFrom(
                        primary: Colors.white, //글자색
                        onSurface: HexColor('#172543'), //onpressed가 null일때 색상
                        backgroundColor: HexColor('#172543'),
                        shadowColor: HexColor('#172543'), //그림자 색상
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
            ),
          ),
        ],
      ),
    );
  }

  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget customRadio(String text, int index) {
    var widVal = MediaQuery.of(context).size.width;

    return OutlinedButton(
      onPressed: () {
        changeIndex(index);
      },
      child: Text(text,
          style: TextStyle(
              fontSize: 12,
              color: _selectedIndex == index
                  ? HexColor('#FFFFFF')
                  : Colors.black87)),
      style: OutlinedButton.styleFrom(
        backgroundColor: _selectedIndex == index
            ? HexColor(processColorList[_selectedIndex])
            : Colors.transparent,
        //minimumSize: Size(Get.width * 0.45, 50), //최소 사이즈
        minimumSize: Size(130, 50), //최소 사이즈
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        side: BorderSide(
            width: _selectedIndex == index ? 3 : 1,
            color: _selectedIndex == index
                ? HexColor(processColorList[_selectedIndex])
                : Colors.black87),
      ),
    );
  }
}
