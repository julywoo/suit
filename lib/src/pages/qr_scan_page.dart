import 'package:bykak/src/app.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/qr_overlay.dart';
import 'package:bykak/src/pages/qr_result_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScan extends StatefulWidget {
  QrScan({Key? key}) : super(key: key);

  @override
  State<QrScan> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  late List processList;

  int finishDateDiff = 30;
  int _selectedIndex = -1;
  bool result = false;

  MobileScannerController cameraController = MobileScannerController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  User? auth = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  String userName = "";
  String currentUserFactoryName = "";
  String currentUserStoreName = "";
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black),
        ),
        elevation: 2,
        title: Text(
          'QR 코드로 제품 조회',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: (barcode, args) {
              if (barcode.rawValue == null) {
                debugPrint('Failed to scan Barcode');
              } else {
                final String code = barcode.rawValue!;
                debugPrint('Barcode found! $code');

                _recieveData(code);
              }
            },
          ),
          // QrOverlay(
          //   overlayColor: Colors.black.withOpacity(0.5),
          // ),
        ],
      ),
    );
  }

  void _recieveData(String scanData) async {
    final firestore = FirebaseFirestore.instance;
    var doc;

    processList = [];
    var resultData = await firestore
        .collection('orders')
        .where('orderNo', isEqualTo: scanData)
        .get();

    for (doc in resultData.docs) {
      setState(() {
        processList.add(doc);
      });
    }

    setState(() {
      result = true;
    });
    if (processList[0]['factory'] == currentUserFactoryName ||
        processList[0]['storeName'] == currentUserStoreName) {
      // setState(() async {
      //   result = scanData;
      //   await controller!.pauseCamera();
      // });
      diffDateCheck(processList[0]['finishDate']);
    } else {
      // setState(() async {
      //   result = null as Barcode;
      //   //reCapture == false;
      //   await controller!.pauseCamera();
      // });

      // scanFailAlert();
    }
    Get.to(QrResult(), arguments: {'processList': processList});
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
        msg: "변경이 완료되었습니다.",
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
