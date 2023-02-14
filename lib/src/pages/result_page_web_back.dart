import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bykak/src/app.dart';
import 'package:bykak/src/components/alert_fucntion.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/suit_design_model.dart';
import 'package:bykak/src/model/suit_design_val.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/pages/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultPageWeb extends StatefulWidget {
  ResultPageWeb({Key? key}) : super(key: key);

  @override
  State<ResultPageWeb> createState() => _ResultPageWebState();
}

class _ResultPageWebState extends State<ResultPageWeb> {
  final data = Get.arguments['data'];

  List<String> topSizeList = [
    '어깨',
    '앞어깨',
    '등어깨',
    '진동',
    '소매',
    '상동',
    '중동',
    '하동',
    '상의장',
    '앞폼',
    '뒷폼',
    '총장',
    '암홀',
    '각도',
    '앞길',
  ];
  List<String> bottomSizeList = [
    '허리',
    '힙',
    '밑위\n길이',
    '바깥\n기장',
    '허벅',
    '둘레',
    '밑통',
    '조끼장',
  ];
  List<String> vestSizeList = [
    '각도',
    '상동',
    '중동',
    '앞길',
  ];
  List<String> topSizeDataList = [
    'shoulder',
    'shoulderFront',
    'shoulderBack',
    'jindong',
    'sleeve',
    'sangdong',
    'jungdong',
    'hadong',
    'topHeight',
    'frontForm',
    'backForm',
    'totalHeight',
    'armhole',
    'angle',
    'apgil',
  ];
  List<String> bottomSizeDataList = [
    'waist',
    'hips',
    'crotch',
    'outHeight',
    'thigh',
    'circumference',
    'pantsBottom',
    'vestHeight',
  ];
  List<String> vestSizeDataList = [
    'angle',
    'sangdong',
    'jungdong',
    'apgil',
  ];
  List<String> suitDesign = [
    'jacketButton',
    'jacketLapel',
    'jacketChestPocket',
    'jacketShoulder',
    'jacketSidePocket',
    'jacketVent',
  ];

  List<String> vestDesign = [
    'vestButton',
    'vestLapel',
  ];

  List<String> pantsDesign = [
    'pantsPleats',
    'pantsBreak',
    'pantsDetailOne',
    'pantsDetailTwo',
    'pantsDetailThree',
    'pantsPermanentPleats',
  ];

  @override
  void initState() {
    getData();
    super.initState();
  }

  final firestore = FirebaseFirestore.instance;
  User? auth = FirebaseAuth.instance.currentUser;
  String userType = "";
  getData() async {
    try {
      var userData =
          await firestore.collection('users').doc(auth!.email.toString()).get();

      setState(() {
        userType = userData['userType'];
      });
    } catch (e) {}
  }

  var updateTopSize = List<String>.filled(15, "");
  var updateBottomSize = List<String>.filled(8, "");
  var updateSuitDesign1 = List<String>.filled(6, "");
  var updateSuitDesign2 = List<String>.filled(2, "");
  var updateSuitDesign3 = List<String>.filled(6, "");

  var updateSuitVal1 = List<String>.filled(6, "");
  var updateSuitVal2 = List<String>.filled(2, "");
  var updateSuitVal3 = List<String>.filled(6, "");

  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _phone;
  String? _pabric;
  String? _pabricSub1;
  String? _pabricSub2;
  String? _buttons;
  String? _lining;
  String? _age;
  String? _height;
  String? _weight;
  String? _bodyType;
  String? _finishDate;
  String? _gabong;
  String? _midgabong;
  String? _consult;
  String? _consult1;
  String? _initial;
  String? _price;
  String? _factory;
  String? _gabongFactory;

  TopSize? _inputTopSize;
  BottomSize? _inputBottomSize;
  SuitDesign? _suitDesign;
  SuitDesignVal? _suitDesignVal;

  void _submitData() async {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_isValid) {
      _formKey.currentState!.save();
    }

    _inputTopSize = TopSize(
      shoulder: updateTopSize[0],
      shoulderFront: updateTopSize[1],
      shoulderBack: updateTopSize[2],
      jindong: updateTopSize[3],
      sleeve: updateTopSize[4],
      sangdong: updateTopSize[5],
      jungdong: updateTopSize[6],
      hadong: updateTopSize[7],
      topHeight: updateTopSize[8],
      frontForm: updateTopSize[9],
      backForm: updateTopSize[10],
      totalHeight: updateTopSize[11],
      armhole: updateTopSize[12],
      angle: updateTopSize[13],
      apgil: updateTopSize[14],
    );

    _inputBottomSize = BottomSize(
      waist: updateBottomSize[0],
      hips: updateBottomSize[1],
      crotch: updateBottomSize[2],
      outHeight: updateBottomSize[3],
      thigh: updateBottomSize[4],
      circumference: updateBottomSize[5],
      pantsBottom: updateBottomSize[6],
      // vestHeight: updateBottomSize[7],
    );

    _suitDesignVal = SuitDesignVal(
      jacketButton: updateSuitVal1[0],
      jacketLapel: updateSuitVal1[1],
      jacketChestPocket: updateSuitVal1[2],
      jacketShoulder: updateSuitVal1[3],
      jacketSidePocket: updateSuitVal1[4],
      jacketVent: updateSuitVal1[5],
      vestButton: updateSuitVal2[0],
      vestLapel: updateSuitVal2[1],
      pantsPleats: updateSuitVal3[0],
      pantsBreak: updateSuitVal3[1],
      pantsDetailOne: updateSuitVal3[2],
      pantsDetailTwo: updateSuitVal3[3],
      pantsDetailThree: updateSuitVal3[4],
      pantsPermanentPleats: updateSuitVal3[5],
    );
    _suitDesign = SuitDesign(
      jacketButton: updateSuitDesign1[0],
      jacketLapel: updateSuitDesign1[1],
      jacketChestPocket: updateSuitDesign1[2],
      jacketShoulder: updateSuitDesign1[3],
      jacketSidePocket: updateSuitDesign1[4],
      jacketVent: updateSuitDesign1[5],
      vestButton: updateSuitDesign2[0],
      vestLapel: updateSuitDesign2[1],
      pantsPleats: updateSuitDesign3[0],
      pantsBreak: updateSuitDesign3[1],
      pantsDetailOne: updateSuitDesign3[2],
      pantsDetailTwo: updateSuitDesign3[3],
      pantsDetailThree: updateSuitDesign3[4],
      pantsPermanentPleats: updateSuitDesign3[5],
    );
    FirebaseFirestore.instance.collection('orders').doc(data['orderNo']).set({
      'name': _name,
      'phone': _phone,
      'pabric': _pabric,
      'pabricSub1': _pabricSub1,
      'pabricSub2': _pabricSub2,
      'lining': _lining,
      'buttons': _buttons,
      'age': _age,
      'height': _height,
      'weight': _weight,
      'bodyType': _bodyType,
      'finishDate': _finishDate,
      'gabong': _gabong,
      'gabongFactory': _gabongFactory,
      'midgabong': _midgabong,
      'consult': _consult,
      'consult1': _consult1,
      'initial': _initial,
      'price': _price,
      'factory': _factory,
      'topSize': _inputTopSize!.toJson(),
      'bottomSize': _inputBottomSize!.toJson(),
      'suitDesignVal': _suitDesignVal!.toJson(),
      'suitDesign': _suitDesign!.toJson(),
    }, SetOptions(merge: true));
  }

  var widVal;
  var heiVal;

  @override
  Widget build(BuildContext context) {
    //final name = TextEditingController(text: data['name']);

    return bbbb(context);
  }

  Scaffold bbbb(BuildContext context) {
    widVal = MediaQuery.of(context).size.width;
    heiVal = MediaQuery.of(context).size.height;
    try {
      _price = data['price'];
    } catch (e) {
      _price = '0';
    }
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
        title: Text(
          '작업지시서 상세',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: widVal < 481 ? widVal : 800,
                child: Center(
                  child: Container(
                    color: Colors.white,
                    // width: 1500,
                    //height: 3508.px,
                    child: Column(
                      children: [
                        Column(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(data['storeName']),
                                      Text(
                                        '  No. ' + data['orderNo'],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Date : '),
                                      Text(data['consultDate'])
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                              child: Column(
                                children: [
                                  Table(
                                    columnWidths: {
                                      0: FixedColumnWidth(widVal < 481
                                          ? MediaQuery.of(context).size.width *
                                              0.20
                                          : 800 * 0.20),
                                      2: FixedColumnWidth(widVal < 481
                                          ? MediaQuery.of(context).size.width *
                                              0.20
                                          : 800 * 0.20),
                                    },
                                    border: TableBorder.all(),
                                    children: [
                                      TableRow(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: Text('성명'),
                                          ),
                                          Container(
                                            height: 28,
                                            child: TextFormField(
                                              readOnly: userType == "1"
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 12), //
                                                border: InputBorder.none,
                                              ),
                                              initialValue: data['name'],
                                              textAlign: TextAlign.center,
                                              onSaved: (value) {
                                                _name = value!;
                                              },
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            // child: Text(data['name']),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: Text('나이'),
                                          ),
                                          Container(
                                            alignment: Alignment.topCenter,
                                            height: 28,
                                            child: TextFormField(
                                              readOnly: userType == "1"
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 12), //
                                                border: InputBorder.none,
                                              ),
                                              initialValue: data['age'],
                                              textAlign: TextAlign.center,
                                              onSaved: (value) {
                                                _age = value!;
                                              },
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            // child: Text(data['name']),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: Text('연락처'),
                                          ),
                                          Container(
                                            height: 28,
                                            child: TextFormField(
                                              readOnly: userType == "1"
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 12), //
                                                border: InputBorder.none,
                                              ),
                                              initialValue: data['phone'],
                                              textAlign: TextAlign.center,
                                              onSaved: (value) {
                                                _phone = value!;
                                              },
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            // child: Text(data['name']),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: Text('브랜드'),
                                          ),
                                          Container(
                                            alignment: Alignment.topCenter,
                                            height: 28,
                                            child: TextFormField(
                                              readOnly: userType == "1"
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 12), //
                                                border: InputBorder.none,
                                              ),
                                              initialValue: data['brandRate'],
                                              textAlign: TextAlign.center,
                                              onSaved: (value) {
                                                //_age = value!;
                                              },
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            // child: Text(data['name']),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: Text('키'),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: TextFormField(
                                              readOnly: userType == "1"
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 12), //
                                                border: InputBorder.none,
                                              ),
                                              initialValue: data['height'],
                                              textAlign: TextAlign.center,
                                              onSaved: (value) {
                                                _height = value!;
                                              },
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            // child: Text(data['name']),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: Text('몸무게'),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: TextFormField(
                                              readOnly: userType == "1"
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 12), //
                                                border: InputBorder.none,
                                              ),
                                              initialValue: data['weight'],
                                              textAlign: TextAlign.center,
                                              onSaved: (value) {
                                                _weight = value!;
                                              },
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            // child: Text(data['name']),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: Text('가봉공장'),
                                          ),
                                          Container(
                                            height: 28,
                                            child: TextFormField(
                                              readOnly: userType == "1"
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 12), //
                                                border: InputBorder.none,
                                              ),
                                              initialValue:
                                                  data['gabongFactory'],
                                              textAlign: TextAlign.center,
                                              onSaved: (value) {
                                                _gabongFactory = value!;
                                              },
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: Text('가봉일자'),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: TextFormField(
                                              readOnly: userType == "1"
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 12), //
                                                border: InputBorder.none,
                                              ),
                                              initialValue: data['gabong'],
                                              textAlign: TextAlign.center,
                                              onSaved: (value) {
                                                _gabong = value!;
                                              },
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            // child: Text(data['name']),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: Text('결제금액'),
                                          ),
                                          Container(
                                            height: 28,
                                            child: TextFormField(
                                              readOnly: userType == "1"
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 12), //
                                                border: InputBorder.none,
                                              ),
                                              initialValue: _price,
                                              textAlign: TextAlign.center,
                                              onSaved: (value) {
                                                _price = value!;
                                              },
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: Text('제작공장'),
                                          ),
                                          Container(
                                            height: 28,
                                            child: TextFormField(
                                              readOnly: userType == "1"
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 12), //
                                                border: InputBorder.none,
                                              ),
                                              initialValue: data['factory'],
                                              textAlign: TextAlign.center,
                                              onSaved: (value) {
                                                _factory = value!;
                                              },
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: Text('중가봉일자'),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: TextFormField(
                                              readOnly: userType == "1"
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 12), //
                                                border: InputBorder.none,
                                              ),
                                              initialValue: data['midgabong'],
                                              textAlign: TextAlign.center,
                                              onSaved: (value) {
                                                _midgabong = value!;
                                              },
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            // child: Text(data['name']),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: Text('완성일자'),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 28,
                                            child: TextFormField(
                                              readOnly: userType == "1"
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 12), //
                                                border: InputBorder.none,
                                              ),
                                              initialValue: data['finishDate'],
                                              textAlign: TextAlign.center,
                                              onSaved: (value) {
                                                _finishDate = value!;
                                              },
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            // child: Text(data['name']),
                                          ),
                                        ],
                                      ),
                                      // TableRow(
                                      //   children: [
                                      //     Container(),
                                      //     Container(),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Table(
                                      columnWidths: {
                                        0: FixedColumnWidth(widVal < 481
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20
                                            : 800 * 0.20),
                                      },
                                      border: TableBorder.all(),
                                      children: [
                                        TableRow(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 28,
                                              child: Text('체형'),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: 28,
                                              child: TextFormField(
                                                readOnly: userType == "1"
                                                    ? false
                                                    : true,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          bottom: 12), //
                                                  border: InputBorder.none,
                                                ),
                                                initialValue: data['bodyType'],
                                                textAlign: TextAlign.center,
                                                onSaved: (value) {
                                                  _bodyType = value!;
                                                },
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              // child: Text(data['name']),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 28,
                                              child: Text('원단명'),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: 28,
                                              child: TextFormField(
                                                readOnly: userType == "1"
                                                    ? false
                                                    : true,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          bottom: 12), //
                                                  border: InputBorder.none,
                                                ),
                                                initialValue: data['pabric'],
                                                textAlign: TextAlign.center,
                                                onSaved: (value) {
                                                  _pabric = value!;
                                                },
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              // child: Text(data['name']),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 28,
                                              child: Text('원단명(조끼)'),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: 28,
                                              child: TextFormField(
                                                readOnly: userType == "1"
                                                    ? false
                                                    : true,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          bottom: 12), //
                                                  border: InputBorder.none,
                                                ),
                                                initialValue:
                                                    data['pabricSub1'],
                                                textAlign: TextAlign.center,
                                                onSaved: (value) {
                                                  _pabricSub1 = value!;
                                                },
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              // child: Text(data['name']),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 28,
                                              child: Text('원단명(바지)'),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: 28,
                                              child: TextFormField(
                                                readOnly: userType == "1"
                                                    ? false
                                                    : true,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          bottom: 12), //
                                                  border: InputBorder.none,
                                                ),
                                                initialValue:
                                                    data['pabricSub2'],
                                                textAlign: TextAlign.center,
                                                onSaved: (value) {
                                                  _pabricSub2 = value!;
                                                },
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              // child: Text(data['name']),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 28,
                                              child: Text('안감'),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: 28,
                                              child: TextFormField(
                                                readOnly: userType == "1"
                                                    ? false
                                                    : true,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          bottom: 12), //
                                                  border: InputBorder.none,
                                                ),
                                                initialValue: data['lining'],
                                                textAlign: TextAlign.center,
                                                onSaved: (value) {
                                                  _lining = value!;
                                                },
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              // child: Text(data['name']),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 28,
                                              child: Text('버튼 및 부자재'),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: 28,
                                              child: TextFormField(
                                                readOnly: userType == "1"
                                                    ? false
                                                    : true,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          bottom: 12), //
                                                  border: InputBorder.none,
                                                ),
                                                initialValue: data['buttons'],
                                                textAlign: TextAlign.center,
                                                onSaved: (value) {
                                                  _buttons = value!;
                                                },
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              // child: Text(data['name']),
                                            ),
                                          ],
                                        ),
                                      ])
                                ],
                              ),
                            ),
                          ),
                          //사이즈 보여주기
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 10, 20, 0),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Table(
                                              border: TableBorder.all(),
                                              columnWidths: {
                                                0: FixedColumnWidth(widVal < 481
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.30
                                                    : 800 * 0.20),
                                              },
                                              children: [
                                                for (var i = 0;
                                                    i < topSizeList.length;
                                                    i++)

                                                  //for (var i in sizeList)
                                                  TableRow(
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                              topSizeList[i],
                                                              style:
                                                                  TextStyle(),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 35,
                                                              width: 60,
                                                              child:
                                                                  TextFormField(
                                                                decoration:
                                                                    new InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  focusedBorder:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                initialValue: data[
                                                                        'topSize']
                                                                    [
                                                                    topSizeDataList[
                                                                        i]],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                onSaved:
                                                                    (value) {
                                                                  setState(() {
                                                                    try {
                                                                      updateTopSize[
                                                                              i] =
                                                                          value!;
                                                                    } catch (e) {}
                                                                  });
                                                                },
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 10, 20, 0),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Table(
                                              border: TableBorder.all(),
                                              columnWidths: {
                                                0: FixedColumnWidth(widVal < 481
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.30
                                                    : 800 * 0.20),
                                              },
                                              children: [
                                                for (var i = 0;
                                                    i < bottomSizeList.length;
                                                    i++)
                                                  //for (var i in sizeList)
                                                  TableRow(
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                              bottomSizeList[i],
                                                              style:
                                                                  TextStyle(),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 35,
                                                              width: 60,
                                                              child:
                                                                  TextFormField(
                                                                decoration:
                                                                    new InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  focusedBorder:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                initialValue: data[
                                                                        'bottomSize']
                                                                    [
                                                                    bottomSizeDataList[
                                                                        i]],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                onSaved:
                                                                    (value) {
                                                                  setState(() {
                                                                    try {
                                                                      updateBottomSize[
                                                                              i] =
                                                                          value!;
                                                                    } catch (e) {}
                                                                  });
                                                                },
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(top: 30),
                                          height: 800,
                                          child: Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.topCenter,
                                                child: Column(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Image.asset(
                                                          'assets/sizeImg1.png',
                                                          width: 280,
                                                        ),
                                                        SizedBox(height: 10),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  top: 20,
                                                                  right: 20),
                                                          width: 280,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '자켓디자인',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              for (int i = 0;
                                                                  i <
                                                                      suitDesign
                                                                          .length;
                                                                  i++)
                                                                Container(
                                                                  height: 50,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      TextFormField(
                                                                    maxLines: 2,
                                                                    decoration: new InputDecoration(
                                                                        // border:
                                                                        //     InputBorder.none,
                                                                        // focusedBorder:
                                                                        //     InputBorder.none,
                                                                        ),
                                                                    initialValue: data[
                                                                            'suitDesignVal']
                                                                        [
                                                                        suitDesign[
                                                                            i]],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    onSaved:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        try {
                                                                          updateSuitVal1[i] =
                                                                              value!;
                                                                        } catch (e) {}
                                                                      });
                                                                    },
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  top: 30,
                                                                  right: 20),
                                                          width: 280,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '이니셜 ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child:
                                                                    TextFormField(
                                                                  maxLines: 2,
                                                                  decoration: new InputDecoration(

                                                                      // border:
                                                                      //     InputBorder
                                                                      //         .none,
                                                                      // focusedBorder:
                                                                      //     InputBorder
                                                                      //         .none,
                                                                      ),
                                                                  initialValue:
                                                                      data[
                                                                          'initial'],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  onSaved:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      try {
                                                                        _initial =
                                                                            value!;
                                                                      } catch (e) {}
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: 1,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.8,
                                                color: Colors.black45,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    'assets/sizeImg2.png',
                                                    width: 280,
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                        top: 20),
                                                    width: 280,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '바지디자인',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        for (int i = 0;
                                                            i <
                                                                pantsDesign
                                                                    .length;
                                                            i++)
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 50,
                                                            child:
                                                                TextFormField(
                                                              maxLines: 2,
                                                              decoration: new InputDecoration(

                                                                  // border:
                                                                  //     InputBorder
                                                                  //         .none,
                                                                  // focusedBorder:
                                                                  //     InputBorder
                                                                  //         .none,
                                                                  ),
                                                              initialValue: data[
                                                                      'suitDesignVal']
                                                                  [pantsDesign[
                                                                      i]],
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              onSaved: (value) {
                                                                setState(() {
                                                                  try {
                                                                    updateSuitVal3[
                                                                            i] =
                                                                        value!;
                                                                  } catch (e) {}
                                                                });
                                                              },
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.all(
                                                  //           20.0),
                                                  //   child: Container(
                                                  //     color: Colors.black45,
                                                  //     height: 1.0,
                                                  //     width: 280,
                                                  //   ),
                                                  // ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                        top: 20),
                                                    width: 280,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '조끼디자인',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        for (int i = 0;
                                                            i <
                                                                vestDesign
                                                                    .length;
                                                            i++)
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            // height: 28,
                                                            child:
                                                                TextFormField(
                                                              maxLines: 2,
                                                              decoration: new InputDecoration(
                                                                  // border:
                                                                  //     InputBorder.none,
                                                                  // focusedBorder:
                                                                  //     InputBorder.none,
                                                                  )
                                                              // border:
                                                              //     InputBorder
                                                              //         .none,
                                                              // focusedBorder:
                                                              //     InputBorder
                                                              //         .none,
                                                              ,
                                                              initialValue: data[
                                                                      'suitDesignVal']
                                                                  [vestDesign[
                                                                      i]],
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              onSaved: (value) {
                                                                setState(() {
                                                                  try {
                                                                    updateSuitVal2[
                                                                            i] =
                                                                        value!;
                                                                  } catch (e) {}
                                                                });
                                                              },
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Column(
                                                  //   crossAxisAlignment:
                                                  //       CrossAxisAlignment
                                                  //           .start,
                                                  //   children: [
                                                  //     Container(
                                                  //       padding:
                                                  //           EdgeInsets.only(
                                                  //               left: 20,
                                                  //               right: 20,
                                                  //               top: 20),
                                                  //       width: 280,
                                                  //     ),
                                                  //     SizedBox(height: 10),
                                                  //     Container(
                                                  //         width: 280,
                                                  //         child: Column(
                                                  //           crossAxisAlignment:
                                                  //               CrossAxisAlignment
                                                  //                   .start,
                                                  //           children: [
                                                  //             Text(
                                                  //               '조끼디자인',
                                                  //               style: TextStyle(
                                                  //                   fontSize:
                                                  //                       16,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .bold),
                                                  //             ),
                                                  //             for (int i = 0;
                                                  //                 i <
                                                  //                     vestDesign
                                                  //                         .length;
                                                  //                 i++)
                                                  //               Padding(
                                                  //                 padding:
                                                  //                     const EdgeInsets
                                                  //                             .fromLTRB(
                                                  //                         20,
                                                  //                         2,
                                                  //                         0,
                                                  //                         0),
                                                  //                 child:
                                                  //                     Container(
                                                  //                   alignment:
                                                  //                       Alignment
                                                  //                           .center,
                                                  //                   // height: 28,
                                                  //                   child:
                                                  //                       TextFormField(
                                                  //                     decoration: new InputDecoration(
                                                  //                         // border:
                                                  //                         //     InputBorder.none,
                                                  //                         // focusedBorder:
                                                  //                         //     InputBorder.none,
                                                  //                         ),
                                                  //                     initialValue: data[
                                                  //                             'suitDesignVal']
                                                  //                         [
                                                  //                         vestDesign[
                                                  //                             i]],
                                                  //                     textAlign:
                                                  //                         TextAlign
                                                  //                             .left,
                                                  //                     onSaved:
                                                  //                         (value) {
                                                  //                       setState(
                                                  //                           () {
                                                  //                         try {
                                                  //                           updateSuitVal2[i] =
                                                  //                               value!;
                                                  //                         } catch (e) {}
                                                  //                       });
                                                  //                     },
                                                  //                     style: TextStyle(
                                                  //                         fontSize:
                                                  //                             14),
                                                  //                   ),
                                                  //                 ),
                                                  //               ),
                                                  //           ],
                                                  //         )),
                                                  //   ],
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 100,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  margin: const EdgeInsets.all(20.0),
                                  //padding: EdgeInsets.fromLTRB(50, 50top, right, bottom),
                                  child: TextFormField(
                                    readOnly: userType == "1" ? false : true,
                                    maxLines: 20,
                                    decoration: new InputDecoration(
                                      labelText: '상의 가봉 정보 입력',
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                        borderSide:
                                            BorderSide(color: Colors.black87),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                        borderSide:
                                            BorderSide(color: Colors.black87),
                                      ),
                                    ),
                                    initialValue: data['consult'],
                                    onSaved: (value) {
                                      setState(() {
                                        try {
                                          _consult = value!;
                                        } catch (e) {}
                                      });
                                    },
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  margin: const EdgeInsets.all(20.0),
                                  //padding: EdgeInsets.fromLTRB(50, 50top, right, bottom),
                                  child: TextFormField(
                                    readOnly: userType == "1" ? false : true,
                                    maxLines: 20,
                                    decoration: new InputDecoration(
                                      labelText: '하의/조끼 가봉 정보 입력',
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                        borderSide:
                                            BorderSide(color: Colors.black87),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                        borderSide:
                                            BorderSide(color: Colors.black87),
                                      ),
                                    ),
                                    initialValue: data['consult1'],
                                    onSaved: (value) {
                                      setState(() {
                                        try {
                                          _consult1 = value!;
                                        } catch (e) {}
                                      });
                                    },
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                        userType != "2"
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 30, 20, 10),
                                child: Column(
                                  children: [
                                    Container(
                                      //로그아웃 버튼
                                      width: MediaQuery.of(context).size.width,

                                      child: ElevatedButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.white, //글자색
                                          onSurface: Colors
                                              .white, //onpressed가 null일때 색상
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
                                          showDialog(
                                            context: Get.context!,
                                            builder: (context) => MessagePopup(
                                              title: '데이터 변경',
                                              message: '정보를 변경 하시겠습니까?',
                                              okCallback: () {
                                                _submitData();
                                                //controller.ChangeInitPage();
                                                resultAlert(
                                                    '작업지시서 수정이 완료되었습니다.');
                                                Get.back();

                                                //Get.to(SearchPage());
                                              },
                                              cancleCallback: Get.back,
                                            ),
                                          );
                                        },
                                        child: const Text('변경사항저장'),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: 10,
                              ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: Column(
                            children: [
                              Container(
                                //로그아웃 버튼
                                width: MediaQuery.of(context).size.width,

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
                                    //loginFailAlert();
                                    //Get.to(InputBottomSize());
                                    // /saveDesign();
                                    createPdf2(data['orderType']);
                                  },
                                  child: const Text('작업지시서 출력'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createPdf2(String orderType) async {
    final sizeImage1 = await imageFromAssetBundle('assets/sizeImg1.png');
    final sizeImage2 = await imageFromAssetBundle('assets/sizeImg2.png');
    final sizeImage3 = await imageFromAssetBundle('assets/sizeImg3.png');
    final doc = pw.Document();

    final ttf = await fontFromAssetBundle('fonts/NanumGothic-Regular.ttf');

    (orderType == '0' || orderType == '1') &&
            data['suitDesignVal'][suitDesign[0]] != ''
        ? doc.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              orientation: pw.PageOrientation.natural,
              build: (pw.Context context) {
                return pw.Container(
                  child: pw.Container(
                    width: 820,
                    child: pw.Row(
                      children: [
                        pw.Container(
                            width: 540,
                            child: pw.Column(
                              children: [
                                pw.Container(
                                  height: 15,
                                  //height: 820,
                                  //height: 820,
                                  child: pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Row(
                                        children: [
                                          pw.Text(data['storeName'],
                                              style: pw.TextStyle(font: ttf)),
                                          pw.Text(
                                            '  No. ' + data['orderNo'],
                                            style: pw.TextStyle(font: ttf),
                                          ),
                                        ],
                                      ),
                                      pw.Row(
                                        children: [
                                          pw.Text('Date : '),
                                          pw.Text(data['consultDate'])
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                pw.SizedBox(height: 10),
                                pw.Table(
                                  columnWidths: {
                                    0: pw.FixedColumnWidth(widVal * 0.15),
                                    1: pw.FixedColumnWidth(widVal * 0.35),
                                    //MediaQuery.of(context).size.width * 0.15),
                                    2: pw.FixedColumnWidth(widVal * 0.15),
                                    3: pw.FixedColumnWidth(widVal * 0.35),
                                  },
                                  border: pw.TableBorder.all(),
                                  children: [
                                    pw.TableRow(
                                      children: [
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text('고객정보',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text(
                                              data['name'] == "" ||
                                                      data['name'] == null
                                                  ? '   '
                                                  : data['name']
                                              // +
                                              //     ',(' +
                                              //     data['phone'] +
                                              //     ')'
                                              ,
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text('연락처',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text(
                                              data['phone'] == "" ||
                                                      data['phone'] == null
                                                  ? '   '
                                                  : data['phone'],
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                      ],
                                    ),
                                    pw.TableRow(
                                      children: [
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text('나이',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text(
                                              data['age'] == "" ||
                                                      data['age'] == null
                                                  ? '   '
                                                  : data['age'],
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text('가봉',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text(
                                              data['gabong'] == "" ||
                                                      data['gabong'] == null
                                                  ? '   '
                                                  : data['gabong'],
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                      ],
                                    ),
                                    pw.TableRow(
                                      children: [
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text('가봉공장',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text(
                                              data['gabongFactory'] == "" ||
                                                      data['gabongFactory'] ==
                                                          null
                                                  ? '   '
                                                  : data['gabongFactory'],
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text('제작공장',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text(
                                              data['factory'] == "" ||
                                                      data['factory'] == null
                                                  ? '   '
                                                  : data['factory'],
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                      ],
                                    ),
                                    pw.TableRow(
                                      children: [
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text('중가봉',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text(
                                              data['midgabong'] == "" ||
                                                      data['midgabong'] == null
                                                  ? '   '
                                                  : data['midgabong'],
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          height: 20,
                                          alignment: pw.Alignment.center,
                                          child: pw.Text('완성일',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          child: pw.Text(
                                              data['finishDate'] == "" ||
                                                      data['finishDate'] == null
                                                  ? '  '
                                                  : data['finishDate'],
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        // child: Text(data['name']),
                                      ],
                                    ),
                                  ],
                                ),
                                pw.Table(
                                  columnWidths: {
                                    0: pw.FixedColumnWidth(widVal * 0.15),
                                    1: pw.FixedColumnWidth(widVal * 0.85),
                                    //MediaQuery.of(context).size.width * 0.15),
                                  },
                                  border: pw.TableBorder.all(),
                                  children: [
                                    pw.TableRow(
                                      children: [
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text('체형',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text(
                                              data['bodyType'] == "" ||
                                                      data['bodyType'] == null
                                                  ? '   '
                                                  : data['bodyType'],
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                      ],
                                    ),
                                    pw.TableRow(
                                      children: [
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text('원단',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text(
                                              data['pabric'] == "" ||
                                                      data['pabric'] == null
                                                  ? '   '
                                                  : data['pabric'],
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                      ],
                                    ),
                                    pw.TableRow(
                                      children: [
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text('원단(조끼)',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text(
                                              data['pabricSub1'] == "" ||
                                                      data['pabricSub1'] == null
                                                  ? '   '
                                                  : data['pabricSub1'],
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                      ],
                                    ),
                                    pw.TableRow(
                                      children: [
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text('원단(바지)',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text(
                                              data['pabricSub2'] == "" ||
                                                      data['pabricSub2'] == null
                                                  ? '   '
                                                  : data['pabricSub2'],
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                      ],
                                    ),
                                    pw.TableRow(
                                      children: [
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text('안감',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text(
                                              data['lining'] == "" ||
                                                      data['lining'] == null
                                                  ? '   '
                                                  : data['lining'],
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                      ],
                                    ),
                                    pw.TableRow(
                                      children: [
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text('버튼 및 부자재',
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                        pw.Container(
                                          alignment: pw.Alignment.center,
                                          height: 20,
                                          child: pw.Text(
                                              data['buttons'] == "" ||
                                                      data['buttons'] == null
                                                  ? '   '
                                                  : data['buttons'],
                                              style: pw.TextStyle(font: ttf)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                pw.SizedBox(
                                  height: 10,
                                ),
                                pw.Row(children: [
                                  pw.Container(
                                    height: 450,
                                    alignment: pw.Alignment.topCenter,
                                    child: pw.Table(
                                      border: pw.TableBorder.all(),
                                      columnWidths: {},
                                      children: [
                                        for (var i = 0;
                                            i < topSizeList.length;
                                            i++)
                                          //for (var i in sizeList)
                                          pw.TableRow(
                                            children: [
                                              pw.Container(
                                                width: 80,
                                                height: 30,
                                                child: pw.Row(
                                                  crossAxisAlignment: pw
                                                      .CrossAxisAlignment
                                                      .center,
                                                  mainAxisAlignment: pw
                                                      .MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    pw.SizedBox(width: 5),
                                                    pw.Text(
                                                      topSizeList[i],
                                                      style: pw.TextStyle(
                                                          font: ttf),
                                                    ),
                                                    pw.Container(
                                                      alignment:
                                                          pw.Alignment.center,
                                                      height: 30,
                                                      width: 60,
                                                      child: pw.Text(
                                                        data['topSize'][topSizeDataList[
                                                                        i]] ==
                                                                    "" ||
                                                                data['topSize'][
                                                                        topSizeDataList[
                                                                            i]] ==
                                                                    null
                                                            ? '   '
                                                            : data['topSize'][
                                                                topSizeDataList[
                                                                    i]],
                                                        style: pw.TextStyle(
                                                            font: ttf),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                  pw.Container(
                                    width: 460,
                                    height: 400,
                                    alignment: pw.Alignment.topCenter,
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Container(
                                          alignment: pw.Alignment.topCenter,
                                          padding: pw.EdgeInsets.only(top: 10),
                                          child:
                                              pw.Image(sizeImage1, height: 180),
                                        ),
                                        pw.Container(
                                            alignment: pw.Alignment.centerLeft,
                                            padding: pw.EdgeInsets.only(
                                                left: 50, top: 10),
                                            child: pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.start,
                                              children: [
                                                for (int i = 0;
                                                    i < suitDesign.length;
                                                    i++)
                                                  pw.Container(
                                                    padding:
                                                        pw.EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    //alignment: Alignment.center,
                                                    height: 25,
                                                    child: pw.Text(
                                                        data['suitDesignVal'][
                                                                        suitDesign[
                                                                            i]] ==
                                                                    "" ||
                                                                data['suitDesignVal']
                                                                        [
                                                                        suitDesign[
                                                                            i]] ==
                                                                    null
                                                            ? '   '
                                                            : data['suitDesignVal']
                                                                [suitDesign[i]],
                                                        style: pw.TextStyle(
                                                            font: ttf,
                                                            fontSize: 18)),
                                                  ),
                                                pw.Container(
                                                  padding: pw.EdgeInsets.only(
                                                      top: 10),
                                                  child: pw.Text(
                                                      data['initial'] == "" ||
                                                              data['initial'] ==
                                                                  null
                                                          ? '   '
                                                          : data['initial'],
                                                      style: pw.TextStyle(
                                                          font: ttf,
                                                          fontSize: 18)),
                                                )
                                              ],
                                            )),
                                        pw.Container(height: 150)
                                      ],
                                    ),
                                  ),
                                ]),
                                // pw.Expanded(flex: 1, child: pw.Container()),
                                pw.SizedBox(
                                  height: 10,
                                ),
                                pw.Row(
                                  children: [
                                    pw.Container(
                                      child: pw.Container(
                                        width: 480,
                                        height: 70,
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                                color:
                                                    PdfColor.fromHex('000000'),
                                                width: 1)),
                                        child: pw.Padding(
                                          padding: pw.EdgeInsets.all(10),
                                          child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Text(
                                                  data['consult'] == "" ||
                                                          data['consult'] ==
                                                              null
                                                      ? '   '
                                                      : data['consult'],
                                                  style:
                                                      pw.TextStyle(font: ttf)),
                                              pw.SizedBox(
                                                height: 5,
                                              ),
                                              pw.Text(
                                                  data['consult1'] == "" ||
                                                          data['consult1'] ==
                                                              null
                                                      ? '   '
                                                      : data['consult1'],
                                                  style:
                                                      pw.TextStyle(font: ttf)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      padding: pw.EdgeInsets.only(left: 10),
                                      child: pw.Center(
                                        child: pw.BarcodeWidget(
                                          data: data['orderNo'],
                                          width: 50,
                                          height: 50,
                                          barcode: pw.Barcode.qrCode(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                        pw.Container(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : null;
    (orderType == '0' || orderType == '3') &&
            data['suitDesignVal'][pantsDesign[0]] != ''
        ?
        //바지 작업지시서 출력
        doc.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              orientation: pw.PageOrientation.natural,
              build: (pw.Context context) {
                return pw.Container(
                  child: pw.Container(
                    width: 820,
                    child: pw.Row(
                      children: [
                        pw.Container(
                          width: 540,
                          child: pw.Column(
                            children: [
                              pw.Container(
                                height: 15,
                                //height: 820,
                                //height: 820,
                                child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Row(
                                      children: [
                                        pw.Text(data['storeName'],
                                            style: pw.TextStyle(font: ttf)),
                                        pw.Text(
                                          '  No. ' + data['orderNo'],
                                          style: pw.TextStyle(font: ttf),
                                        ),
                                      ],
                                    ),
                                    pw.Row(
                                      children: [
                                        pw.Text('Date : '),
                                        pw.Text(data['consultDate'])
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              pw.SizedBox(height: 10),
                              pw.Table(
                                columnWidths: {
                                  0: pw.FixedColumnWidth(widVal * 0.15),
                                  1: pw.FixedColumnWidth(widVal * 0.35),
                                  //MediaQuery.of(context).size.width * 0.15),
                                  2: pw.FixedColumnWidth(widVal * 0.15),
                                  3: pw.FixedColumnWidth(widVal * 0.35),
                                },
                                border: pw.TableBorder.all(),
                                children: [
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('고객정보',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['name'] == "" ||
                                                    data['name'] == null
                                                ? '   '
                                                : data['name']
                                            // +
                                            //     ',(' +
                                            //     data['phone'] +
                                            //     ')'
                                            ,
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('연락처',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['phone'] == "" ||
                                                    data['phone'] == null
                                                ? '   '
                                                : data['phone'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('나이',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['age'] == "" ||
                                                    data['age'] == null
                                                ? '   '
                                                : data['age'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('가봉',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['gabong'] == "" ||
                                                    data['gabong'] == null
                                                ? '   '
                                                : data['gabong'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('가봉공장',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['gabongFactory'] == "" ||
                                                    data['gabongFactory'] ==
                                                        null
                                                ? '   '
                                                : data['gabongFactory'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('제작공장',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['factory'] == "" ||
                                                    data['factory'] == null
                                                ? '   '
                                                : data['factory'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('중가봉',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['midgabong'] == "" ||
                                                    data['midgabong'] == null
                                                ? '   '
                                                : data['midgabong'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        height: 20,
                                        alignment: pw.Alignment.center,
                                        child: pw.Text('완성일',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        child: pw.Text(
                                            data['finishDate'] == "" ||
                                                    data['finishDate'] == null
                                                ? '  '
                                                : data['finishDate'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      // child: Text(data['name']),
                                    ],
                                  ),
                                ],
                              ),
                              pw.Table(
                                columnWidths: {
                                  0: pw.FixedColumnWidth(widVal * 0.15),
                                  1: pw.FixedColumnWidth(widVal * 0.85),
                                  //MediaQuery.of(context).size.width * 0.15),
                                },
                                border: pw.TableBorder.all(),
                                children: [
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('체형',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['bodyType'] == "" ||
                                                    data['bodyType'] == null
                                                ? '   '
                                                : data['bodyType'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('원단',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['pabric'] == "" ||
                                                    data['pabric'] == null
                                                ? '   '
                                                : data['pabric'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('원단(조끼)',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['pabricSub1'] == "" ||
                                                    data['pabricSub1'] == null
                                                ? '   '
                                                : data['pabricSub1'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('원단(바지)',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['pabricSub2'] == "" ||
                                                    data['pabricSub2'] == null
                                                ? '   '
                                                : data['pabricSub2'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('안감',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['lining'] == "" ||
                                                    data['lining'] == null
                                                ? '   '
                                                : data['lining'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('버튼 및 부자재',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['buttons'] == "" ||
                                                    data['buttons'] == null
                                                ? '   '
                                                : data['buttons'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              pw.SizedBox(
                                height: 10,
                              ),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    height: 450,
                                    alignment: pw.Alignment.topCenter,
                                    child: pw.Column(
                                      children: [
                                        pw.Table(
                                          border: pw.TableBorder.all(),
                                          children: [
                                            //조끼장 데이터에 대한 여백 확보를 위해 for문에서 제외
                                            for (var i = 0;
                                                i < bottomSizeList.length - 1;
                                                i++)
                                              //for (var i in sizeList)
                                              pw.TableRow(
                                                children: [
                                                  pw.Container(
                                                    width: 80,
                                                    height: i == 2 || i == 3
                                                        ? 40
                                                        : 30,
                                                    child: pw.Row(
                                                      crossAxisAlignment: pw
                                                          .CrossAxisAlignment
                                                          .center,
                                                      mainAxisAlignment: pw
                                                          .MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        pw.SizedBox(width: 5),
                                                        pw.Text(
                                                          bottomSizeList[i],
                                                          style: pw.TextStyle(
                                                              font: ttf),
                                                        ),
                                                        pw.Container(
                                                          alignment: pw
                                                              .Alignment.center,
                                                          height:
                                                              i == 2 || i == 3
                                                                  ? 40
                                                                  : 30,
                                                          width: 60,
                                                          child: pw.Text(
                                                              data['bottomSize'][bottomSizeDataList[
                                                                              i]] ==
                                                                          "" ||
                                                                      data['bottomSize'][bottomSizeDataList[
                                                                              i]] ==
                                                                          null
                                                                  ? '   '
                                                                  : data['bottomSize']
                                                                      [
                                                                      bottomSizeDataList[
                                                                          i]],
                                                              style:
                                                                  pw.TextStyle(
                                                                font: ttf,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        pw.Container(height: 15),
                                      ],
                                    ),
                                  ),
                                  pw.Container(
                                    width: 460,
                                    height: 400,
                                    alignment: pw.Alignment.topCenter,
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Column(children: [
                                          pw.Container(
                                            alignment: pw.Alignment.topCenter,
                                            padding:
                                                pw.EdgeInsets.only(top: 10),
                                            child: pw.Image(sizeImage2,
                                                height: 180),
                                          ),
                                          pw.Container(
                                              alignment:
                                                  pw.Alignment.centerLeft,
                                              padding: pw.EdgeInsets.only(
                                                  left: 50, top: 10),
                                              child: pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  for (int i = 0;
                                                      i < pantsDesign.length;
                                                      i++)
                                                    pw.Container(
                                                      padding: pw.EdgeInsets
                                                          .symmetric(
                                                              vertical: 10),
                                                      //alignment: Alignment.center,
                                                      height: 25,
                                                      child: pw.Text(
                                                          data['suitDesignVal'][
                                                                          pantsDesign[
                                                                              i]] ==
                                                                      "" ||
                                                                  data['suitDesignVal'][
                                                                          pantsDesign[
                                                                              i]] ==
                                                                      null
                                                              ? '   '
                                                              : data['suitDesignVal']
                                                                  [pantsDesign[
                                                                      i]],
                                                          style: pw.TextStyle(
                                                              font: ttf,
                                                              fontSize: 18)),
                                                    ),
                                                ],
                                              )),
                                        ]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              pw.SizedBox(
                                height: 10,
                              ),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    child: pw.Container(
                                      width: 480,
                                      height: 70,
                                      decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: PdfColor.fromHex('000000'),
                                              width: 1)),
                                      child: pw.Padding(
                                        padding: pw.EdgeInsets.all(10),
                                        child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text(
                                                data['consult'] == "" ||
                                                        data['consult'] == null
                                                    ? '   '
                                                    : data['consult'],
                                                style: pw.TextStyle(font: ttf)),
                                            pw.SizedBox(
                                              height: 5,
                                            ),
                                            pw.Text(
                                                data['consult1'] == "" ||
                                                        data['consult1'] == null
                                                    ? '   '
                                                    : data['consult1'],
                                                style: pw.TextStyle(font: ttf)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    padding: pw.EdgeInsets.only(left: 10),
                                    child: pw.Center(
                                      child: pw.BarcodeWidget(
                                        data: data['orderNo'],
                                        width: 50,
                                        height: 50,
                                        barcode: pw.Barcode.qrCode(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : null;

    (orderType == '0' || orderType == '4') &&
            data['suitDesignVal'][vestDesign[0]] != ''
        ? doc.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              orientation: pw.PageOrientation.natural,
              build: (pw.Context context) {
                return pw.Container(
                  child: pw.Container(
                    width: 820,
                    child: pw.Row(
                      children: [
                        pw.Container(
                          width: 540,
                          child: pw.Column(
                            children: [
                              pw.Container(
                                height: 15,
                                //height: 820,
                                //height: 820,
                                child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Row(
                                      children: [
                                        pw.Text(data['storeName'],
                                            style: pw.TextStyle(font: ttf)),
                                        pw.Text(
                                          '  No. ' + data['orderNo'],
                                          style: pw.TextStyle(font: ttf),
                                        ),
                                      ],
                                    ),
                                    pw.Row(
                                      children: [
                                        pw.Text('Date : '),
                                        pw.Text(data['consultDate'])
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              pw.SizedBox(height: 10),
                              pw.Table(
                                columnWidths: {
                                  0: pw.FixedColumnWidth(widVal * 0.15),
                                  1: pw.FixedColumnWidth(widVal * 0.35),
                                  //MediaQuery.of(context).size.width * 0.15),
                                  2: pw.FixedColumnWidth(widVal * 0.15),
                                  3: pw.FixedColumnWidth(widVal * 0.35),
                                },
                                border: pw.TableBorder.all(),
                                children: [
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('고객정보',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['name'] == "" ||
                                                    data['name'] == null
                                                ? '   '
                                                : data['name']
                                            // +
                                            //     ',(' +
                                            //     data['phone'] +
                                            //     ')'
                                            ,
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('연락처',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['phone'] == "" ||
                                                    data['phone'] == null
                                                ? '   '
                                                : data['phone'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('나이',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['age'] == "" ||
                                                    data['age'] == null
                                                ? '   '
                                                : data['age'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('가봉',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['gabong'] == "" ||
                                                    data['gabong'] == null
                                                ? '   '
                                                : data['gabong'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('가봉공장',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['gabongFactory'] == "" ||
                                                    data['gabongFactory'] ==
                                                        null
                                                ? '   '
                                                : data['gabongFactory'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('제작공장',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['factory'] == "" ||
                                                    data['factory'] == null
                                                ? '   '
                                                : data['factory'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('중가봉',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['midgabong'] == "" ||
                                                    data['midgabong'] == null
                                                ? '   '
                                                : data['midgabong'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        height: 20,
                                        alignment: pw.Alignment.center,
                                        child: pw.Text('완성일',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        child: pw.Text(
                                            data['finishDate'] == "" ||
                                                    data['finishDate'] == null
                                                ? '  '
                                                : data['finishDate'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      // child: Text(data['name']),
                                    ],
                                  ),
                                ],
                              ),
                              pw.Table(
                                columnWidths: {
                                  0: pw.FixedColumnWidth(widVal * 0.15),
                                  1: pw.FixedColumnWidth(widVal * 0.85),
                                  //MediaQuery.of(context).size.width * 0.15),
                                },
                                border: pw.TableBorder.all(),
                                children: [
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('체형',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['bodyType'] == "" ||
                                                    data['bodyType'] == null
                                                ? '   '
                                                : data['bodyType'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('원단',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['pabric'] == "" ||
                                                    data['pabric'] == null
                                                ? '   '
                                                : data['pabric'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('원단(조끼)',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['pabricSub1'] == "" ||
                                                    data['pabricSub1'] == null
                                                ? '   '
                                                : data['pabricSub1'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('원단(바지)',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['pabricSub2'] == "" ||
                                                    data['pabricSub2'] == null
                                                ? '   '
                                                : data['pabricSub2'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('안감',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['lining'] == "" ||
                                                    data['lining'] == null
                                                ? '   '
                                                : data['lining'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text('버튼 및 부자재',
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: 20,
                                        child: pw.Text(
                                            data['buttons'] == "" ||
                                                    data['buttons'] == null
                                                ? '   '
                                                : data['buttons'],
                                            style: pw.TextStyle(font: ttf)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              pw.Row(children: [
                                pw.Container(
                                  height: 450,
                                  //alignment: Alignment.centerLeft,
                                  child: pw.Column(children: [
                                    pw.Container(height: 15),
                                    pw.Table(
                                      border: pw.TableBorder.all(),
                                      children: [
                                        pw.TableRow(
                                          children: [
                                            pw.Container(
                                              width: 80,
                                              height: 30,
                                              child: pw.Row(
                                                mainAxisAlignment: pw
                                                    .MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  pw.Text(
                                                    bottomSizeList[7],
                                                    style:
                                                        pw.TextStyle(font: ttf),
                                                  ),
                                                  pw.SizedBox(width: 10),
                                                  pw.Container(
                                                    alignment:
                                                        pw.Alignment.center,
                                                    height: 30,
                                                    width: 60,
                                                    child: pw.Text(
                                                        data['bottomSize'][
                                                                        bottomSizeDataList[
                                                                            7]] ==
                                                                    "" ||
                                                                data['bottomSize']
                                                                        [
                                                                        bottomSizeDataList[
                                                                            7]] ==
                                                                    null
                                                            ? '   '
                                                            : data['bottomSize']
                                                                [
                                                                bottomSizeDataList[
                                                                    7]],
                                                        style: pw.TextStyle(
                                                          font: ttf,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    pw.Table(
                                      border: pw.TableBorder.all(),
                                      children: [
                                        for (var i = 0;
                                            i < vestSizeList.length;
                                            i++)
                                          //for (var i in sizeList)
                                          pw.TableRow(
                                            children: [
                                              pw.Container(
                                                width: 80,
                                                height: 30,
                                                child: pw.Row(
                                                  mainAxisAlignment: pw
                                                      .MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    pw.Text(
                                                      vestSizeList[i],
                                                      style: pw.TextStyle(
                                                          font: ttf),
                                                    ),
                                                    pw.SizedBox(width: 10),
                                                    pw.Container(
                                                      alignment:
                                                          pw.Alignment.center,
                                                      height: 30,
                                                      width: 60,
                                                      child: pw.Text(
                                                          data['topSize'][vestSizeDataList[
                                                                          i]] ==
                                                                      "" ||
                                                                  data['topSize']
                                                                          [
                                                                          vestSizeDataList[
                                                                              i]] ==
                                                                      null
                                                              ? '   '
                                                              : data['topSize'][
                                                                  vestSizeDataList[
                                                                      i]],
                                                          style: pw.TextStyle(
                                                            font: ttf,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ]),
                                ),
                                pw.Container(
                                  width: 460,
                                  height: 400,
                                  alignment: pw.Alignment.topCenter,
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Column(
                                        children: [
                                          pw.Container(
                                            alignment: pw.Alignment.topCenter,
                                            padding:
                                                pw.EdgeInsets.only(top: 10),
                                            child: pw.Image(sizeImage3,
                                                height: 180),
                                          ),
                                          pw.Container(
                                              alignment:
                                                  pw.Alignment.centerLeft,
                                              padding: pw.EdgeInsets.only(
                                                  left: 50, top: 10),
                                              child: pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  for (int i = 0;
                                                      i < vestDesign.length;
                                                      i++)
                                                    pw.Container(
                                                      padding: pw.EdgeInsets
                                                          .symmetric(
                                                              vertical: 10),
                                                      height: 25,
                                                      child: pw.Text(
                                                          data['suitDesignVal'][
                                                                          vestDesign[
                                                                              i]] ==
                                                                      "" ||
                                                                  data['suitDesignVal'][
                                                                          vestDesign[
                                                                              i]] ==
                                                                      null
                                                              ? '   '
                                                              : data['suitDesignVal']
                                                                  [vestDesign[
                                                                      i]],
                                                          style: pw.TextStyle(
                                                              font: ttf,
                                                              fontSize: 18)),
                                                    ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                              pw.SizedBox(
                                height: 10,
                              ),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    child: pw.Container(
                                      width: 480,
                                      height: 70,
                                      decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: PdfColor.fromHex('000000'),
                                              width: 1)),
                                      child: pw.Padding(
                                        padding: pw.EdgeInsets.all(10),
                                        child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text(
                                                data['consult'] == "" ||
                                                        data['consult'] == null
                                                    ? '   '
                                                    : data['consult'],
                                                style: pw.TextStyle(font: ttf)),
                                            pw.SizedBox(
                                              height: 5,
                                            ),
                                            pw.Text(
                                                data['consult1'] == "" ||
                                                        data['consult1'] == null
                                                    ? '   '
                                                    : data['consult1'],
                                                style: pw.TextStyle(font: ttf)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    padding: pw.EdgeInsets.only(left: 10),
                                    child: pw.Center(
                                      child: pw.BarcodeWidget(
                                        data: data['orderNo'],
                                        width: 50,
                                        height: 50,
                                        barcode: pw.Barcode.qrCode(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : null;

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
