import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/components/process_change_popup.dart';
import 'package:bykak/src/model/suit_option.dart';
import 'package:bykak/src/pages/qr_scan_page.dart';
import 'package:bykak/src/pages/result_page.dart';
import 'package:bykak/src/pages/result_page_web.dart';
import 'package:bykak/src/widget/custom_elevated_buttod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class QrResult extends StatefulWidget {
  QrResult({Key? key}) : super(key: key);

  @override
  State<QrResult> createState() => _QrResultState();
}

class _QrResultState extends State<QrResult> {
  List processList = Get.arguments['processList'];
  int finishDateDiff = 30;
  int _selectedIndex = -1;
  bool result = false;

  User? auth = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  String userName = "";
  String currentUserFactoryName = "";
  String currentUserStoreName = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();

    diffDateCheck(processList[0]['finishDate']);
    //_recieveDataaaa();
  }

  @override
  void dispose() {
    // 세로 화면 고정

    super.dispose();
  }

  getCurrentUser() async {
    try {
      var userResult =
          await firestore.collection('users').doc(auth!.email.toString()).get();

      setState(() {
        if (userResult['userType'] == "2") {
          userName = userResult['userName'];
          currentUserFactoryName = userResult['storeName'];
        } else if (userResult['userType'] == "1") {
          currentUserStoreName = userResult['storeName'];
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var widthVal = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black),
          ),
          elevation: 2,
          title: Text('제작 현황 조회',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700))),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 30, top: 20, bottom: 20),
                    child: Text(
                      '주문 정보',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, top: 10, right: 30),
                    width: 480,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        scannerDataList(
                          dataTitle: '주문번호',
                          dataContext: processList[0]['orderNo'],
                        ),
                        scannerDataList(
                          dataTitle: '고객명',
                          dataContext: processList[0]['name'],
                        ),
                        scannerDataList(
                          dataTitle: '제품타입',
                          dataContext: productType[
                              int.parse(processList[0]['orderType'])],
                        ),
                        scannerDataList(
                          dataTitle: '시작일자',
                          dataContext: processList[0]['consultDate']
                              .toString()
                              .substring(0, 10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            scannerDataList(
                              dataTitle: '종료일자',
                              dataContext: processList[0]['finishDate']
                                  .toString()
                                  .substring(0, 10),
                              dataColor:
                                  finishDateDiff < 7 ? '#E53935' : '#000000',
                            ),
                            finishDateDiff < 7
                                ? Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      '마감임박',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: HexColor('#E53935')),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            scannerDataList(
                              dataTitle: '제작상태',
                              dataContext: _selectedIndex == -1
                                  ? processOption[processList[0]
                                      ['productionProcess']]
                                  : processOption[_selectedIndex],
                              dataColor: _selectedIndex == -1
                                  ? processColor[processList[0]
                                      ['productionProcess']]
                                  : processColor[_selectedIndex],
                            ),
                            Container(
                              width: 80,
                              height: 25,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: Get.context!,
                                    builder: (context) => ProcessChangePopup(
                                      title: '제작 상태 변경',
                                      message: '현재 제작 상태를 선택해주세요.',
                                      okCallback: (int val) {
                                        setState(() {
                                          _selectedIndex = val + 1;
                                        });

                                        //_submitData();
                                        //Get.to(const FactoryCost());
                                      },
                                      cancleCallback: Get.back,
                                    ),
                                  );
                                },
                                child: Text('상태변경'),
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: Colors.white, //글자색
                                  onSurface: Colors.white,

                                  backgroundColor: HexColor(
                                      '#172543'), //onpressed가 null일때 색상
                                  elevation: 1, // 버튼 입체감
                                  textStyle: TextStyle(fontSize: 10),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Container(
                            height: 0.5,
                            color: Colors.black54,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(3, 10, 30, 10),
                          child: GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '작업지시서 보기',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 13,
                                ),
                              ],
                            ),
                            onTap: () {
                              widthVal > 480
                                  ? Get.to(ResultPageWeb(), arguments: {
                                      'data': processList[0],
                                      'orderNo': processList[0]['orderNo'],
                                    })
                                  : Get.to(ResultPage(), arguments: {
                                      'data': processList[0],
                                      'orderNo': processList[0]['orderNo'],
                                    });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: 0.5,
                            color: Colors.black54,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Text(
                            '제작 공장 정보',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                        ),
                        scannerDataList(
                            dataTitle: '공장명',
                            dataContext: processList[0]['factory']),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            scannerDataList(
                                dataTitle: '담당자명',
                                dataContext:
                                    processList[0]['makerName'] ?? userName),
                            Container(
                              // padding: EdgeInsets.only(top: 10),
                              child: Text(
                                '* 담당자가 지정되지 않았을 경우 현재 조회하신 담당자로 입력됩니다.',
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                //로그아웃 버튼
                padding: EdgeInsets.only(top: 50),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white, //글자색
                    onSurface: Colors.white, //onpressed가 null일때 색상
                    backgroundColor: HexColor('#172543'),
                    shadowColor: Colors.white, //그림자 색상
                    elevation: 1, // 버튼 입체감

                    minimumSize: Size(300, 40), //최소 사이즈
                    side:
                        BorderSide(color: HexColor('#172543'), width: 1.0), //선
                    shape:
                        StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                    alignment: Alignment.center,
                  ), //글자위치 변경
                  onPressed: () {
                    showDialog(
                      context: Get.context!,
                      builder: (context) => MessagePopup(
                        title: '제작 상태 변경',
                        message: '제작 상태를 변경 하시겠습니까?',
                        okCallback: () {
                          _selectedIndex == -1
                              ? updateProcess(
                                  processList[0]['productionProcess'],
                                  processList[0]['orderNo'],
                                  processList[0]['makerName'] ?? userName)
                              : updateProcess(
                                  _selectedIndex,
                                  processList[0]['orderNo'],
                                  processList[0]['makerName'] ?? userName);

                          Get.back();
                        },
                        cancleCallback: Get.back,
                      ),
                    );
                  },
                  child: const Text('저장'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void diffDateCheck(String finishDate) {
    var _toDay = DateTime.now();
    finishDateDiff = finishDateDiff = int.parse(
        DateTime.parse(finishDate).difference(_toDay).inDays.toString());
  }

  void updateProcess(int step, String orderNo, String makerName) {
    try {
      FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
        //'suitDesign': _suitDesign!.toJson(),
        'productionProcess': step,
        'makerName': makerName
      }, SetOptions(merge: true));
      updateCompleteAlert();
    } catch (e) {
      print(e);
    }
  }

  void updateCompleteAlert() {
    Fluttertoast.showToast(
        webBgColor: "linear-gradient(to right, #F44336, #F44336)",
        webPosition: "center",
        msg: "해당 공장으로 할당된 제품이 아닙니다.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffF44336),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class scannerDataList extends StatelessWidget {
  final String dataTitle;
  final String dataContext;
  final String? dataColor;

  const scannerDataList(
      {required this.dataTitle, required this.dataContext, this.dataColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(
              dataTitle,
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            dataContext,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: dataColor == null
                    ? Colors.black
                    : HexColor(dataColor.toString())),
          )
        ],
      ),
    );
  }
}
