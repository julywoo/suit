import 'dart:io';

import 'package:bykak/src/components/alert_fucntion.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/components/process_change_popup.dart';
import 'package:bykak/src/components/responsive.dart';
import 'package:bykak/src/model/suit_option.dart';
import 'package:bykak/src/pages/result_page.dart';
import 'package:bykak/src/pages/result_page_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var data;
  final List processList = [];
  bool reCapture = true;
  bool _isLoading = true;
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    //_recieveDataaaa();
  }

  //조회된 주문번호로 데이터 가져오기
  void _recieveDataaaa() async {
    final firestore = FirebaseFirestore.instance;
    var doc;

    //processList = [];
    var resultData = await firestore
        .collection('orders')
        .where('orderNo', isEqualTo: '220905154530_5330')
        .get();

    for (doc in resultData.docs) {
      setState(() {
        processList.add(doc);
      });
    }
    diffDateCheck(processList[0]['finishDate']);
  }

  User? auth = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  String userName = "";
  String currentUserFactoryName = "";
  String currentUserStoreName = "";
  String userType = "";
  getCurrentUser() async {
    try {
      var userResult =
          await firestore.collection('users').doc(auth!.email.toString()).get();

      setState(() {
        if (userResult['userType'] == "2") {
          userName = userResult['userName'];
          currentUserFactoryName = userResult['storeName'];
          userType = userResult['userType'];
        } else if (userResult['userType'] == "1") {
          currentUserStoreName = userResult['storeName'];
          userType = userResult['userType'];
        }
      });
    } catch (e) {}
  }

  int finishDateDiff = 30;
  int _selectedIndex = -1;

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
        title: result != null
            ? Text('제작 현황 조회',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700))
            : Text(
                'QR 코드로 제품 조회',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          result != null
              ? _isLoading
                  ? Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: HexColor('#172543'),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 30, top: 20, bottom: 20),
                                  child: Text(
                                    '주문 정보',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 30, top: 10, right: 30),
                                  width: 480,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        dataContext: productType[int.parse(
                                            processList[0]['orderType'])],
                                      ),

                                      scannerDataList(
                                        dataTitle: '시작일자',
                                        dataContext: processList[0]
                                                ['consultDate']
                                            .toString()
                                            .substring(0, 10),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          scannerDataList(
                                            dataTitle: '종료일자',
                                            dataContext: processList[0]
                                                    ['finishDate']
                                                .toString()
                                                .substring(0, 10),
                                            dataColor: finishDateDiff < 7
                                                ? '#E53935'
                                                : '#000000',
                                          ),
                                          finishDateDiff < 7
                                              ? Container(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    '마감임박',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: HexColor(
                                                            '#E53935')),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                  builder: (context) =>
                                                      ProcessChangePopup(
                                                    title: '제작 상태 변경',
                                                    message:
                                                        '현재 제작 상태를 선택해주세요.',
                                                    okCallback: (int val) {
                                                      setState(() {
                                                        _selectedIndex =
                                                            val + 1;
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                primary: Colors.white, //글자색
                                                onSurface: Colors.white,

                                                backgroundColor: HexColor(
                                                    '#172543'), //onpressed가 null일때 색상
                                                elevation: 1, // 버튼 입체감
                                                textStyle:
                                                    TextStyle(fontSize: 10),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 10),
                                        child: Container(
                                          height: 0.5,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            3, 10, 30, 10),
                                        child: InkWell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '작업지시서 보기',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14),
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
                                            Responsive.isMobile(context)
                                                ? Get.to(ResultPage(),
                                                    arguments: {
                                                        'data': processList[0],
                                                        'orderNo':
                                                            processList[0]
                                                                ['orderNo'],
                                                      })
                                                : Get.to(ResultPageWeb(),
                                                    arguments: {
                                                        'data': processList[0],
                                                        'orderNo':
                                                            processList[0]
                                                                ['orderNo'],
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
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 20),
                                        child: Text(
                                          '제작 공장 정보',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),
                                      ),

                                      scannerDataList(
                                          dataTitle: '공장명',
                                          dataContext:
                                              processList[0]['factory'] ?? ''),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          scannerDataList(
                                              dataTitle: '담당자명',
                                              dataContext: processList[0]
                                                      ['makerName'] ??
                                                  userName),
                                          Container(
                                            // padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              '* 담당자가 지정되지 않았을 경우 현재 조회하신 담당자로 입력됩니다.',
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 11),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Text(
                                      //     'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}'),
                                      // ElevatedButton(
                                      //   onPressed: () {
                                      //     widthVal > 480
                                      //         ? Get.to(ResultPageWeb(), arguments: {
                                      //             'data': processList[0],
                                      //             'orderNo': processList[0]['orderNo'],
                                      //           })
                                      //         : Get.to(ResultPage(), arguments: {
                                      //             'data': processList[0],
                                      //             'orderNo': processList[0]['orderNo'],
                                      //           });
                                      //   },
                                      //   child: Text('작업지시서 조회'),
                                      // )
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
                                  onSurface:
                                      Colors.white, //onpressed가 null일때 색상
                                  backgroundColor: HexColor('#172543'),
                                  shadowColor: Colors.white, //그림자 색상
                                  elevation: 1, // 버튼 입체감
                                  // textStyle: TextStyle(fontSize: 16),
                                  //padding: EdgeInsets.all(16.0),
                                  minimumSize: Size(300, 40), //최소 사이즈
                                  side: BorderSide(
                                      color: HexColor('#172543'),
                                      width: 1.0), //선
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
                                        //제품 제작 할당된 공장과 QR스캔을 실시하는 사용자의 공장이 일치하는지 확인

                                        _selectedIndex == -1
                                            ? updateProcess(
                                                processList[0]
                                                    ['productionProcess'],
                                                processList[0]['orderNo'],
                                                processList[0]['makerName'] ??
                                                    userName)
                                            : updateProcess(
                                                _selectedIndex,
                                                processList[0]['orderNo'],
                                                processList[0]['makerName'] ??
                                                    userName);

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
                    )
              : Expanded(flex: 4, child: _buildQrView(context)),
          // Expanded(
          //   flex: 1,
          //   child: FittedBox(
          //     fit: BoxFit.contain,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         result != null
          //             ? Container(
          //                 child: Column(
          //                   children: [
          //                     Text(
          //                         'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}'),
          //                     ElevatedButton(
          //                       onPressed: () {
          //                         Get.to(
          //                           ResultPageWeb(),
          //                           arguments: {
          //                             'data': data,
          //                             'orderNo': result!.code,
          //                           },
          //                         );
          //                       },
          //                       child: Text('작업지시서 조회'),
          //                     )
          //                   ],
          //                 ),
          //               )
          //             : Container(
          //                 child: Column(children: [
          //                   const Text('Scan a code'),
          //                   Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: <Widget>[
          //                       Container(
          //                         margin: const EdgeInsets.all(8),
          //                         child: ElevatedButton(
          //                             onPressed: () async {
          //                               await controller?.toggleFlash();
          //                               setState(() {});
          //                             },
          //                             child: FutureBuilder(
          //                               future: controller?.getFlashStatus(),
          //                               builder: (context, snapshot) {
          //                                 return Text(
          //                                     'Flash: ${snapshot.data}');
          //                               },
          //                             )),
          //                       ),
          //                       Container(
          //                         margin: const EdgeInsets.all(8),
          //                         child: ElevatedButton(
          //                             onPressed: () async {
          //                               await controller?.flipCamera();
          //                               setState(() {});
          //                             },
          //                             child: FutureBuilder(
          //                               future: controller?.getCameraInfo(),
          //                               builder: (context, snapshot) {
          //                                 if (snapshot.data != null) {
          //                                   return Text(
          //                                       'Camera facing ${describeEnum(snapshot.data!)}');
          //                                 } else {
          //                                   return const Text('loading');
          //                                 }
          //                               },
          //                             )),
          //                       )
          //                     ],
          //                   ),
          //                   Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: <Widget>[
          //                       Container(
          //                         margin: const EdgeInsets.all(8),
          //                         child: ElevatedButton(
          //                           onPressed: () async {
          //                             await controller?.pauseCamera();
          //                           },
          //                           child: const Text('pause',
          //                               style: TextStyle(fontSize: 20)),
          //                         ),
          //                       ),
          //                       Container(
          //                         margin: const EdgeInsets.all(8),
          //                         child: ElevatedButton(
          //                           onPressed: () async {
          //                             await controller?.resumeCamera();
          //                           },
          //                           child: const Text('resume',
          //                               style: TextStyle(fontSize: 20)),
          //                         ),
          //                       )
          //                     ],
          //                   ),
          //                 ]),
          //               )
          //         // if (result != null)
          //         //   Text(
          //         //       'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //         // else
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 150.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller

    return
        //reCapture == true  ?
        QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
    // : Container(
    //     child: ElevatedButton(
    //       child: Text('QR 다시 찍기'),
    //       onPressed: () {
    //         setState(() {
    //           reCapture == true;
    //         });
    //       },
    //     ),
    //   );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.pauseCamera();
      resuecamara();
    });

    controller.scannedDataStream.listen((scanData) {
      _recieveData(scanData);
    });
  }

  void resuecamara() {
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  //조회된 주문번호로 데이터 가져오기
  void _recieveData(Barcode scanData) async {
    final firestore = FirebaseFirestore.instance;
    var doc;

    //processList = [];
    var resultData = await firestore
        .collection('orders')
        .where('orderNo', isEqualTo: scanData.code)
        .get();

    for (doc in resultData.docs) {
      setState(() {
        processList.add(doc);
      });
    }
    try {
      if (userType == '1') {
        if (processList[0]['storeName'] == currentUserStoreName) {
          setState(() async {
            result = scanData;
            //  await controller!.pauseCamera();
          });
          diffDateCheck(processList[0]['finishDate']);
        } else {
          setState(() async {
            result = null as Barcode;
            //reCapture == false;
            await controller!.pauseCamera();
          });
          resuecamara();
          failAlert("해당 작업지시서의 조회 권한이 없습니다.");
        }
      } else {
        if (processList[0]['factory'] != currentUserFactoryName ||
            processList[0]['gabongFactory'] != currentUserFactoryName) {
          setState(() async {
            result = null as Barcode;
            //reCapture == false;
            await controller!.pauseCamera();
          });
          resuecamara();
          failAlert("해당 공장으로 할당된 제품이 아닙니다.");
        } else {
          setState(() async {
            result = scanData;
            //  await controller!.pauseCamera();
          });
          diffDateCheck(processList[0]['finishDate']);
        }
      }
      // if (processList[0]['storeName'] == currentUserStoreName) {
      // } else {
      //   setState(() async {
      //     result = null as Barcode;
      //     //reCapture == false;
      //     await controller!.pauseCamera();
      //   });
      //   resuecamara();
      //   scanFailAlert();
      // }
    } catch (e) {}

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void diffDateCheck(String finishDate) {
    var _toDay = DateTime.now();
    finishDateDiff = finishDateDiff = int.parse(
        DateTime.parse(finishDate).difference(_toDay).inDays.toString());
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
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
        msg: "변경이 완료되었습니다.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffF44336),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void scanFailAlert() {
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
