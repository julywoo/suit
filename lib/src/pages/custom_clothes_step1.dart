import 'dart:io';

import 'package:bykak/src/components/alert_fucntion.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/model/order_model.dart';
// import 'package:bykak/src/pages/shirt_design_choice.dart';
import 'package:bykak/src/pages/tailorShop/design_choice.dart';
import 'package:bykak/src/pages/tailorShop/pants_design_choice.dart';
import 'package:bykak/src/pages/tailorShop/vest_design_choice.dart';
import 'package:bykak/src/pages/tailorShop/shirt_design_choice.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance.currentUser;

class CustomClothesStep1 extends StatefulWidget {
  CustomClothesStep1({Key? key}) : super(key: key);

  @override
  State<CustomClothesStep1> createState() => _CustomClothesStep1State();
}

class _CustomClothesStep1State extends State<CustomClothesStep1>
    with TickerProviderStateMixin {
  TextEditingController pabric = TextEditingController();
  TextEditingController pabricSub1 = TextEditingController();
  TextEditingController pabricSub2 = TextEditingController();
  TextEditingController buttons = TextEditingController();
  TextEditingController lining = TextEditingController();

  //String orderType = Get.arguments['orderType'];
  Order orderData = Get.arguments['orderData'];
  //List orderNoList = Get.arguments['orderNoList'];
  List<String> list = ['수트', '자켓', '셔츠', '바지', '조끼', '코트'];
  List<String> list1 = ['단일원단', '복수원단'];
  List<String> pabricPattern = ['무지', '체크', '스트라이프'];
  List<String> pabricColor = [
    '검정색',
    '남색',
    '회색',
    '갈색',
    '흰색',
    '베이지색',
    '초록',
    '빨간색'
  ];
  int _selectedIndex = 0;
  int _selectedIndex1 = 0;

  bool buttonenabled = true;

  bool kisweb = true;

  String storeName = "";
  String userName = "";
  String bykakCnt = "";
  String totalCnt = "";
  DateTime now = DateTime.now();
  String orderNo = "";

  getData(_selectedIndex) async {
    try {
      var userResult =
          await firestore.collection('users').doc(auth!.email.toString()).get();

      setState(() {
        storeName = userResult['storeName'];
        userName = userResult['userName'];
      });

      if ((storeName.contains("바이각") && _selectedIndex == 0) ||
          (storeName.contains("바이각") && _selectedIndex == 1)) {
        var cntResult =
            await firestore.collection('orderCnt').doc('bykak').get();
        setState(() {
          bykakCnt = cntResult['orderCount'].toString();
        });
        orderNo = '${DateFormat('yyMMddHHmmss').format(now)}_$bykakCnt';
      } else {
        var cntResult =
            await firestore.collection('orderCnt').doc('totalCount').get();
        if (cntResult['orderCount'] == 100) {
          firestore
              .collection('orderCnt')
              .doc('totalCount')
              .update({'orderCount': 0});
        }
        setState(() {
          totalCnt = cntResult['orderCount'].toString();
        });
        totalCnt = totalCnt.toString().padLeft(2, '0');
        orderNo = '${DateFormat('yyMMddHHmmss').format(now)}_$totalCnt';
      }
    } catch (e) {}
  }

  int addCnt = 0;
  countAdd(_selectedIndex) {
    if (_selectedIndex == 0 || _selectedIndex == 1) {
      addCnt = int.parse(bykakCnt) + 1;

      firestore
          .collection('orderCnt')
          .doc('bykak')
          .update({'orderCount': addCnt});
    } else {
      addCnt = 0;
      int.parse(totalCnt) < 100 ? addCnt = int.parse(totalCnt) + 1 : addCnt = 0;

      try {
        firestore
            .collection('orderCnt')
            .doc('totalCount')
            .update({'orderCount': addCnt});
      } catch (e) {}
    }
  }

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

    checkPlatform();
    getData(_selectedIndex);
    _getStoreList();
    super.initState();
  }

  List<String> pabricFactoryList = [];
  List<String> pabricSub1FactoryList = [];
  List<String> pabricSub2FactoryList = [];
  String _selectedPabricFactory = "";
  String _selectedPabricSub1Factory = "";
  String _selectedPabricSub2Factory = "";
  String _selectedPabricBrand = "";
  String _selectedPabricSub1Brand = "";
  String _selectedPabricSub2Brand = "";
  _getStoreList() async {
    pabricFactoryList = [];
    pabricSub1FactoryList = [];
    pabricSub2FactoryList = [];
    var pabricReturn = await FirebaseFirestore.instance
        .collection('pabricList')
        //.where('pabricName', isNull: false)
        .get();
    //storeList.remove("");
    for (var doc in pabricReturn.docs) {
      if (doc['pabricName'] != null) {
        // for (var i = 0; i < storeList.length; i++) {
        if (pabricFactoryList.contains(doc['pabricName'])) {
        } else {
          setState(() {
            pabricFactoryList.add(doc['pabricName']);
          });
        }
        if (pabricSub1FactoryList.contains(doc['pabricName'])) {
        } else {
          setState(() {
            pabricSub1FactoryList.add(doc['pabricName']);
          });
        }
        if (pabricSub2FactoryList.contains(doc['pabricName'])) {
        } else {
          setState(() {
            pabricSub2FactoryList.add(doc['pabricName']);
          });
        }
      }
    }
    _selectedPabricFactory = pabricFactoryList[0];
    getPabricBrand(_selectedPabricFactory);

    _selectedPabricSub1Factory = pabricSub1FactoryList[0];
    getPabricBrand1(_selectedPabricSub1Factory);

    _selectedPabricSub2Factory = pabricSub2FactoryList[0];
    getPabricBrand2(_selectedPabricSub2Factory);
  }

  bool _isLoading = true;
  List<String> pabricBrandList = [];
  List<String> pabricSub1BrandList = [];
  List<String> pabricSub2BrandList = [];

  getPabricBrand(String shopName) async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });

    pabricBrandList = [];

    var doc;
    var brandListResult =
        await firestore.collection('pabricList').doc(shopName).get();
    for (var item in brandListResult['pabricList']) {
      pabricBrandList.add(item);
      _selectedPabricBrand = pabricBrandList[0];
    }
  }

  getPabricBrand1(String shopName) async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });

    pabricSub1BrandList = [];

    var doc;
    var brandListResult =
        await firestore.collection('pabricList').doc(shopName).get();
    for (var item in brandListResult['pabricList']) {
      pabricSub1BrandList.add(item);
      _selectedPabricSub1Brand = pabricSub1BrandList[0];
    }
  }

  getPabricBrand2(String shopName) async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });

    pabricSub2BrandList = [];

    var doc;
    var brandListResult =
        await firestore.collection('pabricList').doc(shopName).get();
    for (var item in brandListResult['pabricList']) {
      pabricSub2BrandList.add(item);
      _selectedPabricSub2Brand = pabricSub2BrandList[0];
    }
  }

  @override
  void dispose() {
    // 세로 화면 고정
    _tabController.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
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

  String phoneNumber(String val) {
    String returnVal = val.replaceAllMapped(RegExp(r'(\d{3})(\d{3,4})(\d+)'),
        (Match m) => "${m[1]}-${m[2]}-${m[3]}");

    return returnVal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black),
          ),
        ),
        elevation: 2,
        title: Text(
          '제품 및 원단선택',
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
          : SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Container(
                    width: 480,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              _inputForm(),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                  width: kisweb
                                      ? MediaQuery.of(context).size.width * 0.8
                                      : MediaQuery.of(context).size.width * 0.8,
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

                                    onPressed: buttonenabled
                                        ? () {
                                            sendModel();
                                          }
                                        : null,
                                    child: const Text('디자인 선택'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  //Order? orderData;

  // void loginFailAlert() {
  void sendModel() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    String finishDate =
        DateFormat('yyyy-MM-dd').format(now.add(Duration(days: 30)));
    String gabongDate =
        DateFormat('yyyy-MM-dd').format(now.add(Duration(days: 10)));
    String pabricData = "";
    String pabricSub1Data = "";
    String pabricSub2Data = "";
    if (_shirtSelect) {
      pabricData = _selectedPabricBrand +
          '_' +
          pabric.text +
          '(' +
          _selectedPabricFactory +
          ') ' +
          pabricPattern[_selectedPattern] +
          ' ' +
          pabricColor[_selectedColor];

      if (_selectedIndex1 == 1) {
        if (pabricSub1.text != '' || pabricSub1.text != null) {
          pabricSub1Data = _selectedPabricSub1Brand +
              '_' +
              pabricSub1.text +
              '(' +
              _selectedPabricSub1Factory +
              ') ' +
              pabricPattern[_selectedSub1Pattern] +
              ' ' +
              pabricColor[_selectedSub1Color];
        }
        if (pabricSub2.text != '' || pabricSub2.text != null) {
          pabricSub2Data = _selectedPabricSub2Brand +
              '_' +
              pabricSub2.text +
              '(' +
              _selectedPabricSub2Factory +
              ') ' +
              pabricPattern[_selectedSub2Pattern] +
              ' ' +
              pabricColor[_selectedSub2Color];
        }
      }
    } else {
      pabricData = pabric.text;
    }
    orderData = Order(
        name: orderData.name,
        phone: orderData.phone,
        gender: orderData.gender,
        age: orderData.age,
        visitRoute: orderData.visitRoute,
        productionProcess: 0,
        consultDate: formattedDate,
        finishDate: finishDate,
        gabong: gabongDate,
        productUse: orderData.productUse,
        pabric: pabricData.toString(),
        pabricSub1: pabricSub1Data.toString(),
        pabricSub2: pabricSub2Data.toString(),
        orderNo: orderNo,
        orderType: _selectedIndex.toString(),
        buttons: buttons.text,
        lining: lining.text,
        storeName: storeName,
        makerName: userName);
    print(_selectedIndex);
    // if (_selectedIndex == 1) {
    //   countAdd(_selectedIndex);
    //   Get.to(const SuitDesignChoice(), arguments: {
    //     'orderData': orderData,
    //     'orderNo': orderNo,
    //     'orderType': _selectedIndex,
    //     // 'orderNoList': orderNoList
    //   });
    // } else

    if (_selectedIndex == 0 || _selectedIndex == 1) {
      countAdd(_selectedIndex);
      Get.to(const DesignChoice(), arguments: {
        'orderData': orderData,
        'orderNo': orderNo,
        'orderType': _selectedIndex
      });
    } else if (_selectedIndex == 4) {
      //조끼
      countAdd(_selectedIndex);
      Get.to(const VestDesignChoice(), arguments: {
        'orderData': orderData,
        'orderNo': orderNo,
        'orderType': _selectedIndex
      });
    } else if (_selectedIndex == 3) {
      //바지
      countAdd(_selectedIndex);
      Get.to(const PantsDesignChoice(), arguments: {
        'orderData': orderData,
        'orderNo': orderNo,
        'orderType': _selectedIndex
      });
    } else if (_selectedIndex == 2) {
      //셔츠
      countAdd(_selectedIndex);
      Get.to(ShirtDesignChoice(), arguments: {
        'orderData': orderData,
        'orderNo': orderNo,
        'orderType': _selectedIndex
      });
    } else {
      //코트
      countAdd(_selectedIndex);
      Get.to(const VestDesignChoice(), arguments: {
        'orderData': orderData,
        'orderNo': orderNo,
        'orderType': _selectedIndex
      });
    }
  }

  Widget _inputForm() {
    var widthVal = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                '제품',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customRadio(list[0], 0),
                      customRadio(list[1], 1)
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customRadio(list[2], 2),
                      customRadio(list[3], 3)
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customRadio(list[4], 4),
                      customRadio(list[5], 5)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                '원단',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customRadio1(
                          list1[0], 0, "원단", _selectedIndex1, list1.length, ""),
                      customRadio1(
                          list1[1], 1, "원단", _selectedIndex1, list1.length, "")
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),

            _selectedIndex1 == 0
                ? _shirtSelect
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              '원단공장',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 60,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: HexColor('#172543')),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#172543')),
                                ),
                                filled: true,
                              ),
                              hint: Text(
                                '업체를 선택하세요',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              value: _selectedPabricFactory,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: pabricFactoryList.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text(items)),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedPabricFactory = newValue!;
                                  _isLoading = true;
                                });
                                getPabricBrand(_selectedPabricFactory);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              '원단브랜드',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 60,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: HexColor('#172543')),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#172543')),
                                ),
                                filled: true,
                              ),
                              hint: Text(
                                '원단브랜드를 선택하세요',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              //value: storeInitVal,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: pabricBrandList.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text(items)),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedPabricBrand = newValue!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              '원단패턴',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    customRadio1(
                                        pabricPattern[0],
                                        0,
                                        "패턴",
                                        _selectedPattern,
                                        pabricPattern.length,
                                        ""),
                                    customRadio1(
                                        pabricPattern[1],
                                        1,
                                        "패턴",
                                        _selectedPattern,
                                        pabricPattern.length,
                                        ""),
                                    customRadio1(
                                        pabricPattern[2],
                                        2,
                                        "패턴",
                                        _selectedPattern,
                                        pabricPattern.length,
                                        "")
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              '원단명',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          CustomTextFormField(
                            lines: 1,
                            hint: "",
                            controller: pabric,
                          ),
                          Container(
                            child: Text(
                              '원단색상계열',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              width: MediaQuery.of(context).size.width * 0.8,
                              // child: Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              child: Wrap(
                                children: [
                                  customChangeColor(Colors.black, 0, ""),
                                  customChangeColor(HexColor('000080'), 1, ""),
                                  customChangeColor(HexColor('005950'), 2, ""),
                                  customChangeColor(HexColor('760C0C'), 3, ""),
                                  customChangeColor(Colors.grey, 4, ""),
                                  customChangeColor(Colors.brown, 5, ""),
                                  customChangeColor(Colors.white, 6, ""),
                                  customChangeColor(HexColor('EEE6C4'), 7, ""),
                                ],
                              )
                              // ),
                              ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              '원단명',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          CustomTextFormField(
                            lines: 1,
                            hint: "",
                            controller: pabric,
                          ),
                          _shirtSelect
                              ? Container(
                                  child: Text(
                                    '원단색상계열',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                )
                              : Container(),
                          _shirtSelect
                              ? Container(
                                  padding: EdgeInsets.only(top: 20, bottom: 20),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  // child: Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  child: Wrap(
                                    children: [
                                      customChangeColor2(Colors.black, 0, '바지'),
                                      customChangeColor2(
                                          HexColor('000080'), 1, '바지'),
                                      customChangeColor2(
                                          HexColor('005950'), 2, '바지'),
                                      customChangeColor2(
                                          HexColor('760C0C'), 3, '바지'),
                                      customChangeColor2(Colors.grey, 4, '바지'),
                                      customChangeColor2(Colors.brown, 5, '바지'),
                                      customChangeColor2(Colors.white, 6, '바지'),
                                      customChangeColor2(
                                          HexColor('EEE6C4'), 7, '바지'),
                                    ],
                                  )
                                  // ),
                                  )
                              : Container(),
                        ],
                      )
                : Column(
                    children: [
                      TabBar(
                        indicatorColor: HexColor('#172543'),
                        indicatorWeight: 3.0,
                        controller: _tabController,
                        tabs: const <Widget>[
                          Tab(
                            text: '상의',
                          ),
                          Tab(
                            text: '조끼',
                          ),
                          Tab(
                            text: '바지',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 600,
                        child: TabBarView(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    '원단공장',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 60,
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: HexColor('#172543')),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: HexColor('#172543')),
                                      ),
                                      filled: true,
                                    ),
                                    hint: Text(
                                      '업체를 선택하세요',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    value: _selectedPabricFactory,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items:
                                        pabricFactoryList.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(items)),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedPabricFactory = newValue!;
                                        _isLoading = true;
                                      });
                                      getPabricBrand(_selectedPabricFactory);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    '원단브랜드',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 60,
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: HexColor('#172543')),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: HexColor('#172543')),
                                      ),
                                      filled: true,
                                    ),
                                    hint: Text(
                                      '원단브랜드를 선택하세요',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    value: _selectedPabricBrand,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: pabricBrandList.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(items)),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedPabricBrand = newValue!;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    '원단패턴',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          customRadio1(
                                              pabricPattern[0],
                                              0,
                                              "패턴",
                                              _selectedPattern,
                                              pabricPattern.length,
                                              ""),
                                          customRadio1(
                                              pabricPattern[1],
                                              1,
                                              "패턴",
                                              _selectedPattern,
                                              pabricPattern.length,
                                              ""),
                                          customRadio1(
                                              pabricPattern[2],
                                              2,
                                              "패턴",
                                              _selectedPattern,
                                              pabricPattern.length,
                                              "")
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    '원단명',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                CustomTextFormField(
                                  lines: 1,
                                  hint: "",
                                  controller: pabric,
                                ),
                                Container(
                                  child: Text(
                                    '원단색상계열',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    // child: Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    child: Wrap(
                                      children: [
                                        customChangeColor(Colors.black, 0, ""),
                                        customChangeColor(
                                            HexColor('000080'), 1, ""),
                                        customChangeColor(
                                            HexColor('005950'), 2, ""),
                                        customChangeColor(
                                            HexColor('760C0C'), 3, ""),
                                        customChangeColor(Colors.grey, 4, ""),
                                        customChangeColor(Colors.brown, 5, ""),
                                        customChangeColor(Colors.white, 6, ""),
                                        customChangeColor(
                                            HexColor('EEE6C4'), 7, ""),
                                      ],
                                    )
                                    // ),
                                    ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    '원단공장',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 60,
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: HexColor('#172543')),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: HexColor('#172543')),
                                      ),
                                      filled: true,
                                    ),
                                    hint: Text(
                                      '업체를 선택하세요',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    value: _selectedPabricSub1Factory,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: pabricSub1FactoryList
                                        .map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(items)),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedPabricSub1Factory = newValue!;
                                        _isLoading = true;
                                      });
                                      getPabricBrand1(
                                          _selectedPabricSub1Factory);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    '원단브랜드',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 60,
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: HexColor('#172543')),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: HexColor('#172543')),
                                      ),
                                      filled: true,
                                    ),
                                    hint: Text(
                                      '원단브랜드를 선택하세요',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    value: _selectedPabricSub1Brand,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items:
                                        pabricSub1BrandList.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(items)),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedPabricSub1Brand = newValue!;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    '원단패턴',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          customRadio1(
                                              pabricPattern[0],
                                              0,
                                              "패턴",
                                              _selectedSub1Pattern,
                                              pabricPattern.length,
                                              "조끼"),
                                          customRadio1(
                                              pabricPattern[1],
                                              1,
                                              "패턴",
                                              _selectedSub1Pattern,
                                              pabricPattern.length,
                                              "조끼"),
                                          customRadio1(
                                              pabricPattern[2],
                                              2,
                                              "패턴",
                                              _selectedSub1Pattern,
                                              pabricPattern.length,
                                              "조끼")
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    '조끼원단',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                CustomTextFormField(
                                  lines: 1,
                                  hint: "",
                                  controller: pabricSub1,
                                ),
                                Container(
                                  child: Text(
                                    '원단색상계열',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    // child: Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    child: Wrap(
                                      children: [
                                        customChangeColor1(
                                            Colors.black, 0, "조끼"),
                                        customChangeColor1(
                                            HexColor('000080'), 1, "조끼"),
                                        customChangeColor1(
                                            HexColor('005950'), 2, "조끼"),
                                        customChangeColor1(
                                            HexColor('760C0C'), 3, "조끼"),
                                        customChangeColor1(
                                            Colors.grey, 4, "조끼"),
                                        customChangeColor1(
                                            Colors.brown, 5, "조끼"),
                                        customChangeColor1(
                                            Colors.white, 6, "조끼"),
                                        customChangeColor1(
                                            HexColor('EEE6C4'), 7, "조끼"),
                                      ],
                                    )
                                    // ),
                                    ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    '원단공장',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 60,
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: HexColor('#172543')),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: HexColor('#172543')),
                                      ),
                                      filled: true,
                                    ),
                                    hint: Text(
                                      '업체를 선택하세요',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    value: _selectedPabricSub2Factory,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: pabricSub2FactoryList
                                        .map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(items)),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedPabricSub2Factory = newValue!;
                                        _isLoading = true;
                                      });
                                      getPabricBrand(
                                          _selectedPabricSub2Factory);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    '원단브랜드',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 60,
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: HexColor('#172543')),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: HexColor('#172543')),
                                      ),
                                      filled: true,
                                    ),
                                    hint: Text(
                                      '원단브랜드를 선택하세요',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    value: _selectedPabricSub2Brand,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: pabricBrandList.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(items)),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedPabricSub2Brand = newValue!;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    '원단패턴',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          customRadio1(
                                              pabricPattern[0],
                                              0,
                                              "패턴",
                                              _selectedSub2Pattern,
                                              pabricPattern.length,
                                              '바지'),
                                          customRadio1(
                                              pabricPattern[1],
                                              1,
                                              "패턴",
                                              _selectedSub2Pattern,
                                              pabricPattern.length,
                                              '바지'),
                                          customRadio1(
                                              pabricPattern[2],
                                              2,
                                              "패턴",
                                              _selectedSub2Pattern,
                                              pabricPattern.length,
                                              '바지')
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    '바지원단',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                CustomTextFormField(
                                  lines: 1,
                                  hint: "",
                                  controller: pabricSub2,
                                ),
                                Container(
                                  child: Text(
                                    '원단색상계열',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    // child: Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    child: Wrap(
                                      children: [
                                        customChangeColor2(
                                            Colors.black, 0, '바지'),
                                        customChangeColor2(
                                            HexColor('000080'), 1, '바지'),
                                        customChangeColor2(
                                            HexColor('005950'), 2, '바지'),
                                        customChangeColor2(
                                            HexColor('760C0C'), 3, '바지'),
                                        customChangeColor2(
                                            Colors.grey, 4, '바지'),
                                        customChangeColor2(
                                            Colors.brown, 5, '바지'),
                                        customChangeColor2(
                                            Colors.white, 6, '바지'),
                                        customChangeColor2(
                                            HexColor('EEE6C4'), 7, '바지'),
                                      ],
                                    )
                                    // ),
                                    ),
                              ],
                            ),
                          ],
                          controller: _tabController,
                        ),
                      ),
                    ],
                  ),

            // _selectedIndex1 == 0
            //     ? Container()
            //     : Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.only(top: 10, bottom: 10),
            //             child: Divider(
            //               height: 1.5,
            //               color: Colors.black26,
            //               thickness: 3,
            //             ),
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.only(top: 10, bottom: 10),
            //             child: Divider(
            //               height: 1.5,
            //               color: Colors.black26,
            //               thickness: 3,
            //             ),
            //           ),
            //         ],
            //       ),
            _shirtSelect
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          '안감 (선택)',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                      CustomTextFormField(
                        lines: 1,
                        hint: "",
                        controller: lining,
                      ),
                    ],
                  )
                : Container(),
            Container(
              child: Text(
                '단추 (선택)',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            CustomTextFormField(
              lines: 1,
              hint: "",
              controller: buttons,
            ),
          ],
        )),
      ),
    );
  }

  void loginFailAlert() {
    Fluttertoast.showToast(
        webBgColor: "linear-gradient(to right, #F44336, #F44336)",
        webPosition: "center",
        msg: "코트 상담 기능은 개발중입니다.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffF44336),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  bool _shirtSelect = true;
  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedIndex1 = 0;
      getData(_selectedIndex);
    });

    if (_selectedIndex == 2) {
      setState(() {
        _selectedIndex1 = 0;
        _shirtSelect = false;
      });
    } else {
      setState(() {
        _selectedIndex1 = 0;
        _shirtSelect = true;
      });
    }

    if (_selectedIndex == 5) {
      setState(() {
        _selectedIndex1 = 0;
        buttonenabled = false;
      });

      loginFailAlert();
    } else {
      setState(() {
        _selectedIndex1 = 0;
        buttonenabled = true;
      });
    }
  }

  Widget customRadio(String text, int index) {
    var widVal = MediaQuery.of(context).size.width;

    return OutlinedButton(
      onPressed: () {
        changeIndex(index);
      },
      child: Text(text,
          style: TextStyle(
              color: _selectedIndex == index
                  ? HexColor('#FFFFFF')
                  : Colors.black87)),
      style: OutlinedButton.styleFrom(
        backgroundColor:
            _selectedIndex == index ? HexColor('#172543') : Colors.transparent,
        //minimumSize: Size(Get.width * 0.45, 50), //최소 사이즈
        minimumSize:
            widVal < 481 ? Size(Get.width * 0.35, 40) : Size(200, 40), //최소 사이즈
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        side: BorderSide(
            width: _selectedIndex == index ? 3 : 1,
            color:
                _selectedIndex == index ? HexColor('#172543') : Colors.black87),
      ),
    );
  }

  void changeIndex1(int index) {
    setState(
      () {
        _selectedIndex1 = index;
      },
    );
    if (_selectedIndex != 0 && _selectedIndex1 == 1) {
      setState(() {
        buttonenabled = false;
      });
      setState(
        () {
          _selectedIndex1 = 0;
        },
      );
      //
      failAlert('수트 제품 이외에는 복수원단을 선택할 수 없습니다.');
    } else {
      setState(
        () {
          _selectedIndex1 = index;
        },
      );
    }
  }

  int _selectedPattern = 0;
  int _selectedSub1Pattern = 0;
  int _selectedSub2Pattern = 0;

  void changePattern(int index, String part) {
    setState(
      () {
        if (part == "조끼") {
          _selectedSub1Pattern = index;
        } else if (part == "바지") {
          _selectedSub2Pattern = index;
        } else {
          _selectedPattern = index;
        }
      },
    );
  }

  Widget customRadio1(String text, int index, String type, int select,
      int listCount, String part) {
    var widVal = MediaQuery.of(context).size.width;

    return OutlinedButton(
      onPressed: () {
        if (type == "원단") {
          changeIndex1(index);
        } else if (type == "패턴") {
          changePattern(index, part);
        } else {
          changeColor(index, part);
        }
      },
      child: Text(text,
          style: TextStyle(
              color: select == index ? HexColor('#FFFFFF') : Colors.black87)),
      style: OutlinedButton.styleFrom(
        //minimumSize: Size(Get.width * 0.45, 50), //최소 사이즈
        backgroundColor:
            select == index ? HexColor('#172543') : Colors.transparent,
        minimumSize: widVal < 481
            ? listCount == 2
                ? Size(Get.width * 0.35, 40)
                : Size(Get.width * 0.25, 40)
            : listCount == 2
                ? Size(200, 40)
                : Size(140, 40), //최소 사이즈
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        side: BorderSide(
            width: select == index ? 3 : 1,
            color: select == index ? HexColor('#172543') : Colors.black87),
      ),
    );
  }

  int _selectedColor = 0;
  int _selectedSub1Color = 0;
  int _selectedSub2Color = 0;
  void changeColor(int index, String part) {
    setState(
      () {
        if (part == "조끼") {
          _selectedSub1Color = index;
        } else if (part == "바지") {
          _selectedSub2Color = index;
        } else {
          _selectedColor = index;
        }
      },
    );
  }

  Widget customChangeColor(Color color, int index, String part) {
    var widVal = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(right: 10, bottom: 5),
      child: OutlinedButton(
        onPressed: () {
          changeColor(index, part);
        },
        child: Text(''),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          //minimumSize: Size(Get.width * 0.45, 50), //최소 사이즈
          minimumSize: widVal < 481
              ? _selectedColor == index
                  ? Size(50, 50)
                  : Size(45, 45)
              : _selectedColor == index
                  ? Size(50, 50)
                  : Size(45, 45), //최소 사이즈
          shape: CircleBorder(),
          side: BorderSide(
              width: _selectedColor == index ? 5 : 1,
              color: _selectedColor == index
                  ? HexColor('#172543')
                  : Colors.black45),
        ),
      ),
    );
  }

  Widget customChangeColor1(Color color, int index, String part) {
    var widVal = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(right: 10, bottom: 5),
      child: OutlinedButton(
        onPressed: () {
          changeColor(index, part);
        },
        child: Text(''),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          //minimumSize: Size(Get.width * 0.45, 50), //최소 사이즈
          minimumSize: widVal < 481
              ? _selectedSub1Color == index
                  ? Size(50, 50)
                  : Size(45, 45)
              : _selectedSub1Color == index
                  ? Size(50, 50)
                  : Size(45, 45), //최소 사이즈
          shape: CircleBorder(),
          side: BorderSide(
              width: _selectedSub1Color == index ? 5 : 1,
              color: _selectedSub1Color == index
                  ? HexColor('#172543')
                  : Colors.black45),
        ),
      ),
    );
  }

  Widget customChangeColor2(Color color, int index, String part) {
    var widVal = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(right: 10, bottom: 5),
      child: OutlinedButton(
        onPressed: () {
          changeColor(index, part);
        },
        child: Text(''),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          //minimumSize: Size(Get.width * 0.45, 50), //최소 사이즈
          minimumSize: widVal < 481
              ? _selectedSub2Color == index
                  ? Size(50, 50)
                  : Size(45, 45)
              : _selectedSub2Color == index
                  ? Size(50, 50)
                  : Size(45, 45), //최소 사이즈
          shape: CircleBorder(),
          side: BorderSide(
              width: _selectedSub2Color == index ? 5 : 1,
              color: _selectedSub2Color == index
                  ? HexColor('#172543')
                  : Colors.black45),
        ),
      ),
    );
  }
}
