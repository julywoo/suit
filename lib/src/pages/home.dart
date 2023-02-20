import 'package:bykak/src/components/alert_fucntion.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/indicator_model.dart';
import 'package:bykak/src/components/number_format.dart';
import 'package:bykak/src/components/responsive.dart';
import 'package:bykak/src/pages/calculate_page.dart';
import 'package:bykak/src/pages/customer/customer_list_page.dart';

import 'package:bykak/src/pages/factory/factory_cost.dart';
import 'package:bykak/src/pages/input_suit_data.dart';
import 'package:bykak/src/pages/progress_page.dart';
import 'package:bykak/src/pages/qr_scanner_page.dart';

import 'package:bykak/src/pages/search_page.dart';
import 'package:bykak/src/pages/tailorShop/cost_list_page.dart';
import 'package:bykak/src/pages/tailorShop/price_manage_page.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import 'customer/membership_search_page.dart';

class DataItem {
  int x;

  // double y3;
  DataItem({
    required this.x,

    // /, required this.y2, required this.y3
  });
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> slideList = [
    'assets/slide/slide1.png',
    'assets/slide/slide2.png',
    'assets/slide/slide3.png'
  ];

  final List mainPageList = [
    InputSuitData(),
    SearchPage(),
  ];

  final firestore = FirebaseFirestore.instance;
  User? auth = FirebaseAuth.instance.currentUser;
  String userType = '';
  String storeName = '';

  String step1 = ' 신규 ';
  String step2 = ' 기존 ';
  getData() async {
    try {
      var userData =
          await firestore.collection('users').doc(auth!.email.toString()).get();

      setState(() {
        userType = userData['userType'];
        storeName = userData['storeName'];
      });
      getOrdersList();
    } catch (e) {}
  }

  List visitRoute = [0, 0, 0, 0, 0, 0];
  List visitRate = [0, 0];
  List nameList = [];
  List phoneList = [];
  int visitCount = 0;
  int visit = 0;
  int thisMonthPurchase = 0;
  int lastMonthPurchase = 0;
  String diffPurchase = "";
  int productStep1 = 0;
  int productStep2 = 0;
  int productStep3 = 0;
  int productStep4 = 0;
  getOrdersList() async {
    DateTime dateTime1 = DateTime.now();
    var lastMonth = DateTime(dateTime1.year, dateTime1.month - 1, dateTime1.day)
        .toString()
        .substring(0, 7);

    var thisMonth = DateTime(dateTime1.year, dateTime1.month, dateTime1.day)
        .toString()
        .substring(0, 7);

    try {
      var ordersResult = await firestore
          .collection('orders')
          .where('storeName', isEqualTo: storeName)
          .get();

      for (var doc in ordersResult.docs) {
        try {
          setState(() {
            if (doc['productionProcess'] < 5) {
              productStep1 = productStep1 + 1;
            } else if (doc['productionProcess'] > 4 &&
                doc['productionProcess'] < 9) {
              productStep2 = productStep2 + 1;
            } else if (doc['productionProcess'] > 8 &&
                doc['productionProcess'] < 15) {
              productStep3 = productStep3 + 1;
            } else if (doc['productionProcess'] == 15) {
              productStep4 = productStep4 + 1;
            }

            if (doc['consultDate'].toString().contains(lastMonth)) {
              if (doc['price'] == null || doc['price'] == "") {
                lastMonthPurchase += 0;
              } else {
                lastMonthPurchase += int.parse(doc['price']);
              }
            } else if (doc['consultDate'].toString().contains(thisMonth)) {
              //이번 달 방문 고객만
              if (doc['visitRoute'].toString().contains('네이버')) {
                visitRoute[0] = visitRoute[0] + 1;
              } else if (doc['visitRoute'].toString().contains('SNS')) {
                visitRoute[1] = visitRoute[0] + 1;
              } else if (doc['visitRoute'].toString().contains('유튜브')) {
                visitRoute[2] = visitRoute[0] + 1;
              } else if (doc['visitRoute'].toString().contains('지인')) {
                visitRoute[3] = visitRoute[0] + 1;
              } else if (doc['visitRoute'].toString().contains('웨딩')) {
                visitRoute[4] = visitRoute[0] + 1;
              } else {
                visitRoute[5] = visitRoute[0] + 1;
              }
              visitCount++;

              if (!nameList.contains(doc['name'])) {
                nameList.add(doc['name']);
                phoneList.add(doc['phone']);
              }

              if (doc['price'] == null || doc['price'] == "") {
                thisMonthPurchase += 0;
              } else {
                thisMonthPurchase += int.parse(doc['price']);
              }
            }

            //else {}
          });
        } catch (e) {
          //print(e);
        }
      }

      produceList = [productStep1, productStep2, productStep3, productStep4];
      if ((thisMonthPurchase - lastMonthPurchase) > 0) {
        diffPurchase = "지난달 대비 " +
            moneyFormat(thisMonthPurchase - lastMonthPurchase) +
            ' 원 증가';
      } else {
        diffPurchase = "지난달 대비 " +
            moneyFormat(thisMonthPurchase - lastMonthPurchase)
                .toString()
                .replaceAll('-', '') +
            ' 원 감소';
      }
      for (var i = 0; i < nameList.length; i++) {
        String userPhone = "";
        if (phoneList[i].toString().length == 11) {
          userPhone = phoneList[i].toString().substring(7, 11);
        } else if (phoneList[i].toString().length == 10) {
          userPhone = phoneList[i].toString().substring(6, 10);
        } else {
          userPhone = "";
        }
        //print(nameList[i] + '_' + userPhone + '_' + storeName);
        var customersResult = await firestore
            .collection('customers')
            .doc(nameList[i] + '_' + userPhone + '_' + storeName)
            .get();
        if (customersResult['purchaseCount'] > 0) {
          visitRate[1] = visitRate[1] + 1;
        } else {
          visitRate[0] = visitRate[0] + 1;
        }
      }
      visit = visitRate[0] + visitRate[1];
    } catch (e) {}
  }

  List produceList = [];
  List produceListColor = [];
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    produceList = [0, 0, 0, 0];
    produceListColor = [
      mainColor.withOpacity(0.25),
      mainColor.withOpacity(0.50),
      mainColor.withOpacity(0.75),
      mainColor.withOpacity(1),
    ];
    getData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int touchedIndex = -1;
  int touchedIndex1 = -1;
  String aaa = 'aaa';
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: HexColor('#172543'),
              ),
            ),
          )
        : Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            // appBar: AppBar(
            //   //backgroundColor: HexColor('#'),

            //   backgroundColor: Colors.white,
            //   elevation: 0,
            // ),
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: 1000,
                  //color: HexColor('#172543'),
                  color: Colors.white10,
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 50, 50, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      'assets/logo.png',
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  child: Text(
                                    '매장 월별 현황',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: mainColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Responsive.isMobile(context)
                                    ? HomeMenuTopMob(context)
                                    : HomeMenuTopWeb(context),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  child: Text(
                                    '제작 관리',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: mainColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Responsive.isMobile(context)
                                    ? HomeMenuMidMob(context)
                                    : HomeMenuMidWeb(context),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  child: Text(
                                    '매장 관리',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: mainColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Responsive.isMobile(context)
                                    ? HomeMenuBottomMob(context)
                                    : HomeMenuBottomWeb(context),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
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

  Widget HomeMenuTopWeb(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Material(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '실시간 제작 현황',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(ProgressPage());
                              },
                              child: Text(
                                '전체 목록',
                                style:
                                    TextStyle(fontSize: 12, color: mainColor),
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Container(
                              width: 180,
                              child: BarChart(
                                BarChartData(
                                  barTouchData: BarTouchData(
                                    // allowTouchBarBackDraw: false,
                                    // handleBuiltInTouches: false,
                                    enabled: false,
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: getTitles,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: false,
                                    drawHorizontalLine: false,
                                    drawVerticalLine: false,
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                    border: const Border(
                                      top: BorderSide.none,
                                      right: BorderSide.none,
                                      left: BorderSide.none,
                                      bottom: BorderSide.none,
                                    ),
                                  ),
                                  groupsSpace: 10,
                                  barGroups: _myData
                                      .map((dataItem) => BarChartGroupData(
                                              x: dataItem.x,
                                              barRods: [
                                                BarChartRodData(
                                                  toY: produceList[dataItem.x],
                                                  color: produceListColor[
                                                      dataItem.x],
                                                ),
                                              ]))
                                      .toList(),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Material(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '방문고객',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '방문 $visit 명',
                            style: TextStyle(fontSize: 12, color: mainColor),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: visit == 0
                          ? Center(
                              child: Text(
                                '이번달 방문고객이 없습니다.',
                                style: TextStyle(fontSize: 12),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 120,
                                  child: PieChart(
                                    PieChartData(
                                        pieTouchData: PieTouchData(
                                            touchCallback: (FlTouchEvent event,
                                                pieTouchResponse) {
                                          setState(() {
                                            if (!event
                                                    .isInterestedForInteractions ||
                                                pieTouchResponse == null ||
                                                pieTouchResponse
                                                        .touchedSection ==
                                                    null) {
                                              touchedIndex = -1;
                                              return;
                                            }
                                            touchedIndex = pieTouchResponse
                                                .touchedSection!
                                                .touchedSectionIndex;
                                          });
                                        }),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 10,
                                        sections: showingVisitCount()),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Indicator(
                                      color: mainColor.withOpacity(0.75),
                                      text: step2,
                                      isSquare: true,
                                      size: 10,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Indicator(
                                      color: mainColor.withOpacity(0.25),
                                      text: step1,
                                      isSquare: true,
                                      size: 10,
                                    ),
                                  ],
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
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Material(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '방문경로',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '방문 $visit 명',
                            style: TextStyle(fontSize: 12, color: mainColor),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: visit == 0
                          ? Center(
                              child: Text(
                                '이번달 방문고객이 없습니다.',
                                style: TextStyle(fontSize: 12),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 140,
                                  child: PieChart(
                                    PieChartData(
                                        pieTouchData: PieTouchData(
                                            touchCallback: (FlTouchEvent event,
                                                pieTouchResponse) {
                                          setState(() {
                                            if (!event
                                                    .isInterestedForInteractions ||
                                                pieTouchResponse == null ||
                                                pieTouchResponse
                                                        .touchedSection ==
                                                    null) {
                                              touchedIndex1 = -1;
                                              return;
                                            }
                                            touchedIndex1 = pieTouchResponse
                                                .touchedSection!
                                                .touchedSectionIndex;
                                          });
                                        }),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 10,
                                        sections: showingSections()),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Indicator(
                                      color: mainColor,
                                      text: '네이버',
                                      isSquare: true,
                                      size: 10,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Indicator(
                                      color: mainColor.withOpacity(0.85),
                                      text: 'SNS',
                                      isSquare: true,
                                      size: 10,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Indicator(
                                      color: mainColor.withOpacity(0.70),
                                      text: '유튜브',
                                      isSquare: true,
                                      size: 10,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Indicator(
                                      color: mainColor.withOpacity(0.55),
                                      text: '지인소개',
                                      isSquare: true,
                                      size: 10,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Indicator(
                                      color: mainColor.withOpacity(0.40),
                                      text: '웨딩업체',
                                      isSquare: true,
                                      size: 10,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Indicator(
                                      color: mainColor.withOpacity(0.25),
                                      text: '재방문',
                                      isSquare: true,
                                      size: 10,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                  ],
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
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Material(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '매출',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            diffPurchase,
                            style: TextStyle(
                                fontSize: 12, color: Colors.red.shade300),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '이번달 ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(moneyFormat(thisMonthPurchase) + ' 원'),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '지난달 ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(moneyFormat(lastMonthPurchase) + ' 원'),
                            ],
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
      ],
    );
  }

  final controllers = SwiperControl();
  Widget HomeMenuTopMob(BuildContext context) {
    List widgetList = [
      topSwiper1(context),
      topSwiper2(context),
      topSwiper3(context),
      topSwiper4(context),
    ];
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Swiper(
        autoplay: false,
        itemBuilder: (context, index) {
          return Container(
              color: Colors.white,
              padding: EdgeInsets.all(8),
              child: widgetList[index]);
        },
        itemCount: widgetList.length,
        // pagination: SwiperPagination(
        //   alignment: Alignment.bottomCenter,
        //   builder: new DotSwiperPaginationBuilder(
        //       color: Colors.grey,
        //       activeColor: HexColor('#172543'),
        //       size: 10,
        //       activeSize: 15,
        //       space: 5),
        // ),
        control: SwiperControl(
            color: mainColor, size: 20, padding: EdgeInsets.all(20)),
        scrollDirection: Axis.horizontal,
      ),
    );

    // new SizedBox(
    //   child: new Swiper(
    //     pagination: new SwiperPagination(),
    //     itemCount: widgetList.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return widgetList[index];
    //     },
    //   ),
    //   height: MediaQuery.of(context).size.height * 0.3,
    // );
  }

  Widget topSwiper4(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Material(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '매출',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      diffPurchase,
                      style:
                          TextStyle(fontSize: 12, color: Colors.red.shade300),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '이번달 ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(moneyFormat(thisMonthPurchase) + ' 원'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '지난달 ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(moneyFormat(lastMonthPurchase) + ' 원'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topSwiper3(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Material(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '방문경로',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '방문 $visit 명',
                      style: TextStyle(fontSize: 12, color: mainColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: visit == 0
                    ? Center(
                        child: Text(
                          '이번달 방문고객이 없습니다.',
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 140,
                            child: PieChart(
                              PieChartData(
                                  pieTouchData: PieTouchData(touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        touchedIndex1 = -1;
                                        return;
                                      }
                                      touchedIndex1 = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  }),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 10,
                                  sections: showingSections()),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Indicator(
                                color: mainColor,
                                text: '네이버',
                                isSquare: true,
                                size: 10,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: mainColor.withOpacity(0.85),
                                text: 'SNS',
                                isSquare: true,
                                size: 10,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: mainColor.withOpacity(0.70),
                                text: '유튜브',
                                isSquare: true,
                                size: 10,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: mainColor.withOpacity(0.55),
                                text: '지인소개',
                                isSquare: true,
                                size: 10,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: mainColor.withOpacity(0.40),
                                text: '웨딩업체',
                                isSquare: true,
                                size: 10,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: mainColor.withOpacity(0.25),
                                text: '재방문',
                                isSquare: true,
                                size: 10,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topSwiper2(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Material(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '방문고객',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '방문 $visit 명',
                      style: TextStyle(fontSize: 12, color: mainColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: visit == 0
                    ? Center(
                        child: Text(
                          '이번달 방문고객이 없습니다.',
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 120,
                            child: PieChart(
                              PieChartData(
                                  pieTouchData: PieTouchData(touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  }),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 10,
                                  sections: showingVisitCount()),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Indicator(
                                color: mainColor.withOpacity(0.75),
                                text: step2,
                                isSquare: true,
                                size: 10,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: mainColor.withOpacity(0.25),
                                text: step1,
                                isSquare: true,
                                size: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topSwiper1(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Material(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '실시간 제작 현황',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(ProgressPage());
                        },
                        child: Text(
                          '전체 목록',
                          style: TextStyle(fontSize: 12, color: mainColor),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Container(
                        width: 180,
                        child: BarChart(
                          BarChartData(
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: getTitles,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(
                              show: false,
                              drawHorizontalLine: false,
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(
                              show: false,
                              border: const Border(
                                top: BorderSide.none,
                                right: BorderSide.none,
                                left: BorderSide.none,
                                bottom: BorderSide.none,
                              ),
                            ),
                            groupsSpace: 10,
                            barGroups: _myData
                                .map((dataItem) =>
                                    BarChartGroupData(x: dataItem.x, barRods: [
                                      BarChartRodData(
                                        //toY: 1,
                                        toY: double.parse(
                                            produceList[dataItem.x].toString()),
                                        color: produceListColor[dataItem.x],
                                      ),
                                    ]))
                                .toList(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget HomeMenuMidWeb(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.13,
              child: userType != '2'
                  ? Material(
                      elevation: 5,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Container(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: getShape(),
                            elevation: getElevation(),
                            foregroundColor:
                                getColor(HexColor('#172543'), Colors.white),
                            backgroundColor:
                                getColor(Colors.white, HexColor('#172543')),
                            // side: getBorder(HexColor('#172543'),
                            //     HexColor('#172543')),
                          ),
                          onPressed: () {
                            Get.to(
                              InputSuitData(),
                              //arguments: {'orderType': '3'}
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LineIcons.paste),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '맞춤복 상담',
                                style: TextStyle(
                                    // fontFamily: 'Caveat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                        shape: getShape(),
                        elevation: getElevation(),
                        foregroundColor:
                            getColor(HexColor('#172543'), Colors.white),
                        backgroundColor:
                            getColor(Colors.white, HexColor('#172543')),
                      ),
                      onPressed: () {
                        Get.to(
                          FactoryCost(),

                          //arguments: {'orderType': '3'}
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LineIcons.wonSign),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '공임비 관리',
                            style: TextStyle(
                                // fontFamily: 'Caveat',
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child: userType != '2'
                ? Material(
                    elevation: 5,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: getShape(),
                          elevation: getElevation(),
                          foregroundColor:
                              getColor(HexColor('#172543'), Colors.white),
                          backgroundColor:
                              getColor(Colors.white, HexColor('#172543')),
                        ),
                        onPressed: () {
                          Get.to(
                            SearchPage(),
                            //arguments: {'orderType': '3'}
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LineIcons.search),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '작업지시서 조회',
                              style: TextStyle(
                                  // fontFamily: 'Caveat',

                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                      shape: getShape(),
                      elevation: getElevation(),
                      foregroundColor:
                          getColor(HexColor('#172543'), Colors.white),
                      backgroundColor:
                          getColor(Colors.white, HexColor('#172543')),
                      side: getBorder(HexColor('#172543'), HexColor('#172543')),
                    ),
                    onPressed: () {
                      if (GetPlatform.isWeb) {
                        failAlert('QR 스캔은 웹에서는 지원되지 않습니다.');
                      } else {
                        Get.to(
                          QrScannerPage(),
                          //arguments: {'orderType': '3'}
                        );
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LineIcons.qrcode),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'QR 스캐너',
                          style: TextStyle(
                              // fontFamily: 'Caveat',

                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Qr Scan of Work Sheet',
                              style: TextStyle(
                                  // fontFamily: 'Caveat',

                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10),
                            )),
                      ],
                    ),
                  ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: getShape(),
                    elevation: getElevation(),
                    foregroundColor:
                        getColor(HexColor('#172543'), Colors.white),
                    backgroundColor:
                        getColor(Colors.white, HexColor('#172543')),
                  ),
                  onPressed: () {
                    Get.to(
                      ProgressPage(),
                      //arguments: {'orderType': '3'}
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LineIcons.tasks),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '제작 현황',
                        style: TextStyle(
                            // fontFamily: 'Caveat',

                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: getShape(),
                    elevation: getElevation(),
                    foregroundColor:
                        getColor(HexColor('#172543'), Colors.white),
                    backgroundColor:
                        getColor(Colors.white, HexColor('#172543')),
                  ),
                  onPressed: () {
                    if (GetPlatform.isWeb) {
                      failAlert('QR 스캔은 웹에서는 지원되지 않습니다.');
                    } else {
                      Get.to(
                        QrScannerPage(),
                        //arguments: {'orderType': '3'}
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LineIcons.qrcode),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'QR 스캐너',
                        style: TextStyle(
                            // fontFamily: 'Caveat',

                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget HomeMenuMidMob(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                    height: Get.height * 0.15,
                    child: userType != '2'
                        ? Material(
                            elevation: 5,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: Container(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: getShape(),
                                  elevation: getElevation(),
                                  foregroundColor: getColor(
                                      HexColor('#172543'), Colors.white),
                                  backgroundColor: getColor(
                                      Colors.white, HexColor('#172543')),
                                  // side: getBorder(HexColor('#172543'),
                                  //     HexColor('#172543')),
                                ),
                                onPressed: () {
                                  Get.to(
                                    InputSuitData(),
                                    //arguments: {'orderType': '3'}
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LineIcons.paste,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '맞춤복 상담',
                                      style: TextStyle(
                                          // fontFamily: 'Caveat',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                              shape: getShape(),
                              elevation: getElevation(),
                              foregroundColor:
                                  getColor(HexColor('#172543'), Colors.white),
                              backgroundColor:
                                  getColor(Colors.white, HexColor('#172543')),
                            ),
                            onPressed: () {
                              Get.to(
                                FactoryCost(),

                                //arguments: {'orderType': '3'}
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LineIcons.wonSign,
                                  size: 20,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '공임비 관리',
                                  style: TextStyle(
                                      // fontFamily: 'Caveat',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          )),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: Get.height * 0.15,
                  child: userType != '2'
                      ? Material(
                          elevation: 5,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: Container(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: getShape(),
                                elevation: getElevation(),
                                foregroundColor:
                                    getColor(HexColor('#172543'), Colors.white),
                                backgroundColor:
                                    getColor(Colors.white, HexColor('#172543')),
                              ),
                              onPressed: () {
                                Get.to(
                                  SearchPage(),
                                  //arguments: {'orderType': '3'}
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LineIcons.search,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '작업지시서 조회',
                                    style: TextStyle(
                                        // fontFamily: 'Caveat',

                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            shape: getShape(),
                            elevation: getElevation(),
                            foregroundColor:
                                getColor(HexColor('#172543'), Colors.white),
                            backgroundColor:
                                getColor(Colors.white, HexColor('#172543')),
                            side: getBorder(
                                HexColor('#172543'), HexColor('#172543')),
                          ),
                          onPressed: () {
                            if (GetPlatform.isWeb) {
                              failAlert('QR 스캔은 웹에서는 지원되지 않습니다.');
                            } else {
                              Get.to(
                                QrScannerPage(),
                                //arguments: {'orderType': '3'}
                              );
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LineIcons.qrcode,
                                size: 20,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'QR 스캐너',
                                style: TextStyle(
                                    // fontFamily: 'Caveat',

                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    'Qr Scan of Work Sheet',
                                    style: TextStyle(
                                        // fontFamily: 'Caveat',

                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10),
                                  )),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: Get.height * 0.15,
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: getShape(),
                          elevation: getElevation(),
                          foregroundColor:
                              getColor(HexColor('#172543'), Colors.white),
                          backgroundColor:
                              getColor(Colors.white, HexColor('#172543')),
                        ),
                        onPressed: () {
                          Get.to(
                            ProgressPage(),
                            //arguments: {'orderType': '3'}
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LineIcons.tasks,
                              size: 20,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '제작 현황',
                              style: TextStyle(
                                  // fontFamily: 'Caveat',

                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: Get.height * 0.15,
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: getShape(),
                          elevation: getElevation(),
                          foregroundColor:
                              getColor(HexColor('#172543'), Colors.white),
                          backgroundColor:
                              getColor(Colors.white, HexColor('#172543')),
                        ),
                        onPressed: () {
                          if (GetPlatform.isWeb) {
                            failAlert('QR 스캔은 웹에서는 지원되지 않습니다.');
                          } else {
                            Get.to(
                              QrScannerPage(),
                              //arguments: {'orderType': '3'}
                            );
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LineIcons.qrcode,
                              size: 20,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'QR 스캐너',
                              style: TextStyle(
                                  // fontFamily: 'Caveat',

                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget HomeMenuBottomWeb(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: getShape(),
                    elevation: getElevation(),
                    foregroundColor:
                        getColor(HexColor('#172543'), Colors.white),
                    backgroundColor:
                        getColor(Colors.white, HexColor('#172543')),
                  ),
                  onPressed: () {
                    Get.to(
                      CostList(),
                      //arguments: {'orderType': '3'}
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LineIcons.wonSign),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '공임비 관리',
                        style: TextStyle(
                            // fontFamily: 'Caveat',

                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: getShape(),
                    elevation: getElevation(),
                    foregroundColor:
                        getColor(HexColor('#172543'), Colors.white),
                    backgroundColor:
                        getColor(Colors.white, HexColor('#172543')),
                  ),
                  onPressed: () {
                    Get.to(
                      CalculatePage(),
                      //arguments: {'orderType': '3'}
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LineIcons.fileInvoice),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        userType == '1' ? '제품 판매 목록' : '제품 제작 목록',
                        style: TextStyle(
                            // fontFamily: 'Caveat',

                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: getShape(),
                    elevation: getElevation(),
                    foregroundColor:
                        getColor(HexColor('#172543'), Colors.white),
                    backgroundColor:
                        getColor(Colors.white, HexColor('#172543')),
                  ),
                  onPressed: () {
                    Get.to(

                        //OptionsSelect());
                        // ConsultStepChange());
                        PriceManage());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LineIcons.creditCard),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '결제 금액 관리',
                        style: TextStyle(
                            // fontFamily: 'Caveat',

                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: getShape(),
                    elevation: getElevation(),
                    foregroundColor:
                        getColor(HexColor('#172543'), Colors.white),
                    backgroundColor:
                        getColor(Colors.white, HexColor('#172543')),
                  ),
                  onPressed: () {
                    Get.to(
                        // CsvUpload(),
                        CustomerList()
                        //MembershipSearch()

                        //arguments: {'orderType': '3'}
                        );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LineIcons.userFriends),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '고객 관리',
                        style: TextStyle(
                            // fontFamily: 'Caveat',

                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget HomeMenuBottomMob(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: Get.height * 0.15,
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: getShape(),
                          elevation: getElevation(),
                          foregroundColor:
                              getColor(HexColor('#172543'), Colors.white),
                          backgroundColor:
                              getColor(Colors.white, HexColor('#172543')),
                        ),
                        onPressed: () {
                          Get.to(
                            CostList(),
                            //arguments: {'orderType': '3'}
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LineIcons.wonSign,
                              size: 20,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '공임비 관리',
                              style: TextStyle(
                                  // fontFamily: 'Caveat',

                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: Get.height * 0.15,
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: getShape(),
                          elevation: getElevation(),
                          foregroundColor:
                              getColor(HexColor('#172543'), Colors.white),
                          backgroundColor:
                              getColor(Colors.white, HexColor('#172543')),
                        ),
                        onPressed: () {
                          Get.to(
                            CalculatePage(),
                            //arguments: {'orderType': '3'}
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LineIcons.fileInvoice,
                              size: 20,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              userType == '1' ? '제품 판매 목록' : '제품 제작 목록',
                              style: TextStyle(
                                  // fontFamily: 'Caveat',

                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: Get.height * 0.15,
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: getShape(),
                          elevation: getElevation(),
                          foregroundColor:
                              getColor(HexColor('#172543'), Colors.white),
                          backgroundColor:
                              getColor(Colors.white, HexColor('#172543')),
                        ),
                        onPressed: () {
                          Get.to(

                              //OptionsSelect());
                              // ConsultStepChange());
                              PriceManage());
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LineIcons.creditCard,
                              size: 20,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '결제 금액 관리',
                              style: TextStyle(
                                  // fontFamily: 'Caveat',

                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: Get.height * 0.15,
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: getShape(),
                          elevation: getElevation(),
                          foregroundColor:
                              getColor(HexColor('#172543'), Colors.white),
                          backgroundColor:
                              getColor(Colors.white, HexColor('#172543')),
                        ),
                        onPressed: () {
                          Get.to(
                              // CsvUpload(),
                              CustomerList()
                              //MembershipSearch()

                              //arguments: {'orderType': '3'}
                              );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LineIcons.userFriends,
                              size: 20,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '고객 관리',
                              style: TextStyle(
                                  // fontFamily: 'Caveat',

                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    final getColor = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };

    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder(Color color, Color colorPressed) {
    final getBorder = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return BorderSide(color: colorPressed, width: 2);
      } else {
        return BorderSide(color: color, width: 2);
      }
    };

    return MaterialStateProperty.resolveWith(getBorder);
  }

  MaterialStateProperty<double> getElevation() {
    final getElevation = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return 10.0;
      } else {
        return 0.0;
      }
    };

    return MaterialStateProperty.resolveWith(getElevation);
  }

  MaterialStateProperty<OutlinedBorder> getShape() {
    final getShape = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
      } else {
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
      }
    };

    return MaterialStateProperty.resolveWith(getShape);
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(6, (i) {
      final isTouched = i == touchedIndex1;
      final fontSize = isTouched ? 14.0 : 12.0;
      final radius = isTouched ? 45.0 : 40.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: mainColor,
            value: visitRoute[0],
            title: '${(visitRoute[0] / visitCount) * 100}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: mainColor.withOpacity(0.85),
            value: visitRoute[1],
            title: '${(visitRoute[1] / visitCount) * 100}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: mainColor.withOpacity(0.70),
            value: visitRoute[2],
            title: '${(visitRoute[2] / visitCount) * 100}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: mainColor.withOpacity(0.55),
            value: visitRoute[3],
            title: '${(visitRoute[3] / visitCount) * 100}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: mainColor.withOpacity(0.40),
            value: visitRoute[4],
            title: '${(visitRoute[4] / visitCount) * 100}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 5:
          return PieChartSectionData(
            color: mainColor.withOpacity(0.25),
            value: visitRoute[5],
            title: '${(visitRoute[5] / visitCount) * 100}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        default:
          throw Error();
      }
    });
  }

  List<PieChartSectionData> showingVisitCount() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 14.0 : 12.0;
      final radius = isTouched ? 45.0 : 40.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: mainColor.withOpacity(0.25),
            value: visitRate[0],
            title: '${(visitRoute[0] / visit) * 100}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: mainColor.withOpacity(0.75),
            value: visitRate[1],
            title: '${(visitRate[1] / visit) * 100}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        default:
          throw Error();
      }
    });
  }

  Widget getTitles(double value, TitleMeta meta) {
    var style =
        TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = '상담완료';
        break;
      case 1:
        text = '가봉중';
        break;
      case 2:
        text = '제작중';
        break;

      default:
        text = '제작완료';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5.0,
      child: Column(
        children: [
          Text(text, style: style),
          SizedBox(
            height: 5,
          ),
          Text('${produceList[value.toInt()]} 벌', style: style),
        ],
      ),
    );
  }

  final List<DataItem> _myData = List.generate(
    4,
    (index) => DataItem(
      x: (index),

      // y3: Random().nextInt(20) + Random().ne
      //
      // xtDouble(),
    ),
  );
}
