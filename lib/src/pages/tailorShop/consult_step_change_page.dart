import 'package:bykak/src/pages/tailorShop/consult_step_change_detail_page.dart';

import 'package:bykak/src/widget/custom_elevated_buttod.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConsultStepChange extends StatefulWidget {
  ConsultStepChange({Key? key}) : super(key: key);

  @override
  State<ConsultStepChange> createState() => _ConsultStepChangeState();
}

class _ConsultStepChangeState extends State<ConsultStepChange> {
  String _selectedOption = "";
  List optionsList = ['자켓', '조끼', '바지', '셔츠', '코트'];

  @override
  void initState() {
    _selectedOption = optionsList[0];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black),
            ),
            elevation: 2,
            title: Text(
              '상담 옵션 관리',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              width: 400,
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customRadio('자켓', 0),
                          customRadio('조끼', 1),
                          customRadio('바지', 2),
                          customRadio('셔츠', 3),
                          customRadio('코트', 4),
                        ],
                      ),
                      flex: 4,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 50),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              width: 360,
                              //로그아웃 버튼
                              // width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white, //글자색
                                  onSurface:
                                      Colors.white, //onpressed가 null일때 색상
                                  backgroundColor: HexColor('#172543'),
                                  shadowColor: Colors.white, //그림자 색상
                                  elevation: 1, // 버튼 입체감
                                  textStyle: TextStyle(fontSize: 16),
                                  //padding: EdgeInsets.all(16.0),
                                  minimumSize: Size(300, 50), //최소 사이즈
                                  side: BorderSide(
                                      color: HexColor('#172543'),
                                      width: 1.0), //선
                                  shape:
                                      StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                  alignment: Alignment.center,
                                ), //글자위치 변경
                                onPressed: () {
                                  Get.to(ConsultStepChangeDetail(),
                                      arguments: {'options': _selectedOption});
                                },

                                child: const Text('상담 옵션 순서 변경'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      flex: 1,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  int _selectedIndex = 0;

  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedOption = optionsList[_selectedIndex];
    });
  }

  Widget customRadio(String text, int index) {
    var widVal = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: OutlinedButton(
        onPressed: () {
          changeIndex(index);
        },
        child: Text(text,
            style: TextStyle(
                color: _selectedIndex == index
                    ? HexColor('#FFFFFF')
                    : Colors.black87)),
        style: OutlinedButton.styleFrom(
          backgroundColor: _selectedIndex == index
              ? HexColor('#172543')
              : Colors.transparent,
          //minimumSize: Size(Get.width * 0.45, 50), //최소 사이즈
          minimumSize: Size(360, 50), //최소 사이즈
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          side: BorderSide(
              width: _selectedIndex == index ? 3 : 1,
              color: _selectedIndex == index
                  ? HexColor('#172543')
                  : Colors.black87),
        ),
      ),
    );
  }
}
