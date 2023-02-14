import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/number_format.dart';
import 'package:bykak/src/components/responsive.dart';
import 'package:bykak/src/model/tailorShop/schedule_model.dart';
import 'package:bykak/src/pages/schedule_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleManage extends StatefulWidget {
  const ScheduleManage({Key? key}) : super(key: key);

  @override
  State<ScheduleManage> createState() => _ScheduleManageState();
}

class _ScheduleManageState extends State<ScheduleManage> {
  String _currentYearMonth = "";
  String _searchYearMonth = "";
  Map<DateTime, List<Schedule>> selectedEvents = {};
  DateTime selectedDate = DateTime.now();
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentYearMonth = DateTime.now().toString().substring(0, 10);
    _searchYearMonth = _currentYearMonth.substring(0, 7);

    selectedEvents = {};
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    makeDateList(_searchYearMonth);
  }

  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();
    dateList = [];
    dateListGroup = [];
    selectedEvents = {};
    scheduleList = [];
  }

  List<String> orderType = ['수트', '자켓', '셔츠', '바지', '조끼', '코트'];
  List<Schedule> _getSchedule(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  String tailorShop = "";
  List dateList = [];
  List dateListGroup = [];

  makeDateList(String searchYearMonth) {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    dateList = [];
    String dayVal = "";
    for (var i = 1; i < 32; i++) {
      if (i < 10) {
        dayVal = '0' + i.toString();
      } else {
        dayVal = i.toString();
      }
      dateList.add(searchYearMonth + '-' + dayVal);
    }
    selectedEvents = {};
    scheduleList = [];
    getData(dateList);
  }

  List<Schedule> scheduleList = [];

  getData(List searchDateList) async {
    // firestroe whereIn 조건 검색 시, 최대 10개의 데이터만 비교 가능하다
    dateListGroup.add(searchDateList.sublist(0, 10));
    dateListGroup.add(searchDateList.sublist(10, 20));
    dateListGroup.add(searchDateList.sublist(20, 30));
    dateListGroup.add(searchDateList.sublist(30, 31));

    int gabongCnt = 0;
    int dataCnt = 0;
    bool gabingTimeFix = false;
    bool finishTimeFix = false;
    tailorShop = await getUserData();
    try {
      for (var i = 0; i < dateListGroup.length; i++) {
        var gabongResult = await firestore
            .collection('orders')
            .where('storeName', isEqualTo: tailorShop)
            .where('gabong', whereIn: dateListGroup[i])
            .orderBy('gabongTime', descending: true)
            .get();

        for (var doc in gabongResult.docs) {
          try {
            if (doc['gabongTime'].toString().length > 1 &&
                doc['gabongTime'] != null) {
              setState(() {
                gabingTimeFix = true;
              });
            } else {
              setState(() {
                gabingTimeFix = false;
              });
            }
          } catch (e) {
            setState(() {
              gabingTimeFix = false;
            });
          }
          if (!gabingTimeFix) {
            setState(
              () {
                try {
                  if (selectedEvents[DateTime.utc(
                        int.parse(doc['gabong'].toString().substring(0, 4)),
                        int.parse(doc['gabong'].toString().substring(5, 7)),
                        int.parse(doc['gabong'].toString().substring(8, 10)),
                      )] !=
                      null) {
                    selectedEvents[DateTime.utc(
                      int.parse(doc['gabong'].toString().substring(0, 4)),
                      int.parse(doc['gabong'].toString().substring(5, 7)),
                      int.parse(doc['gabong'].toString().substring(8, 10)),
                    )]
                        ?.add(Schedule(
                            doc['orderNo'],
                            '',
                            doc['name'],
                            doc['productUse'],
                            doc['orderType'],
                            '',
                            '',
                            '',
                            'G',
                            '00:00',
                            'N', [], []));
                  } else {
                    scheduleList = [];
                    scheduleList.add(Schedule(
                        doc['orderNo'],
                        '',
                        doc['name'],
                        doc['productUse'],
                        doc['orderType'],
                        '',
                        '',
                        '',
                        'G',
                        '00:00',
                        'N', [], []));
                    selectedEvents[DateTime.utc(
                            int.parse(doc['gabong'].toString().substring(0, 4)),
                            int.parse(doc['gabong'].toString().substring(5, 7)),
                            int.parse(
                                doc['gabong'].toString().substring(8, 10)))] =
                        scheduleList;
                  }
                } catch (e) {
                  print(e);
                }
              },
            );
          } else {
            setState(() {
              try {
                if (selectedEvents[DateTime.utc(
                      int.parse(doc['gabong'].toString().substring(0, 4)),
                      int.parse(doc['gabong'].toString().substring(5, 7)),
                      int.parse(doc['gabong'].toString().substring(8, 10)),
                    )] !=
                    null) {
                  selectedEvents[DateTime.utc(
                    int.parse(doc['gabong'].toString().substring(0, 4)),
                    int.parse(doc['gabong'].toString().substring(5, 7)),
                    int.parse(doc['gabong'].toString().substring(8, 10)),
                  )]
                      ?.add(Schedule(
                          doc['orderNo'],
                          '',
                          doc['name'],
                          doc['productUse'],
                          doc['orderType'],
                          '',
                          '',
                          '',
                          'G',
                          doc['gabongTime'],
                          'Y', [], []));
                } else {
                  scheduleList = [];
                  scheduleList.add(Schedule(
                      doc['orderNo'],
                      '',
                      doc['name'],
                      doc['productUse'],
                      doc['orderType'],
                      '',
                      '',
                      '',
                      'G',
                      doc['gabongTime'],
                      'Y', [], []));
                  selectedEvents[DateTime.utc(
                          int.parse(doc['gabong'].toString().substring(0, 4)),
                          int.parse(doc['gabong'].toString().substring(5, 7)),
                          int.parse(
                              doc['gabong'].toString().substring(8, 10)))] =
                      scheduleList;
                }
              } catch (e) {
                print(e);
              }
            });
          }
        }
      }

      for (var i = 0; i < dateListGroup.length; i++) {
        var finishResult = await firestore
            .collection('orders')
            .where('storeName', isEqualTo: tailorShop)
            .where('finishDate', whereIn: dateListGroup[i])
            // .orderBy('finishTime', descending: true)
            .get();

        for (var doc in finishResult.docs) {
          try {
            if (doc['finishTime'].toString().length > 1 &&
                doc['finishTime'] != null) {
              setState(() {
                finishTimeFix = true;
              });
            } else {
              setState(() {
                finishTimeFix = false;
              });
            }
          } catch (e) {
            setState(() {
              finishTimeFix = false;
            });
          }
          if (!finishTimeFix) {
            setState(() {
              try {
                if (selectedEvents[DateTime.utc(
                      int.parse(doc['finishDate'].toString().substring(0, 4)),
                      int.parse(doc['finishDate'].toString().substring(5, 7)),
                      int.parse(doc['finishDate'].toString().substring(8, 10)),
                    )] !=
                    null) {
                  selectedEvents[DateTime.utc(
                    int.parse(doc['finishDate'].toString().substring(0, 4)),
                    int.parse(doc['finishDate'].toString().substring(5, 7)),
                    int.parse(doc['finishDate'].toString().substring(8, 10)),
                  )]
                      ?.add(Schedule(
                          doc['orderNo'],
                          '',
                          doc['name'],
                          doc['productUse'],
                          doc['orderType'],
                          '',
                          '',
                          '',
                          'C',
                          '00:00',
                          'N', [], []));
                } else {
                  scheduleList = [];
                  scheduleList.add(Schedule(
                      doc['orderNo'],
                      '',
                      doc['name'],
                      doc['productUse'],
                      doc['orderType'],
                      '',
                      '',
                      '',
                      'C',
                      '00:00',
                      'N', [], []));
                  selectedEvents[DateTime.utc(
                      int.parse(doc['finishDate'].toString().substring(0, 4)),
                      int.parse(doc['finishDate'].toString().substring(5, 7)),
                      int.parse(doc['finishDate']
                          .toString()
                          .substring(8, 10)))] = scheduleList;
                }
              } catch (e) {
                print(e);
              }
            });
          } else {
            setState(() {
              try {
                if (selectedEvents[DateTime.utc(
                      int.parse(doc['finishDate'].toString().substring(0, 4)),
                      int.parse(doc['finishDate'].toString().substring(5, 7)),
                      int.parse(doc['finishDate'].toString().substring(8, 10)),
                    )] !=
                    null) {
                  selectedEvents[DateTime.utc(
                    int.parse(doc['finishDate'].toString().substring(0, 4)),
                    int.parse(doc['finishDate'].toString().substring(5, 7)),
                    int.parse(doc['finishDate'].toString().substring(8, 10)),
                  )]
                      ?.add(Schedule(
                          doc['orderNo'],
                          '',
                          doc['name'],
                          doc['productUse'],
                          doc['orderType'],
                          '',
                          '',
                          '',
                          'C',
                          doc['finishTime'],
                          'Y', [], []));
                } else {
                  scheduleList = [];
                  scheduleList.add(Schedule(
                      doc['orderNo'],
                      '',
                      doc['name'],
                      doc['productUse'],
                      doc['orderType'],
                      '',
                      '',
                      '',
                      'C',
                      doc['finishTime'],
                      'Y', [], []));
                  selectedEvents[DateTime.utc(
                      int.parse(doc['finishDate'].toString().substring(0, 4)),
                      int.parse(doc['finishDate'].toString().substring(5, 7)),
                      int.parse(doc['finishDate']
                          .toString()
                          .substring(8, 10)))] = scheduleList;
                }
              } catch (e) {
                print(e);
              }
            });
          }
        }
      }

      scheduleList.sort((a, b) =>
          int.parse(a.visitTime.toString().replaceAll(':', '')).compareTo(
              int.parse(b.visitTime.toString().replaceAll(':', ''))));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          '일정 관리',
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
          : Responsive.isMobile(context)
              ? SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: TableCalendar(
                            calendarBuilders: CalendarBuilders(
                              markerBuilder: (context, day, events) =>
                                  events.isNotEmpty
                                      ? Container(
                                          width: 15,
                                          height: 15,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: mainColor,
                                          ),
                                          child: Text(
                                            '${events.length}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        )
                                      : null,
                            ),
                            // calendarBuilders: CalendarBuilders(
                            //   singleMarkerBuilder: (context, date, Schedule s) {
                            //     return Container(
                            //       decoration: BoxDecoration(
                            //           shape: BoxShape.circle,
                            //           color: s.visitType == 'G'
                            //               ? Colors.green
                            //               : Colors.blue), //Change color
                            //       width: 5.0,
                            //       height: 5.0,
                            //       margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            //     );
                            //   },
                            // ),
                            selectedDayPredicate: (DateTime date) {
                              return isSameDay(selectedDate, date);
                            },
                            calendarStyle: CalendarStyle(
                                isTodayHighlighted: true,
                                selectedTextStyle:
                                    TextStyle(color: Colors.white),
                                selectedDecoration: BoxDecoration(
                                    color: Colors.purpleAccent,
                                    shape: BoxShape.circle),
                                todayDecoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                )),
                            eventLoader: _getSchedule,
                            daysOfWeekHeight: 50,
                            currentDay: DateTime.now(),
                            headerStyle: HeaderStyle(
                                headerMargin:
                                    EdgeInsets.only(left: 20, right: 20),
                                titleCentered: true,
                                formatButtonVisible: false,
                                titleTextStyle:
                                    const TextStyle(fontSize: 17.0)),
                            locale: 'ko_KR',
                            firstDay: DateTime.utc(2000, 1, 1),
                            lastDay: DateTime.utc(2099, 12, 31),
                            focusedDay: DateTime.parse(_currentYearMonth),
                            onPageChanged: (d) {
                              setState(() {
                                _currentYearMonth =
                                    d.toString().substring(0, 10);
                                dateList = [];
                                dateListGroup = [];
                                selectedEvents = {};
                                scheduleList = [];
                                _isLoading = true;
                              });
                              _searchYearMonth =
                                  _currentYearMonth.substring(0, 7);

                              makeDateList(_searchYearMonth);
                            },
                            onDaySelected:
                                (DateTime selectedDay, DateTime focusedDay) {
                              setState(() {
                                selectedDate = selectedDay;
                              });
                              //print(_month);
                            },
                          ),
                        ),
                        Container(
                          height: 5,
                          color: Colors.black12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 30,
                                  child: Text(
                                    '일정목록',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 10,
                                              width: 10,
                                              color: Colors.green,
                                            ),
                                            Text(
                                              ' 가봉 예정일',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width: 10,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  ' 가봉 확정일',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 10,
                                              width: 10,
                                              color: Colors.blue,
                                            ),
                                            Text(
                                              ' 완성 예정일',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width: 10,
                                                  color: Colors.red,
                                                ),
                                                Text(
                                                  ' 완성 확정일',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        ..._getSchedule(selectedDate).map(
                          (Schedule s) => Column(
                            children: [
                              ListTile(
                                title: Container(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InkWell(
                                    onTap: () {
                                      !Responsive.isMobile(context)
                                          ? Get.to(ScheduleDetail(),
                                              arguments: {
                                                  // 'data': totalList[index],
                                                  'orderNo': s.orderNo,
                                                  'visitType': s.visitType,
                                                })
                                          : Get.to(ScheduleDetail(),
                                              arguments: {
                                                  // 'data': totalList[index],
                                                  'orderNo': s.orderNo,
                                                  'visitType': s.visitType,
                                                });
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                width: 5,
                                                height: 20,
                                                color: s.visitType == "G"
                                                    ? s.fixYn == "N"
                                                        ? Colors.green
                                                        : Colors.black
                                                    : s.fixYn == "N"
                                                        ? Colors.blue
                                                        : Colors.red),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  s.orderNo.toString(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Text(
                                                  s.customerName.toString(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      orderType[int.parse(s
                                                          .orderType
                                                          .toString())],
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      s.visitType.toString() ==
                                                              "G"
                                                          ? s.fixYn == "N"
                                                              ? '가봉 예정'
                                                              : '가봉 확정'
                                                          : s.fixYn == "N"
                                                              ? '완성 피팅 예정'
                                                              : '완성 피팅 확정',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            s.visitTime.toString(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: Get.width * 0.5,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: TableCalendar(
                                  calendarBuilders: CalendarBuilders(
                                    markerBuilder: (context, day, events) =>
                                        events.isNotEmpty
                                            ? Container(
                                                width: 15,
                                                height: 15,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: mainColor,
                                                ),
                                                child: Text(
                                                  '${events.length}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              )
                                            : null,
                                  ),
                                  // calendarBuilders: CalendarBuilders(
                                  //   singleMarkerBuilder: (context, date, Schedule s) {
                                  //     return Container(
                                  //       decoration: BoxDecoration(
                                  //           shape: BoxShape.circle,
                                  //           color: s.visitType == 'G'
                                  //               ? Colors.green
                                  //               : Colors.blue), //Change color
                                  //       width: 5.0,
                                  //       height: 5.0,
                                  //       margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                  //     );
                                  //   },
                                  // ),
                                  selectedDayPredicate: (DateTime date) {
                                    return isSameDay(selectedDate, date);
                                  },
                                  calendarStyle: CalendarStyle(
                                      isTodayHighlighted: true,
                                      selectedTextStyle:
                                          TextStyle(color: Colors.white),
                                      selectedDecoration: BoxDecoration(
                                          color: Colors.purpleAccent,
                                          shape: BoxShape.circle),
                                      todayDecoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      )),
                                  eventLoader: _getSchedule,
                                  daysOfWeekHeight: 50,
                                  currentDay: DateTime.now(),
                                  headerStyle: HeaderStyle(
                                      headerMargin:
                                          EdgeInsets.only(left: 20, right: 20),
                                      titleCentered: true,
                                      formatButtonVisible: false,
                                      titleTextStyle:
                                          const TextStyle(fontSize: 17.0)),
                                  locale: 'ko_KR',
                                  firstDay: DateTime.utc(2000, 1, 1),
                                  lastDay: DateTime.utc(2099, 12, 31),
                                  focusedDay: DateTime.parse(_currentYearMonth),
                                  onPageChanged: (d) {
                                    setState(() {
                                      _currentYearMonth =
                                          d.toString().substring(0, 10);
                                      dateList = [];
                                      dateListGroup = [];
                                      selectedEvents = {};
                                      scheduleList = [];
                                      _isLoading = true;
                                    });
                                    _searchYearMonth =
                                        _currentYearMonth.substring(0, 7);

                                    makeDateList(_searchYearMonth);
                                  },
                                  onDaySelected: (DateTime selectedDay,
                                      DateTime focusedDay) {
                                    setState(() {
                                      selectedDate = selectedDay;
                                    });
                                    //print(_month);
                                  },
                                ),
                              ),
                              Container(
                                height: 5,
                                color: Colors.black12,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Text(
                                          '일정목록',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 10,
                                                    width: 10,
                                                    color: Colors.green,
                                                  ),
                                                  Text(
                                                    ' 가봉 예정일',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 10,
                                                        width: 10,
                                                        color: Colors.black,
                                                      ),
                                                      Text(
                                                        ' 가봉 확정일',
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 10,
                                                    width: 10,
                                                    color: Colors.blue,
                                                  ),
                                                  Text(
                                                    ' 완성 예정일',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 10,
                                                        width: 10,
                                                        color: Colors.red,
                                                      ),
                                                      Text(
                                                        ' 완성 확정일',
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              ..._getSchedule(selectedDate).map(
                                (Schedule s) => Column(
                                  children: [
                                    ListTile(
                                      title: Container(
                                          child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: InkWell(
                                          onTap: () {
                                            !Responsive.isMobile(context)
                                                ? Get.to(ScheduleDetail(),
                                                    arguments: {
                                                        // 'data': totalList[index],
                                                        'orderNo': s.orderNo,
                                                        'visitType':
                                                            s.visitType,
                                                      })
                                                : Get.to(ScheduleDetail(),
                                                    arguments: {
                                                        // 'data': totalList[index],
                                                        'orderNo': s.orderNo,
                                                        'visitType':
                                                            s.visitType,
                                                      });
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      width: 5,
                                                      height: 20,
                                                      color: s.visitType == "G"
                                                          ? s.fixYn == "N"
                                                              ? Colors.green
                                                              : Colors.black
                                                          : s.fixYn == "N"
                                                              ? Colors.blue
                                                              : Colors.red),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        s.orderNo.toString(),
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        s.customerName
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            orderType[int.parse(s
                                                                .orderType
                                                                .toString())],
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                            s.visitType.toString() ==
                                                                    "G"
                                                                ? s.fixYn == "N"
                                                                    ? '가봉 예정'
                                                                    : '가봉 확정'
                                                                : s.fixYn == "N"
                                                                    ? '완성 피팅 예정'
                                                                    : '완성 피팅 확정',
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Align(
                                                alignment: Alignment.topCenter,
                                                child: Text(
                                                  s.visitTime.toString(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
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
}
