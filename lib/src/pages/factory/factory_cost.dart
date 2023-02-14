import 'dart:math';

import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/model/factory/cost_etc_model.dart';
import 'package:bykak/src/model/factory/cost_gabong_sub_model.dart';
import 'package:bykak/src/model/factory/cost_jacket_model.dart';
import 'package:bykak/src/model/factory/cost_normal_model.dart';
import 'package:bykak/src/model/factory/cost_pants_model.dart';
import 'package:bykak/src/model/factory/cost_shirt_model.dart';
import 'package:bykak/src/model/factory/cost_vest_model.dart';
import 'package:bykak/src/widget/price_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/factory/cost_gabong_model.dart';

final _formKey = GlobalKey<FormState>();
final _formKey1 = GlobalKey<FormState>();
final firestore = FirebaseFirestore.instance;

class FactoryCost extends StatefulWidget {
  const FactoryCost({Key? key}) : super(key: key);

  @override
  State<FactoryCost> createState() => _FactoryCostState();
}

class _FactoryCostState extends State<FactoryCost> {
  @override
  void initState() {
    _getStoreList();
    getData();
    // TODO: implement initState
    super.initState();
  }

  late List<String> storeList;
  var storeInitVal = '공통공임';
  _getStoreList() async {
    storeList = [];
    var storeReturn = await FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: '1')
        .get();
    storeList = ['공통공임'];
    for (var doc in storeReturn.docs) {
      if (doc['storeName'] != null) {
        // for (var i = 0; i < storeList.length; i++) {
        if (storeList.contains(doc['storeName'])) {
        } else {
          setState(() {
            storeList.add(doc['storeName']);
          });
        }
      }
    }
  }

  User? auth = FirebaseAuth.instance.currentUser;
  String factoryName = "";
  int costCount = 0;
  getData() async {
    try {
      var userResult =
          await firestore.collection('users').doc(auth!.email.toString()).get();
      setState(() {
        factoryName = userResult['storeName'];
      });

      var costCountResult =
          await firestore.collection('orderCnt').doc('costCount').get();
      setState(() {
        costCount = costCountResult['costCount'];
      });
    } catch (e) {}
  }

  var brandListResult;
  List<String> brandList = [""];
  String brandListInit = "";
  getTailorShopBrand(String shopName) async {
    brandList = [];
    var doc;
    var brandListResult =
        await firestore.collection('tailorShop').doc(shopName).get();

    setState(() {
      if (storeInitVal == "공통공임") {
        brandListInit = "";
        brandList.add("");
      } else {
        brandListInit = brandListResult['brandRate1'];
        //brandList.add("");

        if (brandListResult['brandRate1'] != "") {
          brandList.add(brandListResult['brandRate1']);
        }
        if (brandListResult['brandRate2'] != "") {
          brandList.add(brandListResult['brandRate2']);
        }
        if (brandListResult['brandRate3'] != "") {
          brandList.add(brandListResult['brandRate3']);
        }
        if (brandListResult['brandRate4'] != "") {
          brandList.add(brandListResult['brandRate4']);
        }
        if (brandListResult['brandRate5'] != "") {
          brandList.add(brandListResult['brandRate5']);
        }
      }
    });
  }

  var costEtcList = List<int>.filled(10, 0);
  var costGabongSubList = List<int>.filled(6, 0);
  var costGabongList = List<int>.filled(6, 0);
  var costJacketList = List<int>.filled(13, 0);
  var costNormalList = List<int>.filled(6, 0);
  var costPantsList = List<int>.filled(6, 0);
  var costShirtList = List<int>.filled(14, 0);
  var costVestList = List<int>.filled(6, 0);

  final _formKey = GlobalKey<FormState>();

  String? _costListNo;
  String? _storeName;
  String? _factoryName;
  String? _registDate;
  String? _registUser;
  String? _udpateDate;
  String? _updateUser;
  String? _selectBrandRate;

  CostEtc? _costEtc;
  CostGabongSub? _costGabongSub;
  CostGabong? _costGabong;
  CostJacket? _costJacket;

  CostNormal? _costNormal;
  CostPants? _costPants;
  CostShirt? _costShirt;
  CostVest? _costVest;

  void _submitData() async {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_isValid) {
      _formKey.currentState!.save();
    }

    _costEtc = CostEtc(
      etc1: costEtcList[0],
      etc2: costEtcList[1],
      etc3: costEtcList[2],
      etc4: costEtcList[3],
      etc5: costEtcList[4],
      etc6: costEtcList[5],
      etc7: costEtcList[6],
      etc8: costEtcList[7],
      etc9: costEtcList[8],
      etc10: costEtcList[9],
    );

    _costGabong = CostGabong(
      gabong1: costGabongList[0],
      gabong2: costGabongList[1],
      gabong3: costGabongList[2],
      gabong4: costGabongList[3],
      gabong5: costGabongList[4],
      gabong6: costGabongList[5],
    );

    _costGabongSub = CostGabongSub(
      gabongSub1: costGabongSubList[0],
      gabongSub2: costGabongSubList[1],
      gabongSub3: costGabongSubList[2],
      gabongSub4: costGabongSubList[3],
      gabongSub5: costGabongSubList[4],
      gabongSub6: costGabongSubList[5],
    );

    _costJacket = CostJacket(
      jacket1: costJacketList[0],
      jacket2: costJacketList[1],
      jacket3: costJacketList[2],
      jacket4: costJacketList[3],
      jacket5: costJacketList[4],
      jacket6: costJacketList[5],
      jacket7: costJacketList[6],
      jacket8: costJacketList[7],
      jacket9: costJacketList[8],
      jacket10: costJacketList[9],
      jacket11: costJacketList[10],
      jacket12: costJacketList[11],
      jacket13: costJacketList[12],
    );

    _costNormal = CostNormal(
      normal1: costNormalList[0],
      normal2: costNormalList[1],
      normal3: costNormalList[2],
      normal4: costNormalList[3],
      normal5: costNormalList[4],
      normal6: costNormalList[5],
    );

    _costPants = CostPants(
      pants1: costPantsList[0],
      pants2: costPantsList[1],
      pants3: costPantsList[2],
      pants4: costPantsList[3],
      pants5: costPantsList[4],
      pants6: costPantsList[5],
    );

    _costShirt = CostShirt(
      shirt1: costShirtList[0],
      shirt2: costShirtList[1],
      shirt3: costShirtList[2],
      shirt4: costShirtList[3],
      shirt5: costShirtList[4],
      shirt6: costShirtList[5],
      shirt7: costShirtList[6],
      shirt8: costShirtList[7],
      shirt9: costShirtList[8],
      shirt10: costShirtList[9],
      shirt11: costShirtList[10],
      shirt12: costShirtList[11],
      shirt13: costShirtList[12],
      shirt14: costShirtList[12],
    );

    _costVest = CostVest(
      vest1: costVestList[0],
      vest2: costVestList[1],
      vest3: costVestList[2],
      vest4: costVestList[3],
      vest5: costVestList[4],
      vest6: costVestList[5],
    );
    //가격정보 있는지 확인
    var doc;
    int listNo = 0;

    // var result = await FirebaseFirestore.instance
    //     .collection('factory')
    //     .doc(factoryName)
    //     .collection('costList')
    //     .where('factoryName', isEqualTo: factoryName)
    //     .where('storeName', isEqualTo: storeInitVal)
    //     .get();

    // for (doc in result.docs) {
    //   setState(() {
    //     listNo = doc['costListNo'];
    //   });
    // }

    FirebaseFirestore.instance
        .collection('factory')
        .doc(factoryName)
        .collection('costList')
        .doc(storeInitVal + "_" + brandListInit)
        //.doc('cost_' + listNo.toString())
        .set({
      'costListNo': costCount,
      'storeName': storeInitVal,
      'factoryName': factoryName,
      'registDate': _registDate,
      'udpateDate': _udpateDate,
      'registUser': _registUser,
      'updateUser': _updateUser,
      'selectBrandRate': brandListInit,
      'costEtc': _costEtc!.toJson(),
      'costGabongSub': _costGabongSub!.toJson(),
      'costGabong': _costGabong!.toJson(),
      'costJacket': _costJacket!.toJson(),
      'costNormal': _costNormal!.toJson(),
      'costPants': _costPants!.toJson(),
      'costShirt': _costShirt!.toJson(),
      'costVest': _costVest!.toJson(),

      //'suitDesign': _suitDesign!.toJson(),
    }, SetOptions(merge: true));
    // } else {
    //   setState(() {
    //     costCount += 1;
    //   });
    //   try {
    //     FirebaseFirestore.instance
    //         .collection('factory')
    //         .doc(factoryName)
    //         .collection('costList')
    //         .doc('cost_' + costCount.toString())
    //         .set({
    //       'costListNo': costCount,
    //       'storeName': storeInitVal,
    //       'factoryName': factoryName,
    //       'registDate': _registDate,
    //       'udpateDate': _udpateDate,
    //       'registUser': _registUser,
    //       'updateUser': _updateUser,
    //       'selectBrandRate': brandListInit,
    //       'costEtc': _costEtc!.toJson(),
    //       'costGabongSub': _costGabongSub!.toJson(),
    //       'costGabong': _costGabong!.toJson(),
    //       'costJacket': _costJacket!.toJson(),
    //       'costNormal': _costNormal!.toJson(),
    //       'costPants': _costPants!.toJson(),
    //       'costShirt': _costShirt!.toJson(),
    //       'costVest': _costVest!.toJson(),

    //       //'suitDesign': _suitDesign!.toJson(),
    //     }, SetOptions(merge: true));

    //     firestore
    //         .collection('orderCnt')
    //         .doc('costCount')
    //         .update({'costCount': costCount});
    //   } catch (e) {
    //     print(e);
    //   }
    // }
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
        elevation: 0,
        title: Text(
          '공임비 관리',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: widthVal < 481 ? widthVal : 800,
            padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor('#172543')),
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
                          borderSide: BorderSide(color: HexColor('#172543')),
                        ),
                        filled: true,
                      ),
                      value: storeInitVal,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: storeList.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          storeInitVal = newValue!;
                        });
                        getTailorShopBrand(newValue.toString());
                      },
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor('#172543')),
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
                          borderSide: BorderSide(color: HexColor('#172543')),
                        ),
                        filled: true,
                      ),
                      value: brandListInit,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: brandList.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          brandListInit = newValue!;
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '기본 공임',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Container(
                          height: 10,
                        ),
                        Table(
                          columnWidths: {
                            0: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                            2: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                          },
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: Text('상하의 (자켓/바지)'),
                                ),
                                Container(
                                  height: 40,
                                  alignment: Alignment.center,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),

                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costNormalList[0] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('상의'),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costNormalList[1] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('하의'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costNormalList[2] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('조끼'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costNormalList[3] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('코트'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costNormalList[4] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('기본호기(마도매)'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costNormalList[5] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  //가봉공임
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '가봉 공임',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Container(
                          height: 10,
                        ),
                        Table(
                          columnWidths: {
                            0: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                            2: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                          },
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('상하의'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costGabongList[0] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('상의'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costGabongList[1] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('하의'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costGabongList[2] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('조끼'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costGabongList[3] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('코트'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costGabongList[4] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(),
                                Container(),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  //중가봉공임
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '중가봉 공임',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Container(
                          height: 10,
                        ),
                        Table(
                          columnWidths: {
                            0: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                            2: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                          },
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('상하의'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costGabongSubList[0] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('상의'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costGabongSubList[1] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('하의'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costGabongSubList[2] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('조끼'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      setState(() {
                                        costGabongSubList[3] =
                                            int.parse(value!);
                                      });
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('코트'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costGabongSubList[4] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(),
                                Container(),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  //상의공임
                  Container(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '상의 공임',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Container(
                          height: 10,
                        ),
                        Table(
                          columnWidths: {
                            0: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                            2: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                          },
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('더블'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costJacketList[0] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('갱애리'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costJacketList[1] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('숄카라'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costJacketList[2] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('홍아개'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costJacketList[3] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('아웃포켓'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costJacketList[4] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('보카시'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costJacketList[5] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('콩주머니'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costJacketList[6] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('긴자꾸'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costJacketList[7] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('공단애리'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costJacketList[8] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('자바라'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costJacketList[9] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('농구애리'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costJacketList[10] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('나그랑'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costJacketList[11] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('별식'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costJacketList[12] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(),
                                Container(),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  //하의공임
                  Container(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '하의 공임',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Container(
                          height: 10,
                        ),
                        Table(
                          columnWidths: {
                            0: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                            2: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                          },
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('구르카 팬츠'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costPantsList[0] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('깡바지'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costPantsList[1] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('판치에리나'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costPantsList[2] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('턱시도레일깡'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costPantsList[3] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('슬라이드버클'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costPantsList[4] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('별식'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costPantsList[5] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  //조끼공임
                  Container(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '조끼 공임',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Container(
                          height: 10,
                        ),
                        Table(
                          columnWidths: {
                            0: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                            2: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                          },
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('조끼더블'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costVestList[0] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('조끼애리'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costVestList[1] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('별식'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costVestList[2] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(),
                                Container(),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  //셔츠공임
                  Container(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '셔츠 공임',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Container(
                          height: 10,
                        ),
                        Table(
                          columnWidths: {
                            0: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                            2: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                          },
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('기본'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[0] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('원피스카라'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[1] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('자수/이니셜'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[2] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('에리/카우스'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[3] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('택배비'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[4] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('박스대자'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[5] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('PK셔츠'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[6] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('턱시도주름'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[7] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('어깨셔링'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[8] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('등셔링'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[9] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('견장'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[10] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('후다'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[11] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('긴원피스'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[12] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('허리띠'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costShirtList[13] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  //특공임
                  Container(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '특공임',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Container(
                          height: 10,
                        ),
                        Table(
                          columnWidths: {
                            0: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                            2: FixedColumnWidth(widthVal < 481
                                ? MediaQuery.of(context).size.width * 0.20
                                : 800 * 0.20),
                          },
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('순모'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costEtcList[0] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('이니셜'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costEtcList[1] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('밀라니즈홀'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costEtcList[2] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('전호시'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costEtcList[3] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('기계전호시'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costEtcList[4] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('기계호시'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costEtcList[5] = int.parse(value!);
                                    },
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('기계이중호시'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costEtcList[6] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('홍아개'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costEtcList[7] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('기계홍아개'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costEtcList[8] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Text('부자재값'),
                                ),
                                Container(
                                  alignment: Alignment.center, height: 40,

                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    initialValue: '0',
                                    textAlign: TextAlign.center,
                                    onSaved: (value) {
                                      costEtcList[9] = int.parse(value!);
                                    },
                                    //
                                  ),
                                  // child: Text(data['name']),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
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
                                        title: '데이터 변경',
                                        message: '정보를 변경 하시겠습니까?',
                                        okCallback: () {
                                          _submitData();
                                          Get.back();
                                          Get.to(const FactoryCost());
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
    );
  }
}
