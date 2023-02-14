import 'dart:math';

import 'package:bykak/src/components/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bykak/src/components/indicator_model.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

// Define data structure for a bar group
class DataItem {
  int x;
  double y1;
  double y2;
  // double y3;
  DataItem({
    required this.x,
    required this.y1,
    required this.y2,
    // /, required this.y2, required this.y3
  });
}

class DataItem1 {
  int x;
  double y1;
  double y2;
  // double y3;
  DataItem1({required this.x, required this.y1, required this.y2
      // /, required this.y2, required this.y3
      });
}

class _DashboardPageState extends State<DashboardPage> {
  int touchedIndex = -1;
  int touchedIndex1 = -1;
  final List<DataItem> _myData = List.generate(
      12,
      (index) => DataItem(
            x: (index),
            y1: Random().nextInt(20) + Random().nextDouble(),
            y2: Random().nextInt(20) + Random().nextDouble(),
            // y3: Random().nextInt(20) + Random().ne
            //
            // xtDouble(),
          ));

  final List<DataItem1> _myData1 = List.generate(
      9,
      (index) => DataItem1(
            x: (index + 1) * 10,
            y1: Random().nextInt(20) + Random().nextDouble(),
            y2: Random().nextInt(20) + Random().nextDouble(),
            // y3: Random().nextInt(20) + Random().nextDouble(),
          ));

  var widthVal = 0.0;

  @override
  Widget build(BuildContext context) {
    widthVal = MediaQuery.of(context).size.width;
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black),
          ),
          elevation: 2,
          title: Text(
            '통계 페이지',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '고객분석',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '방문 총 고객수',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      '233 명',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(),
                                      flex: 2,
                                    ),
                                    Expanded(
                                      child: Container(),
                                      flex: 2,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 300,
                                        padding: EdgeInsets.only(
                                          right: 20,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '연령별 방문 고객',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              height: 250,
                                              child: BarChart(
                                                BarChartData(
                                                  titlesData: FlTitlesData(
                                                    leftTitles: AxisTitles(),
                                                    rightTitles: AxisTitles(),
                                                    //  bottomTitles: AxisTitles(),
                                                    topTitles: AxisTitles(),
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
                                                  barGroups: _myData1
                                                      .map((dataItem) =>
                                                          BarChartGroupData(
                                                              x: dataItem.x,
                                                              barRods: [
                                                                BarChartRodData(
                                                                    toY:
                                                                        dataItem
                                                                            .y1,
                                                                    width: 10,
                                                                    color: Colors
                                                                        .amber),
                                                                BarChartRodData(
                                                                    toY:
                                                                        dataItem
                                                                            .y2,
                                                                    width: 10,
                                                                    color: Colors
                                                                        .red),
                                                                // BarChartRodData(
                                                                //     toY: dataItem.y3, width: 10, color: Colors.blue),
                                                              ]))
                                                      .toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      // ignore: sort_child_properties_last
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20, top: 50),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '매장 방문 성별 통계',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                SizedBox(
                                                  height: 300,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: PieChart(
                                                          PieChartData(
                                                              pieTouchData: PieTouchData(
                                                                  touchCallback:
                                                                      (FlTouchEvent
                                                                              event,
                                                                          pieTouchResponse) {
                                                                setState(() {
                                                                  if (!event
                                                                          .isInterestedForInteractions ||
                                                                      pieTouchResponse ==
                                                                          null ||
                                                                      pieTouchResponse
                                                                              .touchedSection ==
                                                                          null) {
                                                                    touchedIndex1 =
                                                                        -1;
                                                                    return;
                                                                  }
                                                                  touchedIndex1 =
                                                                      pieTouchResponse
                                                                          .touchedSection!
                                                                          .touchedSectionIndex;
                                                                });
                                                              }),
                                                              borderData:
                                                                  FlBorderData(
                                                                show: false,
                                                              ),
                                                              sectionsSpace: 0,
                                                              centerSpaceRadius:
                                                                  30,
                                                              sections:
                                                                  showingSections2()),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 50,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          //mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const <
                                                              Widget>[
                                                            Indicator(
                                                              color: Color(
                                                                  0xff0293ee),
                                                              text: '남성',
                                                              isSquare: true,
                                                              size: 10,
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Indicator(
                                                              color: Color(
                                                                  0xfff8b250),
                                                              text: '여성',
                                                              isSquare: true,
                                                              size: 10,
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            SizedBox(
                                                              height: 18,
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
                                        ],
                                      ),
                                      flex: 2,
                                    ),
                                    Expanded(
                                      // ignore: sort_child_properties_last
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20, top: 50),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '방문 경로 통계',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                SizedBox(
                                                  height: 300,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: PieChart(
                                                          PieChartData(
                                                              pieTouchData: PieTouchData(
                                                                  touchCallback:
                                                                      (FlTouchEvent
                                                                              event,
                                                                          pieTouchResponse) {
                                                                setState(() {
                                                                  if (!event
                                                                          .isInterestedForInteractions ||
                                                                      pieTouchResponse ==
                                                                          null ||
                                                                      pieTouchResponse
                                                                              .touchedSection ==
                                                                          null) {
                                                                    touchedIndex =
                                                                        -1;
                                                                    return;
                                                                  }
                                                                  touchedIndex =
                                                                      pieTouchResponse
                                                                          .touchedSection!
                                                                          .touchedSectionIndex;
                                                                });
                                                              }),
                                                              borderData:
                                                                  FlBorderData(
                                                                show: false,
                                                              ),
                                                              sectionsSpace: 0,
                                                              centerSpaceRadius:
                                                                  30,
                                                              sections:
                                                                  showingSections()),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 50,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          //mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const <
                                                              Widget>[
                                                            Indicator(
                                                              color: Color(
                                                                  0xff0293ee),
                                                              text: '네이버(블로그)',
                                                              isSquare: true,
                                                              size: 10,
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Indicator(
                                                              color: Color(
                                                                  0xfff8b250),
                                                              text: 'SNS',
                                                              isSquare: true,
                                                              size: 10,
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Indicator(
                                                              color: Color(
                                                                  0xff845bef),
                                                              text: '유튜브',
                                                              isSquare: true,
                                                              size: 10,
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Indicator(
                                                              color: Color(
                                                                  0xff13d38e),
                                                              text: '지인소개',
                                                              isSquare: true,
                                                              size: 10,
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Indicator(
                                                              color: Color(
                                                                  0xffd5bfeb),
                                                              text: '웨딩업체',
                                                              isSquare: true,
                                                              size: 10,
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Indicator(
                                                              color: Color(
                                                                  0xffe8764e),
                                                              text: '기타',
                                                              isSquare: true,
                                                              size: 10,
                                                            ),
                                                            SizedBox(
                                                              height: 18,
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
                                        ],
                                      ),
                                      flex: 2,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 10,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '월별 판매량 및 매출액',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    SizedBox(
                                      height: 300,
                                      child: BarChart(
                                        BarChartData(
                                          titlesData: FlTitlesData(
                                            show: true,
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 30,
                                                getTitlesWidget: getTitles,
                                              ),
                                            ),
                                            leftTitles: AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                            topTitles: AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                            rightTitles: AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
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
                                                  BarChartGroupData(
                                                      x: dataItem.x,
                                                      barRods: [
                                                        BarChartRodData(
                                                            toY: dataItem.y1,
                                                            width:
                                                                widthVal < 850
                                                                    ? 5
                                                                    : 10,
                                                            color:
                                                                Colors.amber),
                                                        BarChartRodData(
                                                            toY: dataItem.y2,
                                                            width:
                                                                widthVal < 850
                                                                    ? 5
                                                                    : 10,
                                                            color: Colors.blue),
                                                        // BarChartRodData(
                                                        //     toY: dataItem.y3, width: 10, color: Colors.blue),
                                                      ]))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //if (Responsive.isMobile(context))
                          //
                        ],
                      ),
                    ),
                    // child: Container(
                    //   color: Colors.redAccent,
                    //   child: Text('bbb'),
                    // ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 10,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '제품별 판매량 추이',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    SizedBox(
                                      height: 300,
                                      child: BarChart(
                                        BarChartData(
                                          titlesData: FlTitlesData(
                                            leftTitles: AxisTitles(),
                                            rightTitles: AxisTitles(),
                                            //  bottomTitles: AxisTitles(),
                                            topTitles: AxisTitles(),
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
                                                  BarChartGroupData(
                                                      x: dataItem.x,
                                                      barRods: [
                                                        BarChartRodData(
                                                            toY: dataItem.y1,
                                                            width:
                                                                widthVal < 850
                                                                    ? 5
                                                                    : 10,
                                                            color:
                                                                Colors.amber),
                                                        BarChartRodData(
                                                            toY: dataItem.y2,
                                                            width:
                                                                widthVal < 850
                                                                    ? 5
                                                                    : 10,
                                                            color: Colors.blue),
                                                        // BarChartRodData(
                                                        //     toY: dataItem.y3, width: 10, color: Colors.blue),
                                                      ]))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //if (Responsive.isMobile(context))
                          //
                        ],
                      ),
                    ),
                    // child: Container(
                    //   color: Colors.redAccent,
                    //   child: Text('bbb'),
                    // ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget getTitles(double value, TitleMeta meta) {
    widthVal = MediaQuery.of(context).size.width;
    var style = TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: widthVal < 850 ? 12 : 14);
    String text;
    switch (value.toInt()) {
      case 0:
        text = '1월';
        break;
      case 1:
        text = '2월';
        break;
      case 2:
        text = '3월';
        break;
      case 3:
        text = '4월';
        break;
      case 4:
        text = '5월';
        break;
      case 5:
        text = '6월';
        break;
      case 6:
        text = '7월';
        break;
      case 7:
        text = '8월';
        break;
      case 8:
        text = '9월';
        break;
      case 9:
        text = '10월';
        break;
      case 10:
        text = '11월';
        break;
      default:
        text = '12월';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4.0,
      child: Text(text, style: style),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(6, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 25,
            title: '25%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: const Color(0xffd5bfeb),
            value: 10,
            title: '10%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 5:
          return PieChartSectionData(
            color: const Color(0xffe8764e),
            value: 5,
            title: '5%',
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

  List<PieChartSectionData> showingSections2() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex1;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 93,
            title: '93%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 7,
            title: '7%',
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
}
