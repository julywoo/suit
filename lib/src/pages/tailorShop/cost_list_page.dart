import 'dart:convert';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:bykak/src/components/alert_fucntion.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/responsive.dart';
import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/shirt_size_model.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/model/vest_size_model.dart';
import 'package:bykak/src/pages/tailorShop/cost_intro_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CostList extends StatefulWidget {
  CostList({Key? key}) : super(key: key);

  @override
  State<CostList> createState() => _CostListState();
}

class _CostListState extends State<CostList> with TickerProviderStateMixin {
  final controller1 = ScrollController();
  //final controller2 = ScrollController();

  final textController = TextEditingController();
  String _searchText = "";
  late TabController _tabController;
  var controller2;
  bool _isLoading = true;
  bool detailView = false;

  final firestore = FirebaseFirestore.instance;
  User? auth = FirebaseAuth.instance.currentUser;
  String userName = "";
  getData() async {
    try {
      var userResult =
          await firestore.collection('users').doc(auth!.email.toString()).get();

      setState(() {
        userName = userResult['userName'];
        storeName = userResult['storeName'];
      });
    } catch (e) {}
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    textController.addListener(aaaA);

    setState(() {
      _isLoading = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    // 텍스트에디팅컨트롤러를 제거하고, 등록된 리스너도 제거된다.
    textController.dispose();
    super.dispose();
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('produceCost').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: HexColor('#172543'),
              ),
            ),
          );
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    //String storeName = auth!.displayName.toString();
    var widVal = MediaQuery.of(context).size.width;

    List<DocumentSnapshot> searchResults = [];
    for (DocumentSnapshot d in snapshot) {
      if (_searchText.isNotEmpty) {
        if (d['factoryName'].toString().contains(_searchText)) {
          searchResults.add(d);
        }
      }
    }

    return Container(
      child: ListView(
        children:
            searchResults.map((json) => _buildListItem(context, json)).toList(),
      ),
    );
  }

  String storeName = "";
  String factoryName = "";
  String brandRate = "";
  String birthDate = "";
  String gender = "";
  int point = 0;
  int accruedPoint = 0;
  int purchaseCount = 0;
  int purchaseAmount = 0;

  String firstVisitDate = "";
  String lastVisitDate = "";

  String etc = "";
  String height = "";
  String weight = "";
  String shoulderShape = "";
  String legShape = "";
  String posture = "";
  String eventAgree = "";
  List pointHistory = [];

  late TopSize? topSize;

  late BottomSize? bottomSize;
  late VestSize? vestSize;
  late ShirtSize? shirtSize;

  Widget _buildListItem(BuildContext context, data) {
    controller2 = PrimaryScrollController.of(context);
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        height: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '제작공장',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  data['factoryName'],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '제품등급',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  data['brandRate'],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        setState(
          () {
            detailView = true;
            _isLoading = true;
            Future.delayed(Duration(seconds: 1), () {
              setState(() {
                _isLoading = false;
              });
            });
            jacket = [];
            vest = [];
            pants = [];
            shirt = [];
            coat = [];
//
            jacketList = [];
            vestList = [];
            pantsList = [];
            shirtList = [];
            coatList = [];
            //
            jacketCost = [];
            vestCost = [];
            pantsCost = [];
            shirtCost = [];
            coatCost = [];

            factoryName = data['factoryName'];
            brandRate = data['brandRate'];
            getSearchData(data['brandRate']);
          },
        );
      },
    );
  }

  List jacket = [];
  List vest = [];
  List pants = [];
  List shirt = [];
  List coat = [];
  List jacketList = [];
  List vestList = [];
  List pantsList = [];
  List shirtList = [];
  List coatList = [];
  List jacketCost = [];
  List vestCost = [];
  List pantsCost = [];
  List shirtCost = [];
  List coatCost = [];

  getSearchData(String brandRate) async {
    try {
      try {
        var costResult = await firestore
            .collection('produceCost')
            .doc(storeName + '_' + factoryName + '_' + brandRate)
            .collection('costDetail')
            .get();

        for (var doc in costResult.docs) {
          if (doc['options'] == '자켓') {
            jacket.add(doc['optionsTitle']);
            jacketList.add(doc['optionsList']);
            jacketCost.add(doc['optionsProduceCost']);
          } else if (doc['options'] == '조끼') {
            vest.add(doc['optionsTitle']);
            vestList.add(doc['optionsList']);
            vestCost.add(doc['optionsProduceCost']);
          } else if (doc['options'] == '바지') {
            pants.add(doc['optionsTitle']);
            pantsList.add(doc['optionsList']);
            pantsCost.add(doc['optionsProduceCost']);
          } else if (doc['options'] == '셔츠') {
            shirt.add(doc['optionsTitle']);
            shirtList.add(doc['optionsList']);
            shirtCost.add(doc['optionsProduceCost']);
          } else {
            coat.add(doc['optionsTitle']);
            coatList.add(doc['optionsList']);
            coatCost.add(doc['optionsProduceCost']);
          }
        }
        print(jacket.toString());
      } catch (e) {}
    } catch (e) {
      print(e);
    }
  }

  void aaaA() {
    setState(() {
      _searchText = textController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      floatingActionButton: FloatingActionButton.extended(
          foregroundColor: mainColor,
          backgroundColor: mainColor,
          onPressed: () {
            Get.to(CostIntro(), arguments: {'factoryName': _searchText});
          },
          label: Text(
            '공임비 입력',
            style: TextStyle(color: Colors.white),
          )),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black),
        ),
        elevation: 2,
        title: Text(
          '공임비 관리',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: Responsive.isMobile(context)
          ? Container(
              padding: EdgeInsets.all(10),
              height: Get.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      detailView
                          ? Container(
                              width: Get.width * 0.9,
                              height: Get.height,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: _isLoading
                                      ? Center(
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(
                                              color: HexColor('#172543'),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: detailView
                                              ? _isLoading
                                                  ? Center(
                                                      child: SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: HexColor(
                                                              '#172543'),
                                                        ),
                                                      ),
                                                    )
                                                  : SingleChildScrollView(
                                                      controller: controller2,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: <Widget>[
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          20),
                                                                  child:
                                                                      IconButton(
                                                                    icon: Icon(Icons
                                                                        .arrow_back_sharp),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        detailView =
                                                                            false;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          20),
                                                                  child: Text(
                                                                    '기본 정보',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 10),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                80,
                                                                            child:
                                                                                Text(
                                                                              '테일려샵',
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                180,
                                                                            child:
                                                                                Text(
                                                                              storeName,
                                                                              style: TextStyle(fontSize: 14),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 10),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                80,
                                                                            child:
                                                                                Text(
                                                                              '제작공장',
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                180,
                                                                            child:
                                                                                Text(
                                                                              factoryName,
                                                                              style: TextStyle(fontSize: 14),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 10),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                80,
                                                                            child:
                                                                                Text(
                                                                              '제품등급',
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                180,
                                                                            child:
                                                                                Text(
                                                                              brandRate,
                                                                              style: TextStyle(fontSize: 14),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 20,
                                                                      bottom:
                                                                          20),
                                                                  child: Text(
                                                                    '공임비 정보',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                ),
                                                                Divider(
                                                                  height: 1,
                                                                  color:
                                                                      mainColor,
                                                                  thickness: 3,
                                                                ),
                                                                TabBar(
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                  indicatorColor:
                                                                      HexColor(
                                                                          '#172543'),
                                                                  indicatorWeight:
                                                                      3.0,
                                                                  controller:
                                                                      _tabController,
                                                                  tabs: const <
                                                                      Widget>[
                                                                    Tab(
                                                                      text:
                                                                          '자켓',
                                                                    ),
                                                                    Tab(
                                                                      text:
                                                                          '조끼',
                                                                    ),
                                                                    Tab(
                                                                      text:
                                                                          '바지',
                                                                    ),
                                                                    Tab(
                                                                      text:
                                                                          '셔츠',
                                                                    ),
                                                                    Tab(
                                                                      text:
                                                                          '코트',
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 20),
                                                                  height: jacketList
                                                                          .length *
                                                                      140,
                                                                  child:
                                                                      TabBarView(
                                                                    controller:
                                                                        _tabController,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Wrap(
                                                                            runSpacing:
                                                                                5,
                                                                            spacing:
                                                                                5,
                                                                            alignment:
                                                                                WrapAlignment.start,
                                                                            children:
                                                                                List.generate(
                                                                              jacket.length,
                                                                              (index) {
                                                                                return Container(
                                                                                  width: 300,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(bottom: 5),
                                                                                        child: Text(
                                                                                          jacket[index].toString(),
                                                                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Container(
                                                                                            width: 140,
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                for (var item in jacketList[index])
                                                                                                  Container(
                                                                                                    height: 20,
                                                                                                    child: Text(
                                                                                                      item,
                                                                                                      style: TextStyle(fontSize: 12),
                                                                                                    ),
                                                                                                  )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            width: 140,
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                for (var item in jacketCost[index])
                                                                                                  Container(
                                                                                                    alignment: Alignment.topCenter,
                                                                                                    height: 20,
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          item.toString(),
                                                                                                          style: TextStyle(fontSize: 12),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: 5,
                                                                                                        ),
                                                                                                        Text(
                                                                                                          '원',
                                                                                                          style: TextStyle(fontSize: 12),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 10,
                                                                                          )
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Wrap(
                                                                            runSpacing:
                                                                                5,
                                                                            spacing:
                                                                                5,
                                                                            alignment:
                                                                                WrapAlignment.start,
                                                                            children:
                                                                                List.generate(
                                                                              vest.length,
                                                                              (index) {
                                                                                return Container(
                                                                                  width: 200,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(bottom: 5),
                                                                                        child: Text(
                                                                                          vest[index].toString(),
                                                                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Container(
                                                                                            width: 100,
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                for (var item in vestList[index])
                                                                                                  Container(
                                                                                                    height: 20,
                                                                                                    child: Text(
                                                                                                      item,
                                                                                                      style: TextStyle(fontSize: 12),
                                                                                                    ),
                                                                                                  )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            width: 100,
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                for (var item in vestCost[index])
                                                                                                  Container(
                                                                                                    alignment: Alignment.topCenter,
                                                                                                    height: 20,
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          item.toString(),
                                                                                                          style: TextStyle(fontSize: 12),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: 5,
                                                                                                        ),
                                                                                                        Text(
                                                                                                          '원',
                                                                                                          style: TextStyle(fontSize: 12),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 10,
                                                                                          )
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Wrap(
                                                                            runSpacing:
                                                                                5,
                                                                            spacing:
                                                                                5,
                                                                            alignment:
                                                                                WrapAlignment.start,
                                                                            children:
                                                                                List.generate(
                                                                              pants.length,
                                                                              (index) {
                                                                                return Container(
                                                                                  width: 200,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(bottom: 5),
                                                                                        child: Text(
                                                                                          pants[index].toString(),
                                                                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Container(
                                                                                            width: 100,
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                for (var item in pantsList[index])
                                                                                                  Container(
                                                                                                    height: 20,
                                                                                                    child: Text(
                                                                                                      item,
                                                                                                      style: TextStyle(fontSize: 12),
                                                                                                    ),
                                                                                                  )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            width: 100,
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                for (var item in pantsCost[index])
                                                                                                  Container(
                                                                                                    alignment: Alignment.topCenter,
                                                                                                    height: 20,
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          item.toString(),
                                                                                                          style: TextStyle(fontSize: 12),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: 5,
                                                                                                        ),
                                                                                                        Text(
                                                                                                          '원',
                                                                                                          style: TextStyle(fontSize: 12),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 10,
                                                                                          )
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Wrap(
                                                                            runSpacing:
                                                                                5,
                                                                            spacing:
                                                                                5,
                                                                            alignment:
                                                                                WrapAlignment.start,
                                                                            children:
                                                                                List.generate(
                                                                              shirt.length,
                                                                              (index) {
                                                                                return Container(
                                                                                  width: 200,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(bottom: 5),
                                                                                        child: Text(
                                                                                          shirt[index].toString(),
                                                                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Container(
                                                                                            width: 100,
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                for (var item in shirtList[index])
                                                                                                  Container(
                                                                                                    height: 20,
                                                                                                    child: Text(
                                                                                                      item,
                                                                                                      style: TextStyle(fontSize: 12),
                                                                                                    ),
                                                                                                  )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            width: 100,
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                for (var item in shirtCost[index])
                                                                                                  Container(
                                                                                                    alignment: Alignment.topCenter,
                                                                                                    height: 20,
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          item.toString(),
                                                                                                          style: TextStyle(fontSize: 12),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: 5,
                                                                                                        ),
                                                                                                        Text(
                                                                                                          '원',
                                                                                                          style: TextStyle(fontSize: 12),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 10,
                                                                                          )
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Wrap(
                                                                            runSpacing:
                                                                                5,
                                                                            spacing:
                                                                                5,
                                                                            alignment:
                                                                                WrapAlignment.start,
                                                                            children:
                                                                                List.generate(
                                                                              coat.length,
                                                                              (index) {
                                                                                return Container(
                                                                                  width: 200,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(bottom: 5),
                                                                                        child: Text(
                                                                                          coat[index].toString(),
                                                                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Container(
                                                                                            width: 100,
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                for (var item in coatList[index])
                                                                                                  Container(
                                                                                                    height: 20,
                                                                                                    child: Text(
                                                                                                      item,
                                                                                                      style: TextStyle(fontSize: 12),
                                                                                                    ),
                                                                                                  )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            width: 100,
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                for (var item in coatCost[index])
                                                                                                  Container(
                                                                                                    alignment: Alignment.topCenter,
                                                                                                    height: 20,
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          item.toString(),
                                                                                                          style: TextStyle(fontSize: 12),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: 5,
                                                                                                        ),
                                                                                                        Text(
                                                                                                          '원',
                                                                                                          style: TextStyle(fontSize: 12),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 10,
                                                                                          )
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                              : Container(
                                                  height: Get.height,
                                                  child: Center(
                                                    child: Text(
                                                        '공장 검색 후, 조회할 공장을 선택하세요.'),
                                                  ),
                                                ),
                                        )),
                            )
                          : Container(
                              width: Get.width * 0.9,
                              height: Get.height,
                              child: Card(
                                // ignore: sort_child_properties_last
                                child: Column(
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, right: 10, left: 10),

                                        /// In AnimSearchBar widget, the width, textController, onSuffixTap are required properties.
                                        /// You have also control over the suffixIcon, prefixIcon, helpText and animationDurationInMilli
                                        child: AnimSearchBar(
                                          helpText: '공장명을 입력하세요.',
                                          //autoFocus: true,
                                          closeSearchOnSuffixTap: false,
                                          width: 400,
                                          textController: textController,
                                          onSuffixTap: () {
                                            setState(() {
                                              textController.clear();
                                            });
                                          },
                                          onSubmitted: (String) {},
                                        ),
                                      ),
                                      height: 100,
                                    ), // Expanded(

                                    //   child: Container(),
                                    //   flex: 1,
                                    // ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        // child: SingleChildScrollView(
                                        //   controller: controller1,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  child: _buildBody(context),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //    ),
                                      ),
                                    ),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              height: Get.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 400,
                    height: Get.height,
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, right: 10, left: 10),

                              /// In AnimSearchBar widget, the width, textController, onSuffixTap are required properties.
                              /// You have also control over the suffixIcon, prefixIcon, helpText and animationDurationInMilli
                              child: AnimSearchBar(
                                helpText: '공장명을 입력하세요.',
                                //autoFocus: true,
                                closeSearchOnSuffixTap: false,
                                width: 400,
                                textController: textController,
                                onSuffixTap: () {
                                  setState(() {
                                    textController.clear();
                                  });
                                },
                                onSubmitted: (String) {},
                              ),
                            ),
                            height: 100,
                          ), // Expanded(

                          //   child: Container(),
                          //   flex: 1,
                          // ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              // child: SingleChildScrollView(
                              //   controller: controller1,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: _buildBody(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //    ),
                            ),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 800,
                    height: Get.height,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: detailView
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
                                    controller: controller2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(30),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20),
                                                child: IconButton(
                                                  icon: Icon(
                                                      Icons.arrow_back_sharp),
                                                  onPressed: () {
                                                    setState(() {
                                                      detailView = false;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20),
                                                child: Text(
                                                  '기본 정보',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          child: Text(
                                                            '테일려샵',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 250,
                                                          child: Text(
                                                            storeName,
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          child: Text(
                                                            '제작공장',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 250,
                                                          child: Text(
                                                            factoryName,
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          child: Text(
                                                            '제품등급',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 250,
                                                          child: Text(
                                                            brandRate,
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20, bottom: 20),
                                                child: Text(
                                                  '공임비 정보',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Divider(
                                                height: 1,
                                                color: mainColor,
                                                thickness: 3,
                                              ),
                                              TabBar(
                                                indicatorColor:
                                                    HexColor('#172543'),
                                                indicatorWeight: 3.0,
                                                controller: _tabController,
                                                tabs: const <Widget>[
                                                  Tab(
                                                    text: '자켓',
                                                  ),
                                                  Tab(
                                                    text: '조끼',
                                                  ),
                                                  Tab(
                                                    text: '바지',
                                                  ),
                                                  Tab(
                                                    text: '셔츠',
                                                  ),
                                                  Tab(
                                                    text: '코트',
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                height: jacket.length * 70,
                                                child: TabBarView(
                                                  controller: _tabController,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Wrap(
                                                          runSpacing: 5,
                                                          spacing: 5,
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          children:
                                                              List.generate(
                                                            jacket.length,
                                                            (index) {
                                                              return Container(
                                                                width: 200,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        jacket[index]
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              for (var item in jacketList[index])
                                                                                Container(
                                                                                  height: 20,
                                                                                  child: Text(
                                                                                    item,
                                                                                    style: TextStyle(fontSize: 12),
                                                                                  ),
                                                                                )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              for (var item in jacketCost[index])
                                                                                Container(
                                                                                  alignment: Alignment.topCenter,
                                                                                  height: 20,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        item.toString(),
                                                                                        style: TextStyle(fontSize: 12),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        '원',
                                                                                        style: TextStyle(fontSize: 12),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Wrap(
                                                          runSpacing: 5,
                                                          spacing: 5,
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          children:
                                                              List.generate(
                                                            vest.length,
                                                            (index) {
                                                              return Container(
                                                                width: 200,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        vest[index]
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              for (var item in vestList[index])
                                                                                Container(
                                                                                  height: 20,
                                                                                  child: Text(
                                                                                    item,
                                                                                    style: TextStyle(fontSize: 12),
                                                                                  ),
                                                                                )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              for (var item in vestCost[index])
                                                                                Container(
                                                                                  alignment: Alignment.topCenter,
                                                                                  height: 20,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        item.toString(),
                                                                                        style: TextStyle(fontSize: 12),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        '원',
                                                                                        style: TextStyle(fontSize: 12),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Wrap(
                                                          runSpacing: 5,
                                                          spacing: 5,
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          children:
                                                              List.generate(
                                                            pants.length,
                                                            (index) {
                                                              return Container(
                                                                width: 200,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        pants[index]
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              for (var item in pantsList[index])
                                                                                Container(
                                                                                  height: 20,
                                                                                  child: Text(
                                                                                    item,
                                                                                    style: TextStyle(fontSize: 12),
                                                                                  ),
                                                                                )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              for (var item in pantsCost[index])
                                                                                Container(
                                                                                  alignment: Alignment.topCenter,
                                                                                  height: 20,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        item.toString(),
                                                                                        style: TextStyle(fontSize: 12),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        '원',
                                                                                        style: TextStyle(fontSize: 12),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Wrap(
                                                          runSpacing: 5,
                                                          spacing: 5,
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          children:
                                                              List.generate(
                                                            shirt.length,
                                                            (index) {
                                                              return Container(
                                                                width: 200,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        shirt[index]
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              for (var item in shirtList[index])
                                                                                Container(
                                                                                  height: 20,
                                                                                  child: Text(
                                                                                    item,
                                                                                    style: TextStyle(fontSize: 12),
                                                                                  ),
                                                                                )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              for (var item in shirtCost[index])
                                                                                Container(
                                                                                  alignment: Alignment.topCenter,
                                                                                  height: 20,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        item.toString(),
                                                                                        style: TextStyle(fontSize: 12),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        '원',
                                                                                        style: TextStyle(fontSize: 12),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Wrap(
                                                          runSpacing: 5,
                                                          spacing: 5,
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          children:
                                                              List.generate(
                                                            coat.length,
                                                            (index) {
                                                              return Container(
                                                                width: 200,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        coat[index]
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              for (var item in coatList[index])
                                                                                Container(
                                                                                  height: 20,
                                                                                  child: Text(
                                                                                    item,
                                                                                    style: TextStyle(fontSize: 12),
                                                                                  ),
                                                                                )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              for (var item in coatCost[index])
                                                                                Container(
                                                                                  alignment: Alignment.topCenter,
                                                                                  height: 20,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        item.toString(),
                                                                                        style: TextStyle(fontSize: 12),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        '원',
                                                                                        style: TextStyle(fontSize: 12),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                            : Container(
                                height: Get.height,
                                child: Center(
                                  child: Text('공장 검색 후, 조회할 공장을 선택하세요.'),
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
