import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/indicator_model.dart';
import 'package:bykak/src/components/number_format.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CalculatePage extends StatefulWidget {
  CalculatePage({Key? key}) : super(key: key);

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController scroller1;
  late ScrollController scroller;

  double offset = 0.0;
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    scroller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: false);
    scroller1 =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: false);
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });

    getData();
  }

  @override
  void dispose() {
    // Don't forget to dispose all of your controllers!
    _tabController.dispose();
    scroller1.dispose();
    scroller.dispose();

    super.dispose();
  }

  List processList = [];
  List gabongList = [];
  List processDetail = [];
  var doc;
  int listCount = 0;
  int dataCount = 0;

  final firestore = FirebaseFirestore.instance;
  User? auth = FirebaseAuth.instance.currentUser;
  TextEditingController searchStore = new TextEditingController();
  String storeName = "";
  String userType = "";
  String startDate = "";
  String endDate = "";

  var returnData;
  var returnJacket;
  var returnPants;
  var returnVest;
  var returnShirt;
  getData() async {
    var _toDay = DateTime.now();
    setState(() {
      startDate = _toDay.toString().substring(0, 10);
      endDate = _toDay.toString().substring(0, 10);
    });
    int difference = 0;

    try {
      try {
        var userResult = await firestore
            .collection('users')
            .doc(auth!.email.toString())
            .get();

        setState(() {
          storeName = userResult['storeName'];
          userType = userResult['userType'];
        });
      } catch (e) {}
      var _initYearMonth = DateTime.now().toString().substring(0, 7);

      if (userType == "2") {
        var result = await firestore
            .collection('orders')
            .where('factory', isEqualTo: storeName)
            // .where('consultDate', isGreaterThanOrEqualTo: _initYearMonth)
            .orderBy('productionProcess', descending: false)
            .orderBy('consultDate', descending: true)
            .get();

        for (var doc in result.docs) {
          difference = int.parse(_toDay
              .difference(DateTime.parse(doc['consultDate']))
              .inDays
              .toString());

          if (doc['factory'] == storeName) {
            setState(() {
              processList.add(doc);
            });
          } else {}
        }

        //가봉만 진행한 목록
        var gabongResult = await firestore
            .collection('orders')
            .where('gabongFactory', isEqualTo: storeName)

            // .where('consultDate', isGreaterThanOrEqualTo: _initYearMonth)
            .orderBy('productionProcess', descending: false)
            .orderBy('consultDate', descending: true)
            .get();

        for (var doc in gabongResult.docs) {
          difference = int.parse(_toDay
              .difference(DateTime.parse(doc['consultDate']))
              .inDays
              .toString());

          if ((doc['factory'] != null) && doc['factory'] != storeName) {
            setState(() {
              gabongList.add(doc);
            });
          } else {}
        }
      } else {
        var result = await firestore
            .collection('orders')
            .where('storeName', isEqualTo: storeName)
            .where('consultDate', isGreaterThanOrEqualTo: _initYearMonth)
            // .orderBy('productionProcess', descending: false)
            .orderBy('consultDate', descending: false)
            .get();

        for (doc in result.docs) {
          difference = int.parse(_toDay
              .difference(DateTime.parse(doc['consultDate']))
              .inDays
              .toString());

          //if (doc['storeName'] == storeName) {
          setState(() {
            processList.add(doc);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  getSearchData(String startDate, String endDate, String searchFactory) async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    processList = [];
    var _toDay = DateTime.now();
    int difference = 0;

    try {
      try {
        var userResult = await firestore
            .collection('users')
            .doc(auth!.email.toString())
            .get();

        setState(() {
          storeName = userResult['storeName'];
          userType = userResult['userType'];
        });
      } catch (e) {}

      if (userType == "2") {
        var result = await firestore
            .collection('orders')
            .where('factory', isEqualTo: storeName)
            .orderBy('productionProcess', descending: false)
            .orderBy('consultDate', descending: true)
            .get();

        for (doc in result.docs) {
          difference = int.parse(_toDay
              .difference(DateTime.parse(doc['consultDate']))
              .inDays
              .toString());

          if (doc['factory'] == storeName) {
            setState(() {
              processList.add(doc);
            });
          } else {}
        }
      } else {
        var result = searchFactory == ""
            ? await firestore
                .collection('orders')
                .where('storeName', isEqualTo: storeName)
                .where('consultDate', isGreaterThanOrEqualTo: startDate + ' 00')
                .where('consultDate', isLessThanOrEqualTo: endDate + ' 24')

                // .orderBy('productionProcess', descending: false)
                // .orderBy('consultDate', descending: true)
                .get()
            : await firestore
                .collection('orders')
                .where('storeName', isEqualTo: storeName)
                .where('consultDate', isGreaterThanOrEqualTo: startDate + ' 00')
                .where('consultDate', isLessThanOrEqualTo: endDate + ' 24')
                .where('factory', isEqualTo: searchFactory)
                // .orderBy('productionProcess', descending: false)
                // .orderBy('consultDate', descending: true)
                .get();

        for (doc in result.docs) {
          difference = int.parse(_toDay
              .difference(DateTime.parse(doc['consultDate']))
              .inDays
              .toString());
          // try {
          //   print('aa');
          //   print(doc['productUse']);
          // } catch (e) {
          //   print('bbb');
          //   setState(() {
          //     doc['productUse'] = null;
          //   });
          // }
          dataCount += 1;
          //if (doc['storeName'] == storeName) {
          setState(() {
            processList.add(doc);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  List<String> orderType = ['수트', '자켓', '셔츠', '바지', '조끼', '코트'];
  List<String> useType = ['일반', '예복'];

  final _verticalScrollController2 = ScrollController();
  final _horizontalScrollController2 = ScrollController();
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  final _verticalScrollController1 = ScrollController();
  final _horizontalScrollController1 = ScrollController();
  int checkDate = 0;
  @override
  Widget build(BuildContext context) {
    final ScrollController? _viewController =
        PrimaryScrollController.of(context);
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
          userType == "1" ? "제품 판매 목록" : "제품 제작 목록",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: mainColor,
        backgroundColor: mainColor,
        child: Icon(
          Icons.arrow_upward,
          color: Colors.white,
        ),
        onPressed: () async {
          userType == "1"
              ? {
                  if (_viewController!.hasClients)
                    await _viewController.animateTo(0,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.ease)
                }
              : {
                  if (scroller.hasClients)
                    {
                      await scroller.animateTo(0,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.ease),
                    }
                  else if (scroller1.hasClients)
                    {
                      await scroller1.animateTo(0,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.ease)
                    }
                };
        },
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
          : Column(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 15),
                      height: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '날짜선택',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '최초 조회 시, 해당 월 전체 목록 조회',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text('시작일자'),
                                  TextButton(
                                    onPressed: () {
                                      showDatePickerPopStart();
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 40,
                                      // decoration: BoxDecoration(
                                      //     border: Border.all(
                                      //   width: 0.5,
                                      //   color: HexColor('#172543'),
                                      // )),
                                      alignment: Alignment.center,
                                      child: Text(
                                        startDate,
                                        style: TextStyle(
                                            color: HexColor('#172543')),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text('-  '),
                              Row(
                                children: [
                                  Text('종료일자'),
                                  TextButton(
                                    onPressed: () {
                                      showDatePickerPopEnd();
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 40,
                                      // margin: const EdgeInsets.all(10.0),
                                      // padding: const EdgeInsets.only(
                                      //   left: 15,
                                      // ),
                                      // decoration: BoxDecoration(
                                      //     border: Border.all(
                                      //   width: 0.5,
                                      //   color: HexColor('#172543'),
                                      // )),
                                      alignment: Alignment.center,
                                      child: Text(
                                        endDate,
                                        style: TextStyle(
                                            color: HexColor('#172543')),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            '업체명',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 60,
                            width: 300,
                            child: CustomTextFormField(
                              lines: 1,
                              hint: "",
                              controller: searchStore,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 5,
                            ),
                            width: 100,
                            child: ElevatedButton(
                              style: TextButton.styleFrom(
                                primary: Colors.white, //글자색
                                onSurface: Colors.white, //onpressed가 null일때 색상
                                backgroundColor: HexColor('#172543'),
                                shadowColor: Colors.white, //그림자 색상
                                elevation: 1, // 버튼 입체감
                                textStyle: TextStyle(fontSize: 12),
                                //padding: EdgeInsets.all(16.0),
                                minimumSize: Size(75, 40), //최소 사이즈
                                maximumSize: Size(75, 40), //최소 사이즈,
                                side: BorderSide(
                                    color: HexColor('#172543'), width: 1.0), //선
                                shape:
                                    StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                alignment: Alignment.center,
                              ), //글자위치 변경
                              onPressed: () {
                                checkDate = int.parse(DateTime.parse(endDate)
                                    .difference(DateTime.parse(startDate))
                                    .inDays
                                    .toString());

                                if (checkDate < 0) {
                                  authFailAlert();
                                } else {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  getSearchData(startDate, endDate,
                                      searchStore.text.toString());
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('검색'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      height: 5,
                      color: Colors.black12,
                    ),
                  ],
                ),
                userType == "1"
                    ? Container()
                    : TabBar(
                        indicatorColor: HexColor('#172543'),
                        indicatorWeight: 3.0,
                        controller: _tabController,
                        tabs: const <Widget>[
                          Tab(
                            text: '전체(재단,가봉,봉제)',
                          ),
                          Tab(
                            text: '부분(재단,가봉)',
                          ),
                        ],
                      ),
                userType == "1"
                    ? Expanded(
                        child: SingleChildScrollView(
                          controller: _viewController,
                          child: Container(
                            // padding: EdgeInsets.only(top: 10),
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: AdaptiveScrollbar(
                              underColor: Colors.blueGrey.withOpacity(0.3),
                              sliderDefaultColor: Colors.grey.withOpacity(0.5),
                              sliderActiveColor: Colors.grey,
                              controller: _verticalScrollController2,
                              child: AdaptiveScrollbar(
                                controller: _horizontalScrollController2,
                                position: ScrollbarPosition.bottom,
                                width: 12,

                                //underColor: Colors.blueGrey.withOpacity(0.3),
                                sliderDefaultColor:
                                    Colors.grey.withOpacity(0.5),
                                sliderActiveColor: Colors.grey,
                                child: SingleChildScrollView(
                                  controller: _verticalScrollController2,
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    controller: _horizontalScrollController2,
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, bottom: 16.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                label: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '주문번호',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '주문일자',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '용도',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '이름',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '브랜드 타입',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '품목',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '제작업체 (가봉)',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '가봉공임비',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '가봉(예정)일자',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '제작업체 (봉제공장)',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '기본공임비',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '추가공임비',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '완성(예정)일자',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '공임비내용',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '원단',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '원단(조끼)',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '원단(하의)',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '요척량',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '요척량(하의)',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '요척량(조끼)',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '원단비용',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '부자재 (버튼/안감)',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '부자재비용',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                            rows: List<DataRow>.generate(
                                                processList.length,
                                                (index) =>
                                                    DataRow(cells: <DataCell>[
                                                      DataCell(Center(
                                                        child: Text((index + 1)
                                                            .toString()),
                                                      )),
                                                      DataCell(Text(
                                                          processList[index]
                                                              ['orderNo'])),
                                                      DataCell(Text(
                                                          processList[index]
                                                              ['consultDate'])),
                                                      DataCell(Text(useType[
                                                          int.parse(processList[
                                                                  index][
                                                              'productUse'])])),
                                                      DataCell(Text(
                                                          processList[index]
                                                                  ['name'] ??
                                                              "")),
                                                      DataCell(
                                                        Text(
                                                          processList[index][
                                                                  'brandRate'] ??
                                                              "",
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          orderType[int.parse(
                                                              processList[index]
                                                                  [
                                                                  'orderType'])],
                                                        ),
                                                      ),
                                                      DataCell(Text(processList[
                                                                  index][
                                                              'gabongFactory'] ??
                                                          "")),
                                                      DataCell(
                                                        Text(
                                                          moneyFormat(processList[
                                                                          index]
                                                                      [
                                                                      'gabongPrice'] ??
                                                                  0) +
                                                              ' 원',
                                                        ),
                                                      ),
                                                      DataCell(Text(
                                                          processList[index]
                                                                  ['gabong'] ??
                                                              "")),
                                                      DataCell(Text(
                                                          processList[index]
                                                                  ['factory'] ??
                                                              "")),

                                                      DataCell(
                                                        Text(
                                                          moneyFormat(processList[
                                                                          index]
                                                                      [
                                                                      'normalPrice'] ??
                                                                  0) +
                                                              ' 원',
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          moneyFormat(processList[
                                                                          index]
                                                                      [
                                                                      'factoryPrice'] ??
                                                                  0) +
                                                              ' 원',
                                                        ),
                                                      ),
                                                      DataCell(Text(processList[
                                                                  index]
                                                              ['finishDate'] ??
                                                          "")),

                                                      // DataCell(Text(processList[index]
                                                      //         ['productUse'] ??
                                                      //     "")),

                                                      DataCell(
                                                        Text(processList[index][
                                                                'factoryPriceDetail'] ??
                                                            ""),
                                                      ),
                                                      DataCell(Text(
                                                          processList[index]
                                                                  ['pabric'] ??
                                                              "")),
                                                      DataCell(Text(processList[
                                                                  index]
                                                              ['pabricSub1'] ??
                                                          "")),
                                                      DataCell(Text(processList[
                                                                  index]
                                                              ['pabricSub2'] ??
                                                          "")),
                                                      DataCell(Text(processList[
                                                                  index]
                                                              ['pabricUsage'] ??
                                                          "")),
                                                      DataCell(Text(processList[
                                                                  index][
                                                              'pabricUsage1'] ??
                                                          "")),
                                                      DataCell(Text(processList[
                                                                  index][
                                                              'pabricUsage2'] ??
                                                          "")),
                                                      DataCell(Text('0')),
                                                      DataCell(Row(
                                                        children: [
                                                          Text(processList[
                                                                      index]
                                                                  ['buttons'] ??
                                                              ""),
                                                          Text(' / '),
                                                          Text(processList[
                                                                      index]
                                                                  ['lining'] ??
                                                              "")
                                                        ],
                                                      )),
                                                      DataCell(Text('0')),
                                                    ]))),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            SingleChildScrollView(
                              controller: scroller,
                              child: Container(
                                padding: EdgeInsets.only(top: 10),
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: AdaptiveScrollbar(
                                  underColor: Colors.blueGrey.withOpacity(0.3),
                                  sliderDefaultColor:
                                      Colors.grey.withOpacity(0.5),
                                  sliderActiveColor: Colors.grey,
                                  controller: _verticalScrollController,
                                  child: AdaptiveScrollbar(
                                    controller: _horizontalScrollController,
                                    position: ScrollbarPosition.bottom,
                                    width: 12,

                                    //underColor: Colors.blueGrey.withOpacity(0.3),
                                    sliderDefaultColor:
                                        Colors.grey.withOpacity(0.5),
                                    sliderActiveColor: Colors.grey,
                                    child: SingleChildScrollView(
                                      controller: _verticalScrollController,
                                      scrollDirection: Axis.vertical,
                                      child: SingleChildScrollView(
                                        controller: _horizontalScrollController,
                                        scrollDirection: Axis.horizontal,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, bottom: 16.0),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: DataTable(
                                                columns: const <DataColumn>[
                                                  DataColumn(
                                                    label: Text(
                                                      'No',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '주문번호',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '테일러샵',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '주문일자',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '가봉(예정)일자',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '완성(예정)일자',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '용도',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '이름',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '브랜드 타입',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '품목',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '기본공임비',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '가봉공임비',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '추가공임비',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '공임비내용',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '원단',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '원단(조끼)',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '원단(하의)',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '요척량',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '요척량(하의)',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '요척량(조끼)',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '부자재 (버튼/안감)',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '부자재비용',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ],
                                                rows: List<DataRow>.generate(
                                                    processList.length,
                                                    (index) => DataRow(cells: <
                                                            DataCell>[
                                                          DataCell(Center(
                                                            child: Text((index +
                                                                    1)
                                                                .toString()),
                                                          )),
                                                          DataCell(Text(
                                                              processList[index]
                                                                  ['orderNo'])),
                                                          DataCell(Row(
                                                            children: [
                                                              Text(processList[
                                                                      index][
                                                                  'storeName']),
                                                            ],
                                                          )),
                                                          DataCell(Text(
                                                              processList[index]
                                                                  [
                                                                  'consultDate'])),
                                                          DataCell(Text(
                                                              processList[index]
                                                                      [
                                                                      'gabong'] ??
                                                                  "")),
                                                          DataCell(Text(
                                                              processList[index]
                                                                      [
                                                                      'finishDate'] ??
                                                                  "")),
                                                          DataCell(Text(useType[
                                                              int.parse(processList[
                                                                      index][
                                                                  'productUse'])])),
                                                          // DataCell(Text(processList[index]
                                                          //         ['productUse'] ??
                                                          //     "")),
                                                          DataCell(Text(
                                                              processList[index]
                                                                      [
                                                                      'name'] ??
                                                                  "")),
                                                          DataCell(
                                                            Text(
                                                              processList[index]
                                                                      [
                                                                      'brandRate'] ??
                                                                  "",
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Text(
                                                              orderType[int.parse(
                                                                  processList[
                                                                          index]
                                                                      [
                                                                      'orderType'])],
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Text(
                                                              moneyFormat(processList[
                                                                              index]
                                                                          [
                                                                          'normalPrice'] ??
                                                                      0) +
                                                                  ' 원',
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Text(
                                                              moneyFormat(processList[
                                                                              index]
                                                                          [
                                                                          'gabongPrice'] ??
                                                                      0) +
                                                                  ' 원',
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Text(
                                                              moneyFormat(processList[
                                                                              index]
                                                                          [
                                                                          'factoryPrice'] ??
                                                                      0) +
                                                                  ' 원',
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Text(processList[
                                                                        index][
                                                                    'factoryPriceDetail'] ??
                                                                ""),
                                                          ),
                                                          DataCell(Text(
                                                              processList[index]
                                                                      [
                                                                      'pabric'] ??
                                                                  "")),
                                                          DataCell(Text(
                                                              processList[index]
                                                                      [
                                                                      'pabricSub1'] ??
                                                                  "")),
                                                          DataCell(Text(
                                                              processList[index]
                                                                      [
                                                                      'pabricSub2'] ??
                                                                  "")),
                                                          DataCell(Text(
                                                              processList[index]
                                                                      [
                                                                      'pabricUsage'] ??
                                                                  "")),
                                                          DataCell(Text(
                                                              processList[index]
                                                                      [
                                                                      'pabricUsage1'] ??
                                                                  "")),
                                                          DataCell(Text(
                                                              processList[index]
                                                                      [
                                                                      'pabricUsage2'] ??
                                                                  "")),

                                                          DataCell(Row(
                                                            children: [
                                                              Text(processList[
                                                                          index]
                                                                      [
                                                                      'buttons'] ??
                                                                  ""),
                                                              Text(' / '),
                                                              Text(processList[
                                                                          index]
                                                                      [
                                                                      'lining'] ??
                                                                  "")
                                                            ],
                                                          )),
                                                          DataCell(Text('0')),
                                                        ]))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              controller: scroller1,
                              child: Container(
                                padding: EdgeInsets.only(top: 10),
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: AdaptiveScrollbar(
                                  underColor: Colors.blueGrey.withOpacity(0.3),
                                  sliderDefaultColor:
                                      Colors.grey.withOpacity(0.5),
                                  sliderActiveColor: Colors.grey,
                                  controller: _verticalScrollController1,
                                  child: AdaptiveScrollbar(
                                    controller: _horizontalScrollController1,
                                    position: ScrollbarPosition.bottom,
                                    width: 12,

                                    //underColor: Colors.blueGrey.withOpacity(0.3),
                                    sliderDefaultColor:
                                        Colors.grey.withOpacity(0.5),
                                    sliderActiveColor: Colors.grey,
                                    child: SingleChildScrollView(
                                      controller: _verticalScrollController1,
                                      scrollDirection: Axis.vertical,
                                      child: SingleChildScrollView(
                                        controller:
                                            _horizontalScrollController1,
                                        scrollDirection: Axis.horizontal,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, bottom: 16.0),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: DataTable(
                                                columns: const <DataColumn>[
                                                  DataColumn(
                                                    label: Text(
                                                      'No',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '주문번호',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '테일러샵',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '주문일자',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '가봉(예정)일자',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '완성(예정)일자',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '용도',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '이름',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '브랜드 타입',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '품목',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '가봉공임비',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '원단',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '원단(조끼)',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '원단(하의)',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '요척량',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '요척량(하의)',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '요척량(조끼)',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ],
                                                rows: List<DataRow>.generate(
                                                    gabongList.length,
                                                    (index) => DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(Center(
                                                                child: Text(
                                                                    (index + 1)
                                                                        .toString()),
                                                              )),
                                                              DataCell(Text(
                                                                  gabongList[
                                                                          index]
                                                                      [
                                                                      'orderNo'])),
                                                              DataCell(Row(
                                                                children: [
                                                                  Text(gabongList[
                                                                          index]
                                                                      [
                                                                      'storeName']),
                                                                ],
                                                              )),
                                                              DataCell(Text(
                                                                  gabongList[
                                                                          index]
                                                                      [
                                                                      'consultDate'])),
                                                              DataCell(Text(
                                                                  gabongList[index]
                                                                          [
                                                                          'gabong'] ??
                                                                      "")),
                                                              DataCell(Text(
                                                                  gabongList[index]
                                                                          [
                                                                          'finishDate'] ??
                                                                      "")),
                                                              DataCell(Text(useType[
                                                                  int.parse(gabongList[
                                                                          index]
                                                                      [
                                                                      'productUse'])])),
                                                              // DataCell(Text(processList[index]
                                                              //         ['productUse'] ??
                                                              //     "")),
                                                              DataCell(Text(
                                                                  gabongList[index]
                                                                          [
                                                                          'name'] ??
                                                                      "")),
                                                              DataCell(
                                                                Text(
                                                                  gabongList[index]
                                                                          [
                                                                          'brandRate'] ??
                                                                      "",
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Text(
                                                                  orderType[int.parse(
                                                                      gabongList[
                                                                              index]
                                                                          [
                                                                          'orderType'])],
                                                                ),
                                                              ),

                                                              DataCell(
                                                                Text(
                                                                  moneyFormat(processList[index]
                                                                              [
                                                                              'gabongPrice'] ??
                                                                          0) +
                                                                      ' 원',
                                                                ),
                                                              ),

                                                              DataCell(Text(
                                                                  gabongList[index]
                                                                          [
                                                                          'pabric'] ??
                                                                      "")),
                                                              DataCell(Text(
                                                                  gabongList[index]
                                                                          [
                                                                          'pabricSub1'] ??
                                                                      "")),
                                                              DataCell(Text(
                                                                  gabongList[index]
                                                                          [
                                                                          'pabricSub2'] ??
                                                                      "")),
                                                              DataCell(Text(
                                                                  gabongList[index]
                                                                          [
                                                                          'pabricUsage'] ??
                                                                      "")),
                                                              DataCell(Text(
                                                                  gabongList[index]
                                                                          [
                                                                          'pabricUsage1'] ??
                                                                      "")),
                                                              DataCell(Text(
                                                                  gabongList[index]
                                                                          [
                                                                          'pabricUsage2'] ??
                                                                      "")),
                                                            ]))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
    );
  }

  void authFailAlert() {
    Fluttertoast.showToast(
        webBgColor: "linear-gradient(to right, #F44336, #F44336)",
        webPosition: "center",
        msg: "조회 기간을 확인해주세요.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffF44336),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  /* DatePicker 띄우기 */
  void showDatePickerPopStart() {
    Future<DateTime?> selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(), //초기값
      firstDate: DateTime(2000), //시작일
      lastDate: DateTime(2100), //마지막일
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: HexColor('#172543'),
            //accentColor: const Color(0xFF8CE7F1),
            colorScheme: ColorScheme.light(primary: HexColor('#172543')),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          //data: ThemeData.light(), //다크 테마
          child: child!,
        );
      },
    );

    selectedDate.then((dateTime) {
      setState(() {
        startDate = dateTime.toString().substring(0, 10);
      });
    });
  }

  /* DatePicker 띄우기 */
  void showDatePickerPopEnd() {
    Future<DateTime?> selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(), //초기값
      firstDate: DateTime(2000), //시작일
      lastDate: DateTime(2100), //마지막일
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: HexColor('#172543'),
            //accentColor: const Color(0xFF8CE7F1),
            colorScheme: ColorScheme.light(primary: HexColor('#172543')),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          //data: ThemeData.light(), //다크 테마
          child: child!,
        );
      },
    );

    selectedDate.then((dateTime) {
      setState(() {
        endDate = dateTime.toString().substring(0, 10);
      });
    });
  }
}
