import 'dart:io';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/shirt_design_val.dart';
import 'package:bykak/src/model/shirt_size_model.dart';
import 'package:bykak/src/pages/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/alert_fucntion.dart';

final firestore = FirebaseFirestore.instance;

class ShirtResultPage extends StatefulWidget {
  ShirtResultPage({Key? key}) : super(key: key);

  @override
  State<ShirtResultPage> createState() => _ShirtResultPageState();
}

class _ShirtResultPageState extends State<ShirtResultPage> {
  final data = Get.arguments['data'];
  List<String> shirtSizeList = [
    '목',
    '어깨',
    '소매',
    '상동',
    '중동',
    '힢',
    '기장',
    '암홀',
    '팔통',
    '손목',
  ];
  List<String> shirtSizeDataList = [
    'neck',
    'shoulder',
    'sleeve',
    'sangdong',
    'jungdong',
    'hip',
    'topHeight',
    'armhole',
    'armSize',
    'wrist',
  ];
  List<String> shirtDesign = [
    'shirtPattern',
    'shirtCollar',
    'shirtCuffs',
    'shirtPlacket',
    'shirtOption',
  ];
  @override
  void initState() {
    getData();
    super.initState();
  }

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

  var updateShirtSize = List<String>.filled(15, "");
  var updateShirtDesign1 = List<String>.filled(5, "");
  var updateShirtVal = List<String>.filled(5, "");

  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _phone;
  String? _pabric;
  String? _age;
  String? _height;
  String? _weight;
  String? _bodyType;
  String? _finishDate;
  String? _buttons;
  String? _factory;
  String? _gabongFactory;
  String? _gabong;
  String? _midgabong;
  String? _consult;
  String? _initial;
  String? _price;

  ShirtSize? _inputShirtSize;
  BottomSize? _inputBottomSize;
  ShirtDesignVal? _shirtDesignVal;

  void _submitData() async {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_isValid) {
      _formKey.currentState!.save();
    }
    _inputShirtSize = ShirtSize(
      neck: updateShirtSize[0],
      shoulder: updateShirtSize[1],
      sleeve: updateShirtSize[2],
      sangdong: updateShirtSize[3],
      jungdong: updateShirtSize[4],
      hip: updateShirtSize[5],
      topHeight: updateShirtSize[6],
      armhole: updateShirtSize[7],
      armSize: updateShirtSize[8],
      wrist: updateShirtSize[9],
    );

    _shirtDesignVal = ShirtDesignVal(
      shirtPattern: updateShirtVal[0],
      shirtCollar: updateShirtVal[1],
      shirtPlacket: updateShirtVal[2],
      shirtCuffs: updateShirtVal[3],
      shirtOption: updateShirtVal[4],
    );

    FirebaseFirestore.instance.collection('orders').doc(data['orderNo']).set({
      'name': _name,
      'phone': _phone,
      'pabric': _pabric,
      'age': _age,
      'height': _height,
      'weight': _weight,
      'bodyType': _bodyType,
      'finishDate': _finishDate,
      'gabong': _gabong,
      'midgabong': _midgabong,
      'consult': _consult,
      'initial': _initial,
      'price': _price,
      'shirtSize': _inputShirtSize!.toJson(),
      'shirtDesignVal': _shirtDesignVal!.toJson(),
      //'suitDesign': _suitDesign!.toJson(),
    }, SetOptions(merge: true));
  }

  var widVal;
  var heiVal;
  @override
  Widget build(BuildContext context) {
    widVal = MediaQuery.of(context).size.width;
    heiVal = MediaQuery.of(context).size.height;
    try {
      _price = data['price'];
    } catch (e) {
      _price = "0";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back, size: 22.0, color: Colors.black),
            )),
        title: Text(''),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: widVal < 481 ? widVal : 800,
                color: Colors.white,
                child: Column(
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(data['storeName']),
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
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '  No. ' + data['orderNo'],
                                  ),
                                ],
                              ),
                              Row(
                                children: [],
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
                                      ? MediaQuery.of(context).size.width * 0.20
                                      : 800 * 0.20),
                                  2: FixedColumnWidth(widVal < 481
                                      ? MediaQuery.of(context).size.width * 0.20
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
                                          readOnly:
                                              userType == "1" ? false : true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(bottom: 12), //
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
                                          readOnly:
                                              userType == "1" ? false : true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(bottom: 12), //
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
                                        child: Text('키'),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 28,
                                        child: TextFormField(
                                          readOnly:
                                              userType == "1" ? false : true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(bottom: 12), //
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
                                          readOnly:
                                              userType == "1" ? false : true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(bottom: 12), //
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
                                          readOnly:
                                              userType == "1" ? false : true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(bottom: 12), //
                                            border: InputBorder.none,
                                          ),
                                          initialValue: data['gabongFactory'],
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
                                          readOnly:
                                              userType == "1" ? false : true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(bottom: 12), //
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
                                          readOnly:
                                              userType == "1" ? false : true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(bottom: 12), //
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
                                          readOnly:
                                              userType == "1" ? false : true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(bottom: 12), //
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
                                          readOnly:
                                              userType == "1" ? false : true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(bottom: 12), //
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
                                          readOnly:
                                              userType == "1" ? false : true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(bottom: 12), //
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
                                          child: Text('체형'),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          height: 28,
                                          child: TextFormField(
                                            readOnly:
                                                userType == "1" ? false : true,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
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
                                            readOnly:
                                                userType == "1" ? false : true,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
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
                                          child: Text('버튼'),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          height: 28,
                                          child: TextFormField(
                                            readOnly:
                                                userType == "1" ? false : true,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
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

                      Row(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Table(
                                    border: TableBorder.all(),
                                    columnWidths: {
                                      0: FixedColumnWidth(widVal < 481
                                          ? MediaQuery.of(context).size.width *
                                              0.30
                                          : 800 * 0.20),
                                    },
                                    children: [
                                      for (var i = 0;
                                          i < shirtSizeList.length;
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
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    shirtSizeList[i],
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        widVal < 481 ? 5 : 10,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: 35,
                                                    width: 50,
                                                    child: TextFormField(
                                                      decoration:
                                                          new InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                      ),
                                                      initialValue: data[
                                                              'shirtSize'][
                                                          shirtSizeDataList[i]],
                                                      textAlign:
                                                          TextAlign.center,
                                                      onSaved: (value) {
                                                        setState(() {
                                                          try {
                                                            updateShirtSize[i] =
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
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              widVal < 481
                                  ? SizedBox(
                                      height: 130,
                                    )
                                  : SizedBox(
                                      height: 200,
                                    )
                            ],
                          ),
                          Padding(
                            padding: widVal < 481
                                ? const EdgeInsets.only(
                                    left: 30,
                                  )
                                : widVal < 1200
                                    ? const EdgeInsets.only(
                                        left: 20,
                                      )
                                    : const EdgeInsets.only(left: 20, top: 50),
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      'assets/shirtImg.png',
                                      width: widVal < 481
                                          ? widVal * 0.30
                                          : 800 * 0.20,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 50),
                                      Container(
                                        width: widVal < 481
                                            ? widVal * 0.50
                                            : widVal < 1200
                                                ? widVal * 0.35
                                                : widVal * 0.35,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '셔츠디자인',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            for (int i = 0;
                                                i < shirtDesign.length;
                                                i++)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 50,
                                                  child: TextFormField(
                                                    maxLines: 2,
                                                    decoration: new InputDecoration(

                                                        // border: InputBorder.none,
                                                        // focusedBorder:
                                                        //     InputBorder.none,
                                                        ),
                                                    initialValue:
                                                        data['shirtDesignVal']
                                                            [shirtDesign[i]],
                                                    textAlign: TextAlign.left,
                                                    onSaved: (value) {
                                                      setState(() {
                                                        try {
                                                          updateShirtVal[i] =
                                                              value!;
                                                        } catch (e) {}
                                                      });
                                                    },
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                        ),
                                        width: widVal < 481
                                            ? widVal * 0.50
                                            : widVal < 1200
                                                ? widVal * 0.35
                                                : widVal * 0.35,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '이니셜 ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 10),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: 2,
                                                decoration: new InputDecoration(

                                                    // border:
                                                    //     InputBorder
                                                    //         .none,
                                                    // focusedBorder:
                                                    //     InputBorder
                                                    //         .none,
                                                    ),
                                                initialValue: data['initial'],
                                                textAlign: TextAlign.left,
                                                onSaved: (value) {
                                                  setState(() {
                                                    try {
                                                      _initial = value!;
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
                          )
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        //padding: EdgeInsets.fromLTRB(50, 50top, right, bottom),
                        child: TextFormField(
                          maxLines: 20,
                          decoration: new InputDecoration(
                            labelText: '셔츠 요청 사항 입력',
                            labelStyle: TextStyle(color: Colors.black87),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: BorderSide(color: Colors.black87),
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
                    ]),
                    userType != "2"
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
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
                                      showDialog(
                                          context: Get.context!,
                                          builder: (context) => MessagePopup(
                                                title: '작업지시서 데이터 변경',
                                                message: '정보를 변경 하시겠습니까?',
                                                okCallback: () {
                                                  _submitData();
                                                  //controller.ChangeInitPage();
                                                  resultAlert(
                                                      '작업지시서 수정이 완료되었습니다.');
                                                  Get.back();
                                                },
                                                cancleCallback: Get.back,
                                              ));
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
                                onSurface: Colors.white, //onpressed가 null일때 색상
                                backgroundColor: HexColor('#172543'),
                                shadowColor: Colors.white, //그림자 색상
                                elevation: 1, // 버튼 입체감
                                textStyle: TextStyle(fontSize: 16),
                                //padding: EdgeInsets.all(16.0),
                                minimumSize: Size(300, 50), //최소 사이즈
                                side: BorderSide(
                                    color: HexColor('#172543'), width: 1.0), //선
                                shape:
                                    StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                alignment: Alignment.center,
                              ), //글자위치 변경
                              onPressed: () {
                                //loginFailAlert();
                                //Get.to(InputBottomSize());
                                // /saveDesign();
                                createPdf();
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
    );
  }

  void createPdf() async {
    final sizeImage1 = await imageFromAssetBundle('assets/shirtImg.png');

    final doc = pw.Document();
    final ttf = await fontFromAssetBundle('fonts/NanumGothic-Regular.ttf');

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.natural,
        build: (pw.Context context) {
          return pw.Container(
            width: 820,
            child: pw.Column(children: [
              pw.Container(
                width: 540,

                //height: 820,
                //height: 820,
                child: pw.Container(
                  height: 15,
                  //height: 820,
                  //height: 820,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
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
                        child: pw.Text('고객정보', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 20,
                        child: pw.Text(
                            data['name'] == "" || data['name'] == null
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
                        child: pw.Text('연락처', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 20,
                        child: pw.Text(
                            data['phone'] == "" || data['phone'] == null
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
                        child: pw.Text('나이', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 20,
                        child: pw.Text(
                            data['age'] == "" || data['age'] == null
                                ? '   '
                                : data['age'],
                            style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 20,
                        child: pw.Text('가봉', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 20,
                        child: pw.Text('', style: pw.TextStyle(font: ttf)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 20,
                        child: pw.Text('가봉공장', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 20,
                        child: pw.Text('', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 20,
                        child: pw.Text('제작공장', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 20,
                        child: pw.Text(
                            data['factory'] == "" || data['factory'] == null
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
                        child: pw.Text('중가봉', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 20,
                        child: pw.Text('', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        height: 20,
                        alignment: pw.Alignment.center,
                        child: pw.Text('완성일', style: pw.TextStyle(font: ttf)),
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
                        child: pw.Text('체형', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 20,
                        child: pw.Text(
                            data['bodyType'] == "" || data['bodyType'] == null
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
                        child: pw.Text('원단', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 20,
                        child: pw.Text(
                            data['pabric'] == "" || data['pabric'] == null
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
                        child:
                            pw.Text('버튼 및 부자재', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 20,
                        child: pw.Text(
                            data['buttons'] == "" || data['buttons'] == null
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
                  height: 510,
                  alignment: pw.Alignment.topCenter,
                  child: pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {},
                    children: [
                      for (var i = 0; i < shirtSizeList.length; i++)
                        //for (var i in sizeList)
                        pw.TableRow(
                          children: [
                            pw.Container(
                              width: 80,
                              height: 30,
                              child: pw.Row(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.SizedBox(width: 5),
                                  pw.Text(
                                    shirtSizeList[i],
                                    style: pw.TextStyle(font: ttf),
                                  ),
                                  pw.SizedBox(width: 10),
                                  pw.Container(
                                    alignment: pw.Alignment.center,
                                    height: 30,
                                    width: 60,
                                    child: pw.Text(
                                      data['shirtSize'][shirtSizeDataList[i]] ==
                                                  "" ||
                                              data['shirtSize']
                                                      [shirtSizeDataList[i]] ==
                                                  null
                                          ? '   '
                                          : data['shirtSize']
                                              [shirtSizeDataList[i]],
                                      style: pw.TextStyle(font: ttf),
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
                  height: 510,
                  alignment: pw.Alignment.topCenter,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        children: [
                          pw.Container(
                            alignment: pw.Alignment.topCenter,
                            padding: pw.EdgeInsets.only(top: 10),
                            child: pw.Image(sizeImage1, height: 180),
                          ),
                          pw.Container(
                              alignment: pw.Alignment.centerLeft,
                              padding: pw.EdgeInsets.only(left: 50, top: 10),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0; i < shirtDesign.length; i++)
                                    pw.Container(
                                      padding:
                                          pw.EdgeInsets.symmetric(vertical: 10),
                                      //alignment: Alignment.center,
                                      height: 25,
                                      child: pw.Text(
                                          data['shirtDesignVal']
                                                          [shirtDesign[i]] ==
                                                      "" ||
                                                  data['shirtDesignVal']
                                                          [shirtDesign[i]] ==
                                                      null
                                              ? '   '
                                              : data['shirtDesignVal']
                                                  [shirtDesign[i]],
                                          style: pw.TextStyle(font: ttf)),
                                    ),
                                  pw.Text(
                                      data['initial'] == "" ||
                                              data['initial'] == null
                                          ? '   '
                                          : '이니셜 ' + data['initial'],
                                      style: pw.TextStyle(font: ttf)),
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
                              color: PdfColor.fromHex('000000'), width: 1)),
                      child: pw.Padding(
                        padding: pw.EdgeInsets.all(10),
                        child: pw.Text(
                            data['consult'] == "" || data['consult'] == null
                                ? '   '
                                : data['consult'],
                            style: pw.TextStyle(font: ttf)),
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
            ]),
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
