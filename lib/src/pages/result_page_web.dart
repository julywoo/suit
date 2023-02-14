import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bykak/src/app.dart';
import 'package:bykak/src/components/alert_fucntion.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/components/number_format.dart';
import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/suit_design_model.dart';
import 'package:bykak/src/model/suit_design_val.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/model/vest_size_model.dart';
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

class _ResultPageWebState extends State<ResultPageWeb>
    with TickerProviderStateMixin {
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
  List<String> bottomSizeList = [
    '허리',
    '힙',
    '밑위\n길이',
    '바깥\n기장',
    '허벅',
    '둘레',
    '밑통',
  ];
  List<String> vestSizeList = [
    '각도',
    '상동',
    '중동',
    '앞길',
    '조끼장',
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
  ];
  List<String> vestSizeDataList = [
    'angle',
    'sangdong',
    'jungdong',
    'apgil',
    'vestHeight',
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
  bool _isLoading = true;
  List jacketStep = [];
  List pantsStep = [];
  List shirtStep = [];
  List vestStep = [];
  List jacketList = [];
  List shirtList = [];
  List vestList = [];
  List pantsList = [];

  bool includeVest = true;

  getConsultData() async {
    try {
      var consultOptionsResult;
      try {
        consultOptionsResult =
            await firestore.collection('consultsOptions').doc(storeName).get();
      } catch (e) {
        consultOptionsResult =
            await firestore.collection('consultsOptions').doc('기본상담').get();
      }

      if (orderType == '1') {
        jacketStep = consultOptionsResult['jacketStep'];
        final jacketValue = data['jacketOption'].values.toList();
        final jacketKey = data['jacketOption'].keys.toList();
        for (var i = 0; i < jacketStep.length; i++) {
          try {
            var index;
            index = jacketKey.indexOf(jacketStep[i]);
            jacketList.add(
                jacketValue[index].replaceAll('직접입력', '').replaceAll('\n', ''));
          } catch (e) {}
        }
      } else if (orderType == '2') {
        shirtStep = consultOptionsResult['shirtStep'];
        final shirtValue = data['shirtOption'].values.toList();
        final shirtKey = data['shirtOption'].keys.toList();
        for (var i = 0; i < shirtStep.length; i++) {
          try {
            var index;
            index = shirtKey.indexOf(shirtStep[i]);
            shirtList.add(
                shirtValue[index].replaceAll('직접입력', '').replaceAll('\n', ''));
          } catch (e) {}
        }

        for (var i = 0; i < shirtStep.length; i++) {
          setState(() {
            selectedShirtOption[shirtStep[i]] = shirtList[i];
          });
        }

        for (var i = 0; i < updateShirtSize.length; i++) {
          setState(() {
            updateShirtSize[i] = data['shirtSize'][shirtSizeDataList[i]];
          });
        }
      } else if (orderType == '3') {
        pantsStep = consultOptionsResult['pantsStep'];
        final pantsValue = data['pantsOption'].values.toList();
        final pantsKey = data['pantsOption'].keys.toList();
        for (var i = 0; i < pantsStep.length; i++) {
          try {
            var index;
            index = pantsKey.indexOf(pantsStep[i]);
            pantsList.add(
                pantsValue[index].replaceAll('직접입력', '').replaceAll('\n', ''));
          } catch (e) {}
        }
      } else if (orderType == '4') {
        vestStep = consultOptionsResult['vestStep'];
        final vestValue = data['vestOption'].values.toList();
        final vestKey = data['vestOption'].keys.toList();
        for (var i = 0; i < vestStep.length; i++) {
          try {
            var index;
            index = vestKey.indexOf(vestStep[i]);
            vestList.add(
                vestValue[index].replaceAll('직접입력', '').replaceAll('\n', ''));
          } catch (e) {}
        }
      } else {
        if (data['vestOption'].toString().length < 3 ||
            data['vestOption'] == null) {
          setState(() {
            includeVest = false;
          });

          jacketStep = consultOptionsResult['jacketStep'];
          final jacketValue = data['jacketOption'].values.toList();
          final jacketKey = data['jacketOption'].keys.toList();
          for (var i = 0; i < jacketStep.length; i++) {
            try {
              var index;
              index = jacketKey.indexOf(jacketStep[i]);
              jacketList.add(jacketValue[index]
                  .replaceAll('직접입력', '')
                  .replaceAll('\n', ''));
            } catch (e) {}
          }
          pantsStep = consultOptionsResult['pantsStep'];
          final pantsValue = data['pantsOption'].values.toList();
          final pantsKey = data['pantsOption'].keys.toList();
          for (var i = 0; i < pantsStep.length; i++) {
            try {
              var index;
              index = pantsKey.indexOf(pantsStep[i]);
              pantsList.add(pantsValue[index]
                  .replaceAll('직접입력', '')
                  .replaceAll('\n', ''));
            } catch (e) {}
          }
          for (var i = 0; i < jacketStep.length; i++) {
            setState(() {
              selectedJacketOption[jacketStep[i]] = jacketList[i];
            });
          }

          for (var i = 0; i < updateTopSize.length; i++) {
            setState(() {
              updateTopSize[i] = data['topSize'][topSizeDataList[i]];
            });
          }
//====================================
          for (var i = 0; i < pantsStep.length; i++) {
            setState(() {
              selectedPantsOption[pantsStep[i]] = pantsList[i];
            });
          }

          for (var i = 0; i < updateBottomSize.length; i++) {
            setState(() {
              updateBottomSize[i] = data['bottomSize'][bottomSizeDataList[i]];
            });
          }
        } else {
          jacketStep = consultOptionsResult['jacketStep'];
          pantsStep = consultOptionsResult['pantsStep'];
          vestStep = consultOptionsResult['vestStep'];
          try {
            final jacketValue = data['jacketOption'].values.toList();
            final jacketKey = data['jacketOption'].keys.toList();
            for (var i = 0; i < jacketStep.length; i++) {
              try {
                var index;
                index = jacketKey.indexOf(jacketStep[i]);
                jacketList.add(jacketValue[index]
                    .replaceAll('직접입력', '')
                    .replaceAll('\n', ''));
              } catch (e) {}
            }
            final pantsValue = data['pantsOption'].values.toList();
            final pantsKey = data['pantsOption'].keys.toList();
            for (var i = 0; i < pantsStep.length; i++) {
              try {
                var index;
                index = pantsKey.indexOf(pantsStep[i]);
                pantsList.add(pantsValue[index]
                    .replaceAll('직접입력', '')
                    .replaceAll('\n', ''));
              } catch (e) {}
            }

            final vestValue = data['vestOption'].values.toList();
            final vestKey = data['vestOption'].keys.toList();
            for (var i = 0; i < vestStep.length; i++) {
              try {
                var index;
                index = vestKey.indexOf(vestStep[i]);
                vestList.add(vestValue[index]
                    .replaceAll('직접입력', '')
                    .replaceAll('\n', ''));
              } catch (e) {}
            }
          } catch (e) {}
          for (var i = 0; i < jacketStep.length; i++) {
            setState(() {
              selectedJacketOption[jacketStep[i]] = jacketList[i];
            });
          }

          for (var i = 0; i < updateTopSize.length; i++) {
            setState(() {
              updateTopSize[i] = data['topSize'][topSizeDataList[i]];
            });
          }
//====================================
          for (var i = 0; i < pantsStep.length; i++) {
            setState(() {
              selectedPantsOption[pantsStep[i]] = pantsList[i];
            });
          }

          for (var i = 0; i < updateBottomSize.length; i++) {
            setState(() {
              updateBottomSize[i] = data['bottomSize'][bottomSizeDataList[i]];
            });
          }
          //====================================
          for (var i = 0; i < vestStep.length; i++) {
            setState(() {
              selectedVestOption[vestStep[i]] = vestList[i];
            });
          }
          for (var i = 0; i < updateVestSize.length; i++) {
            setState(() {
              updateVestSize[i] = data['vestSize'][vestSizeDataList[i]];
            });
          }
        }
      }
    } catch (e) {}

    if (orderType == '1') {
      _tabController = TabController(length: 1, vsync: this, initialIndex: 0);
      _tabList = [
        '자켓',
      ];
    } else if (orderType == '2') {
      _tabController = TabController(length: 1, vsync: this, initialIndex: 0);
      _tabList = [
        '셔츠',
      ];
    } else if (orderType == '3') {
      _tabController = TabController(length: 1, vsync: this, initialIndex: 0);
      _tabList = [
        '바지',
      ];
    } else if (orderType == '4') {
      _tabController = TabController(length: 1, vsync: this, initialIndex: 0);
      _tabList = [
        '조끼',
      ];
    } else if (orderType == '0') {
      if (includeVest) {
        _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
        _tabList = [
          '자켓',
          '조끼',
          '바지',
        ];
      } else {
        _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
        _tabList = [
          '자켓',
          '바지',
        ];
      }
    }
  }

  late TabController _tabController;
  var _tabList = [];
  String orderType = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    setState(() {
      orderType = data['orderType'];
    });
    getData();
    getConsultData();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    // 세로 화면 고정
    _tabController.dispose();

    super.dispose();
  }

  final firestore = FirebaseFirestore.instance;
  User? auth = FirebaseAuth.instance.currentUser;
  String userType = "";
  String storeName = "";
  getData() async {
    try {
      var userData =
          await firestore.collection('users').doc(auth!.email.toString()).get();

      setState(() {
        userType = userData['userType'];
        storeName = userData['storeName'];
      });
    } catch (e) {}
  }

  var updateTopSize = List<String>.filled(15, "");
  var updateBottomSize = List<String>.filled(7, "");
  var updateVestSize = List<String>.filled(5, "");
  var updateShirtSize = List<String>.filled(10, "");

  var updateSuitDesign1 = List<String>.filled(6, "");
  var updateSuitDesign2 = List<String>.filled(2, "");
  var updateSuitDesign3 = List<String>.filled(6, "");

  var updateSuitVal1 = List<String>.filled(6, "");
  var updateSuitVal2 = List<String>.filled(2, "");
  var updateSuitVal3 = List<String>.filled(6, "");

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  Map selectedJacketOption = {};
  Map selectedVestOption = {};
  Map selectedPantsOption = {};
  Map selectedShirtOption = {};

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
  VestSize? _inputVestSize;
  SuitDesign? _suitDesign;
  SuitDesignVal? _suitDesignVal;

  void _submitData() async {
    // print(selectedJacketOption.toString());
    // print(updateTopSize.toString());

    // print(selectedPantsOption.toString());
    // print(updateBottomSize.toString());
    if (_formKey.currentState!.validate()) {
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

    _inputVestSize = VestSize(
      angle: updateVestSize[0],
      sangdong: updateVestSize[1],
      jungdong: updateVestSize[2],
      apgil: updateVestSize[3],
      vestHeight: updateVestSize[4],
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
      'vestSize': _inputVestSize!.toJson(),
      'jacketOption': selectedJacketOption,
      'vestOption': selectedVestOption,
      'pantsOption': selectedPantsOption,
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
      body: _isLoading
          ? Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: HexColor('#172543'),
                ),
              ),
            )
          : Form(
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
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 30, 20, 10),
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
                                          GetPlatform.isMobile
                                              ? Text('')
                                              : Row(
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
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '기본정보',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 10),
                                    height: 180,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  height: 20,
                                                  child: Text(
                                                    '이름',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: Text(
                                                    '연령대',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: Text(
                                                    '키',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: Text(
                                                    '가봉공장',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: Text(
                                                    '제작공장',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: Text(
                                                    '제품금액',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  height: 20,
                                                  child: TextFormField(
                                                    readOnly: userType == "1"
                                                        ? false
                                                        : true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 20),
                                                    ),
                                                    initialValue: data['name'],
                                                    textAlign: TextAlign.center,
                                                    onSaved: (value) {
                                                      _name = value!;
                                                    },
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: TextFormField(
                                                    readOnly: userType == "1"
                                                        ? false
                                                        : true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 20),
                                                    ),
                                                    initialValue: data['age'],
                                                    textAlign: TextAlign.center,
                                                    onSaved: (value) {
                                                      _age = value!;
                                                    },
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: TextFormField(
                                                    readOnly: userType == "1"
                                                        ? false
                                                        : true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 20),
                                                    ),
                                                    initialValue:
                                                        data['height'],
                                                    textAlign: TextAlign.center,
                                                    onSaved: (value) {
                                                      _height = value!;
                                                    },
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: TextFormField(
                                                    readOnly: userType == "1"
                                                        ? false
                                                        : true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 20),
                                                    ),
                                                    initialValue:
                                                        data['gabongFactory'],
                                                    textAlign: TextAlign.center,
                                                    onSaved: (value) {
                                                      _gabongFactory = value!;
                                                    },
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: TextFormField(
                                                    readOnly: userType == "1"
                                                        ? false
                                                        : true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 20),
                                                    ),
                                                    initialValue:
                                                        data['factory'],
                                                    textAlign: TextAlign.center,
                                                    onSaved: (value) {
                                                      _factory = value!;
                                                    },
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: TextFormField(
                                                    readOnly: userType == "1"
                                                        ? false
                                                        : true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 20),
                                                    ),
                                                    initialValue:
                                                        moneyFormatText(
                                                            data['price'] ??
                                                                '0'),
                                                    textAlign: TextAlign.center,
                                                    onSaved: (value) {
                                                      _price = value!;
                                                    },
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  height: 20,
                                                  child: Text(
                                                    '연락처',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: Text(
                                                    '브랜드',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: Text(
                                                    '몸무게',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: Text(
                                                    '가봉일자',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: Text(
                                                    '중가봉일자',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: Text(
                                                    '완성일자',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  height: 20,
                                                  child: TextFormField(
                                                    readOnly: userType == "1"
                                                        ? false
                                                        : true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 20),
                                                    ),
                                                    initialValue: data['phone'],
                                                    textAlign: TextAlign.center,
                                                    onSaved: (value) {
                                                      _phone = value!;
                                                    },
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: TextFormField(
                                                    readOnly: userType == "1"
                                                        ? false
                                                        : true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 20),
                                                    ),
                                                    initialValue:
                                                        data['brandRate'],
                                                    textAlign: TextAlign.center,
                                                    onSaved: (value) {
                                                      // _brandRate = value!;
                                                    },
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: TextFormField(
                                                    readOnly: userType == "1"
                                                        ? false
                                                        : true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 20),
                                                    ),
                                                    initialValue:
                                                        data['weight'],
                                                    textAlign: TextAlign.center,
                                                    onSaved: (value) {
                                                      _weight = value!;
                                                    },
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: TextFormField(
                                                    readOnly: userType == "1"
                                                        ? false
                                                        : true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 20),
                                                    ),
                                                    initialValue:
                                                        data['gabong'],
                                                    textAlign: TextAlign.center,
                                                    onSaved: (value) {
                                                      _gabong = value!;
                                                    },
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: TextFormField(
                                                    readOnly: userType == "1"
                                                        ? false
                                                        : true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 20),
                                                    ),
                                                    initialValue:
                                                        data['midgabong'],
                                                    textAlign: TextAlign.center,
                                                    onSaved: (value) {
                                                      _midgabong = value!;
                                                    },
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  child: TextFormField(
                                                    readOnly: userType == "1"
                                                        ? false
                                                        : true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 20),
                                                    ),
                                                    initialValue:
                                                        data['finishDate'],
                                                    textAlign: TextAlign.center,
                                                    onSaved: (value) {
                                                      _finishDate = value!;
                                                    },
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    height: 180,
                                    child: Row(children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                '체형',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black45),
                                              ),
                                              Text(
                                                '원단명',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black45),
                                              ),
                                              Text(
                                                '원단명(조끼)',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black45),
                                              ),
                                              Text(
                                                '원단명(바지)',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black45),
                                              ),
                                              Text(
                                                '안감',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black45),
                                              ),
                                              Text(
                                                '버튼 및 부자재',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black45),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                height: 20,
                                                child: TextFormField(
                                                  readOnly: userType == "1"
                                                      ? false
                                                      : true,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 20),
                                                  ),
                                                  initialValue:
                                                      data['bodyType'],
                                                  textAlign: TextAlign.center,
                                                  onSaved: (value) {
                                                    _bodyType = value!;
                                                  },
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: TextFormField(
                                                  readOnly: userType == "1"
                                                      ? false
                                                      : true,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 20),
                                                  ),
                                                  initialValue: data['pabric'],
                                                  textAlign: TextAlign.center,
                                                  onSaved: (value) {
                                                    _pabric = value!;
                                                  },
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: TextFormField(
                                                  readOnly: userType == "1"
                                                      ? false
                                                      : true,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 20),
                                                  ),
                                                  initialValue:
                                                      data['pabricSub1'],
                                                  textAlign: TextAlign.center,
                                                  onSaved: (value) {
                                                    _pabricSub1 = value!;
                                                  },
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: TextFormField(
                                                  readOnly: userType == "1"
                                                      ? false
                                                      : true,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 20),
                                                  ),
                                                  initialValue:
                                                      data['pabricSub2'],
                                                  textAlign: TextAlign.center,
                                                  onSaved: (value) {
                                                    _pabricSub2 = value!;
                                                  },
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: TextFormField(
                                                  readOnly: userType == "1"
                                                      ? false
                                                      : true,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 20),
                                                  ),
                                                  initialValue: data['lining'],
                                                  textAlign: TextAlign.center,
                                                  onSaved: (value) {
                                                    _lining = value!;
                                                  },
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: TextFormField(
                                                  readOnly: userType == "1"
                                                      ? false
                                                      : true,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 20),
                                                  ),
                                                  initialValue: data['buttons'],
                                                  textAlign: TextAlign.center,
                                                  onSaved: (value) {
                                                    _buttons = value!;
                                                  },
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '제품 디자인 및 신체 사이즈',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: TabBar(
                                          indicatorColor: HexColor('#172543'),
                                          indicatorWeight: 3.0,
                                          controller: _tabController,
                                          tabs: _tabList
                                              .map((tabName) =>
                                                  Tab(child: Text(tabName)))
                                              .toList(),
                                        ),
                                      ),
                                      Container(
                                        height: GetPlatform.isMobile
                                            ? 1300
                                            : Get.width < 600
                                                ? 1300
                                                : 900,
                                        child: TabBarView(
                                          controller: _tabController,
                                          children: orderType == '2'
                                              ? getShirt()
                                              : orderType == '0' &&
                                                      includeVest == false
                                                  ? getList()
                                                  : getListSuit(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              userType != "2"
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 30, 20, 10),
                                      child: Column(
                                        children: [
                                          Container(
                                            //로그아웃 버튼
                                            width: 300,

                                            child: ElevatedButton(
                                              style: TextButton.styleFrom(
                                                primary: Colors.white, //글자색
                                                onSurface: Colors
                                                    .white, //onpressed가 null일때 색상
                                                backgroundColor:
                                                    HexColor('#172543'),
                                                shadowColor:
                                                    Colors.white, //그림자 색상
                                                elevation: 1, // 버튼 입체감
                                                textStyle:
                                                    TextStyle(fontSize: 16),
                                                //padding: EdgeInsets.all(16.0),
                                                minimumSize:
                                                    Size(300, 50), //최소 사이즈
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
                                                  builder: (context) =>
                                                      MessagePopup(
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
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: Column(
                                  children: [
                                    Container(
                                      //로그아웃 버튼
                                      width: 300,

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

  List<Widget> getShirt() {
    List<Widget> childs = [
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/shirtImg.png',
                width: 280,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '디자인',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                alignment: WrapAlignment.center,
                children: List.generate(shirtStep.length, (index) {
                  //item 의 반목문 항목 형성

                  return Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: 340,
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          child: Text(
                            shirtStep[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 210,
                          height: 20,
                          child: TextFormField(
                            readOnly: userType == "1" ? false : true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 20),
                            ),
                            initialValue: shirtList[index],
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                shirtList[index] = value;
                                selectedShirtOption[shirtStep[index]] = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                try {
                                  selectedShirtOption[shirtStep[index]] =
                                      value!;
                                } catch (e) {
                                  print(e);
                                }
                              });
                              print('shirt:' +
                                  selectedShirtOption[shirtStep[index]]);

                              //shirtList[index] = value!;
                            },
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '채촌정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                alignment: WrapAlignment.start,
                children: List.generate(shirtSizeList.length, (index) {
                  //item 의 반목문 항목 형성

                  return Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: 340,
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          child: Text(
                            shirtSizeList[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 210,
                          height: 20,
                          child: TextFormField(
                            readOnly: userType == "1" ? false : true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 20),
                            ),
                            initialValue:

                                //  data['topSize']
                                //     [topSizeDataList[index]]
                                updateShirtSize[index],
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                try {
                                  updateShirtSize[index] = value;
                                } catch (e) {}
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                updateShirtSize[index] = value!;
                              });
                              print('shirt:' + updateShirtSize[index]);
                            },
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    ];

    List<Widget> returnChild = [];

    returnChild = childs;

    return returnChild;
  }

  List<Widget> getList() {
    List<Widget> childs = [
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/sizeImg1.png',
                width: 280,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '디자인',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                alignment: WrapAlignment.center,
                children: List.generate(jacketStep.length, (index) {
                  //item 의 반목문 항목 형성

                  return Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: 340,
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          child: Text(
                            jacketStep[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 210,
                          height: 20,
                          child: TextFormField(
                            readOnly: userType == "1" ? false : true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 20),
                            ),
                            initialValue: jacketList[index],
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                jacketList[index] = value;
                                selectedJacketOption[jacketStep[index]] = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                try {
                                  selectedJacketOption[jacketStep[index]] =
                                      value!;
                                } catch (e) {
                                  print(e);
                                }
                              });
                              print('jacket:' +
                                  selectedJacketOption[jacketStep[index]]);

                              //jacketList[index] = value!;
                            },
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '채촌정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                alignment: WrapAlignment.start,
                children: List.generate(topSizeList.length, (index) {
                  //item 의 반목문 항목 형성

                  return Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: 340,
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          child: Text(
                            topSizeList[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 210,
                          height: 20,
                          child: TextFormField(
                            readOnly: userType == "1" ? false : true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 20),
                            ),
                            initialValue:

                                //  data['topSize']
                                //     [topSizeDataList[index]]
                                updateTopSize[index],
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                try {
                                  updateTopSize[index] = value;
                                } catch (e) {}
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                updateTopSize[index] = value!;
                              });
                              print('jacket:' + updateTopSize[index]);
                            },
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/sizeImg2.png',
                width: 280,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '디자인',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                alignment: WrapAlignment.start,
                children: List.generate(pantsStep.length, (index) {
                  //item 의 반목문 항목 형성

                  return Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: 340,
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          child: Text(
                            pantsStep[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 210,
                          height: 20,
                          child: TextFormField(
                            readOnly: userType == "1" ? false : true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 20),
                            ),
                            initialValue: pantsList[index],
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                pantsList[index] = value;
                                selectedPantsOption[jacketStep[index]] = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                try {
                                  selectedPantsOption[pantsStep[index]] =
                                      value!;
                                } catch (e) {
                                  print(e);
                                }
                              });
                              print('pants:' +
                                  selectedPantsOption[pantsStep[index]]);
                            },
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '채촌정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                alignment: WrapAlignment.start,
                children: List.generate(bottomSizeList.length, (index) {
                  //item 의 반목문 항목 형성

                  return Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: 340,
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          child: Text(
                            bottomSizeList[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 210,
                          height: 20,
                          child: TextFormField(
                            readOnly: userType == "1" ? false : true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 20),
                            ),
                            initialValue: updateBottomSize[index],
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                updateBottomSize[index] = value;
                              });
                            },
                            onSaved: (value2) {
                              setState(() {
                                updateBottomSize[index] = value2!;
                              });
                              print('pants:' + updateBottomSize[index]);
                            },
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    ];

    return childs;
  }

  addOption(Map selectedOption, String key, String val) {
    setState(() {
      selectedOption[key] = val;
    });
  }

  addsize(List list, int index, String size) {
    setState(() {
      list[index] = size;
    });
  }

  List<Widget> getListSuit() {
    List<Widget> childs = [
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/sizeImg1.png',
                width: 280,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '디자인',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                alignment: WrapAlignment.center,
                children: List.generate(jacketStep.length, (index) {
                  //item 의 반목문 항목 형성

                  return Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: 340,
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          child: Text(
                            jacketStep[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 210,
                          height: 20,
                          child: TextFormField(
                            readOnly: userType == "1" ? false : true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 20),
                            ),
                            initialValue: jacketList[index],
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                jacketList[index] = value;
                                selectedJacketOption[jacketStep[index]] = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                selectedJacketOption[jacketStep[index]] =
                                    value!;
                              });

                              //jacketList[index] = value!;
                            },
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '채촌정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                alignment: WrapAlignment.start,
                children: List.generate(topSizeList.length, (index) {
                  //item 의 반목문 항목 형성

                  return Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: 340,
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          child: Text(
                            topSizeList[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 210,
                          height: 20,
                          child: TextFormField(
                            readOnly: userType == "1" ? false : true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 20),
                            ),
                            initialValue: data['topSize']
                                [topSizeDataList[index]],
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                try {
                                  updateTopSize[index] = value;
                                } catch (e) {}
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                updateTopSize[index] = value!;
                              });
                            },
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/sizeImg3.png',
                width: 280,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '디자인',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                alignment: WrapAlignment.start,
                children: List.generate(vestStep.length, (index) {
                  //item 의 반목문 항목 형성

                  return Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: 340,
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          child: Text(
                            vestStep[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 210,
                          height: 20,
                          child: TextFormField(
                            readOnly: userType == "1" ? false : true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 20),
                            ),
                            initialValue: vestList[index],
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                vestList[index] = value;
                                selectedVestOption[vestStep[index]] = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                selectedVestOption[vestStep[index]] = value!;
                              });

                              //vestList[index] = value!;
                            },
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '채촌정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                alignment: WrapAlignment.start,
                children: List.generate(vestSizeList.length, (index) {
                  //item 의 반목문 항목 형성

                  return Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: 340,
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          child: Text(
                            vestSizeList[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 210,
                          height: 20,
                          child: TextFormField(
                            readOnly: userType == "1" ? false : true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 20),
                            ),
                            initialValue: data['vestSize']
                                [vestSizeDataList[index]],
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                try {
                                  updateVestSize[index] = value;
                                } catch (e) {}
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                updateVestSize[index] = value!;
                              });
                            },
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/sizeImg2.png',
                width: 280,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '디자인',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                alignment: WrapAlignment.start,
                children: List.generate(pantsStep.length, (index) {
                  //item 의 반목문 항목 형성

                  return Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: 340,
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          child: Text(
                            pantsStep[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 210,
                          height: 20,
                          child: TextFormField(
                            readOnly: userType == "1" ? false : true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 20),
                            ),
                            initialValue: pantsList[index],
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                vestList[index] = value;
                                selectedPantsOption[jacketStep[index]] = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                selectedPantsOption[pantsStep[index]] = value!;
                              });
                            },
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '채촌정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                alignment: WrapAlignment.start,
                children: List.generate(bottomSizeList.length, (index) {
                  //item 의 반목문 항목 형성

                  return Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: 340,
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 100,
                          child: Text(
                            bottomSizeList[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 210,
                          height: 20,
                          child: TextFormField(
                            readOnly: userType == "1" ? false : true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 20),
                            ),
                            initialValue: data['bottomSize']
                                [bottomSizeDataList[index]],
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                try {
                                  updateBottomSize[index] = value;
                                } catch (e) {}
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                updateBottomSize[index] = value!;
                              });
                            },
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    ];

    List<Widget> returnChild = [];
    if (orderType == '1') {
      returnChild = childs.sublist(0, 1);
    } else if (orderType == '3') {
      returnChild = childs.sublist(2, 3);
    } else if (orderType == '4') {
      returnChild = childs.sublist(1, 2);
    } else {
      returnChild = childs;
    }
    return returnChild;
  }

  void createPdf2(String orderType) async {
    print('aaaa');
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

    print(vestList.toString());
    (orderType == '0' || orderType == '4')
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
                                  child: pw.Column(
                                    children: [
                                      pw.Container(height: 15),
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
                                                            data['vestSize'][vestSizeDataList[
                                                                            i]] ==
                                                                        "" ||
                                                                    data['vestSize']
                                                                            [
                                                                            vestSizeDataList[
                                                                                i]] ==
                                                                        null
                                                                ? '   '
                                                                : data['vestSize']
                                                                    [
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
                                      pw.Column(
                                        children: [
                                          pw.Container(
                                            alignment: pw.Alignment.topCenter,
                                            padding:
                                                pw.EdgeInsets.only(top: 10),
                                            child: pw.Image(sizeImage3,
                                                height: 140),
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
                                                    i < vestStep.length;
                                                    i++)
                                                  pw.Container(
                                                    padding:
                                                        pw.EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    height: 25,
                                                    child: pw.Text(
                                                        vestStep[i] +
                                                            "   " +
                                                            vestList[i],
                                                        style: pw.TextStyle(
                                                            font: ttf,
                                                            fontSize: 12)),
                                                  ),
                                              ],
                                            ),
                                          ),
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
