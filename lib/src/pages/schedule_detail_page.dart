import 'package:bykak/src/components/alert_fucntion.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/components/responsive.dart';
import 'package:bykak/src/pages/result_page.dart';
import 'package:bykak/src/pages/result_page_web.dart';
import 'package:bykak/src/pages/schedule_manage_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ScheduleDetail extends StatefulWidget {
  ScheduleDetail({Key? key}) : super(key: key);

  @override
  State<ScheduleDetail> createState() => _ScheduleDetailState();
}

class _ScheduleDetailState extends State<ScheduleDetail> {
  String name = Get.arguments['name'];
  String phone = Get.arguments['phone'];
  String consultDate = Get.arguments['consultDate'];
  String visitFixedDate = "클릭하세요";
  final _bigoController = TextEditingController();

  bool _isLoading = true;
  bool _showHistory = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        _showHistory = false;
      });
    });
    _recieveData();
    _getHistoryList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bigoController.dispose();
    super.dispose();
  }

  String _chosenValue = "";
  final List processList = [];
  //조회된 주문번호로 데이터 가져오기
  void _recieveData() async {
    final firestore = FirebaseFirestore.instance;
    var doc;

    //processList = [];
    var resultData = await firestore
        .collection('orders')
        //.where('orderNo', isEqualTo: orderNo)
        .get();

    for (doc in resultData.docs) {
      setState(() {
        processList.add(doc);
      });
    }

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: mainColor,
          onPressed: () async {
            if (processList[0]['phone'].toString().length > 9) {
              String url = 'tel:+82$phone';
              final parseUrl = Uri.parse(url);
              if (await canLaunchUrl(parseUrl)) {
                await launchUrl(
                  parseUrl,
                );
              }
            } else {
              failAlert("작업지시서의 연락처를 확인하세요.");
            }
          },
          child: Icon(Icons.phone),
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black),
          ),
          elevation: 2,
          title: Text(
            '고객 문의 상세',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        body: Responsive.isMobile(context)
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
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SingleChildScrollView(
                              child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 30, 30, 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        '님',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 30, 30, 10),
                                ),
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                //   child: Column(
                                //     children: [
                                //       Row(
                                //         mainAxisAlignment: Get.width <= 600
                                //             ? MainAxisAlignment.spaceBetween
                                //             : MainAxisAlignment.spaceAround,
                                //         children: [
                                //           Column(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: [
                                //               SizedBox(
                                //                 height: 10,
                                //               ),
                                //               Container(
                                //                 width: Get.width <= 600
                                //                     ? 120
                                //                     : Get.width * 0.3,
                                //                 height: 40,
                                //                 alignment: Alignment.center,
                                //                 decoration: BoxDecoration(
                                //                     border: Border.all(
                                //                         color: Colors.black,
                                //                         style:
                                //                             BorderStyle.solid,
                                //                         width: 1),
                                //                     borderRadius:
                                //                         BorderRadius.circular(
                                //                             20)),
                                //               )
                                //             ],
                                //           ),
                                //           Icon(Icons.arrow_forward_ios),
                                //           Column(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: [
                                //               SizedBox(
                                //                 height: 10,
                                //               ),
                                //               InkWell(
                                //                 borderRadius:
                                //                     BorderRadius.circular(20),
                                //                 onTap: () {
                                //                   showDatePickerPopEnd();
                                //                 },
                                //                 child: Container(
                                //                   width: Get.width <= 600
                                //                       ? 120
                                //                       : Get.width * 0.3,
                                //                   height: 40,
                                //                   alignment: Alignment.center,
                                //                   decoration: BoxDecoration(
                                //                       border: Border.all(
                                //                           color: Colors.black,
                                //                           style:
                                //                               BorderStyle.solid,
                                //                           width: 1),
                                //                       borderRadius:
                                //                           BorderRadius.circular(
                                //                               20)),
                                //                   child: Text(visitFixedDate),
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // Center(
                                //   child: Padding(
                                //     padding: const EdgeInsets.fromLTRB(
                                //         30, 10, 30, 0),
                                //     child: Container(
                                //       height: 50,
                                //       child: InkWell(
                                //         child: Row(
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             Text(
                                //               '방문시간 선택',
                                //               style: TextStyle(
                                //                   fontWeight: FontWeight.w600,
                                //                   fontSize: 14),
                                //             ),
                                //             SizedBox(
                                //               width: 5,
                                //             ),
                                //             Icon(_viewTimeTable
                                //                 ? Icons.keyboard_arrow_up
                                //                 : Icons.keyboard_arrow_down),
                                //           ],
                                //         ),
                                //         onTap: () {
                                //           setState(() {
                                //             if (_viewTimeTable == true) {
                                //               _viewTimeTable = false;
                                //             } else {
                                //               _viewTimeTable = true;
                                //             }
                                //           });
                                //         },
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // _viewTimeTable
                                //     ? Center(
                                //         child: Container(
                                //           width: MediaQuery.of(context)
                                //                   .size
                                //                   .width *
                                //               0.8,
                                //           child: Column(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: [
                                //               Text('오전'),
                                //               SizedBox(
                                //                 height: 10,
                                //               ),
                                //               Container(
                                //                 height: 0.5,
                                //                 color: Colors.black,
                                //               ),
                                //               SizedBox(
                                //                 height: 10,
                                //               ),
                                //               Row(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.start,
                                //                 children: [
                                //                   customRadioTime(
                                //                       timeList[0], 0),
                                //                   customRadioTime(
                                //                       timeList[1], 1),
                                //                   customRadioTime(
                                //                       timeList[2], 2),
                                //                   customRadioTime(
                                //                       timeList[3], 3),
                                //                 ],
                                //               ),
                                //               SizedBox(
                                //                 height: 10,
                                //               ),
                                //               Text('오후'),
                                //               SizedBox(
                                //                 height: 10,
                                //               ),
                                //               Container(
                                //                 height: 0.5,
                                //                 color: Colors.black,
                                //               ),
                                //               SizedBox(
                                //                 height: 10,
                                //               ),
                                //               Row(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.start,
                                //                 children: [
                                //                   customRadioTime(
                                //                       timeList[4], 4),
                                //                   customRadioTime(
                                //                       timeList[5], 5),
                                //                   customRadioTime(
                                //                       timeList[6], 6),
                                //                   customRadioTime(
                                //                       timeList[7], 7),
                                //                 ],
                                //               ),
                                //               SizedBox(
                                //                 height: 10,
                                //               ),
                                //               Row(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.start,
                                //                 children: [
                                //                   customRadioTime(
                                //                       timeList[8], 8),
                                //                   customRadioTime(
                                //                       timeList[9], 9),
                                //                   customRadioTime(
                                //                       timeList[10], 10),
                                //                   customRadioTime(
                                //                       timeList[11], 11),
                                //                 ],
                                //               ),
                                //               SizedBox(
                                //                 height: 10,
                                //               ),
                                //               Row(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.start,
                                //                 children: [
                                //                   customRadioTime(
                                //                       timeList[12], 12),
                                //                   customRadioTime(
                                //                       timeList[13], 13),
                                //                   customRadioTime(
                                //                       timeList[14], 14),
                                //                   customRadioTime(
                                //                       timeList[15], 15),
                                //                 ],
                                //               ),
                                //               SizedBox(
                                //                 height: 10,
                                //               ),
                                //               Row(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.start,
                                //                 children: [
                                //                   customRadioTime(
                                //                       timeList[16], 16),
                                //                   customRadioTime(
                                //                       timeList[17], 17),
                                //                 ],
                                //               ),
                                //               SizedBox(
                                //                 height: 10,
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       )
                                //     : Text(''),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  child: Text(
                                    '연락 방법',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            customRadio(list[0], 0),
                                            customRadio(list[1], 1)
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            customRadio(list[2], 2),
                                            customRadio(list[3], 3)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 10, 30, 0),
                                    child: Container(
                                      height: 50,
                                      child: InkWell(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '작업지시서 보기',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 13,
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Responsive.isMobile(context)
                                              ? Get.to(ResultPage(),
                                                  arguments: {
                                                      'data': processList[0],
                                                      'orderNo': processList[0]
                                                          ['orderNo'],
                                                    })
                                              : Get.to(ResultPageWeb(),
                                                  arguments: {
                                                      'data': processList[0],
                                                      'orderNo': processList[0]
                                                          ['orderNo'],
                                                    });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 10, 30, 0),
                                  child: Container(
                                    height: 50,
                                    child: InkWell(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '고객 문의 이력',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 13,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          if (_showHistory) {
                                            _showHistory = false;
                                          } else {
                                            _showHistory = true;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                _showHistory && historyDataExist
                                    ? Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 5, 20, 0),
                                        height: showhistoryList.length * 100,
                                        child: ListView.separated(
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return ListTile(
                                                title: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 80,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '변경일자',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              showhistoryList[
                                                                      index][
                                                                  'historyDate'],
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '변경사항',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              showhistoryList[
                                                                      index]
                                                                  ['history'],
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '연락방법',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            showhistoryList[
                                                                    index]
                                                                ['contact'],
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '요청사항',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              (showhistoryList[
                                                                              index]
                                                                          [
                                                                          'bigo'] ==
                                                                      ''
                                                                  ? '기타 요청사항 없음'
                                                                  : showhistoryList[
                                                                          index]
                                                                      ['bigo']),
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return Divider(thickness: 1);
                                            },
                                            itemCount: showhistoryList.length),
                                      )
                                    : Container(
                                        child: Center(
                                            child: Text(historyDataNotExist)),
                                      ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 30, 30, 0),
                                  child: Text(
                                    '요청사항',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 16),
                                      child: TextField(
                                        style: TextStyle(fontSize: 12),
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.black54),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.black54),
                                          ),
                                          hintText: '일정 확정 관련 특이사항을 입력하세요.',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Center(
                                  child: Container(
                                    width: Get.width * 0.5,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 10),
                                      child: Column(
                                        children: [
                                          Container(
                                            //로그아웃 버튼
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,

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
                                                if (_selectedIndex == -1) {
                                                  setState(() {
                                                    _viewTimeTable = true;
                                                  });
                                                  failAlert("연락 방법을 선택하세요.");
                                                } else {
                                                  showDialog(
                                                      context: Get.context!,
                                                      builder: (context) =>
                                                          MessagePopup(
                                                            title: '고객 문의',
                                                            message:
                                                                '고객 상담 내용을 변경하시겠습니까?',
                                                            okCallback: () {
                                                              // signOut();
                                                              //controller.ChangeInitPage();

                                                              // fixSchedule(
                                                              //     processList[0]
                                                              //         [
                                                              //         'orderNo']);
                                                              //Get.to(WagesChargePage());
                                                              aaaa();
                                                              Get.back();
                                                              // Get.to(
                                                              //     ScheduleManage());
                                                              setState(() {});
                                                            },
                                                            cancleCallback:
                                                                Get.back,
                                                          ));
                                                }
                                              },
                                              child: const Text('고객 문의 저장 하기'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ),
                      ),
                    ),
                  )
            : _isLoading
                ? Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: HexColor('#172543'),
                      ),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: Get.width * 0.5,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                                child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 30, 30, 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          '님',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  // ㄲ
                                  // Center(
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.fromLTRB(
                                  //         30, 10, 30, 0),
                                  //     child: Container(
                                  //       height: 50,
                                  //       child: InkWell(
                                  //         child: Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceBetween,
                                  //           children: [
                                  //             Text(
                                  //               '방문시간 선택',
                                  //               style: TextStyle(
                                  //                   fontWeight: FontWeight.w600,
                                  //                   fontSize: 14),
                                  //             ),
                                  //             SizedBox(
                                  //               width: 5,
                                  //             ),
                                  //             Icon(_viewTimeTable
                                  //                 ? Icons.keyboard_arrow_up
                                  //                 : Icons.keyboard_arrow_down),
                                  //           ],
                                  //         ),
                                  //         onTap: () {
                                  //           setState(() {
                                  //             if (_viewTimeTable == true) {
                                  //               _viewTimeTable = false;
                                  //             } else {
                                  //               _viewTimeTable = true;
                                  //             }
                                  //           });
                                  //         },
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // _viewTimeTable
                                  //     ? Center(
                                  //         child: Container(
                                  //           padding: EdgeInsets.only(
                                  //               left: 30, right: 30),
                                  //           width: MediaQuery.of(context)
                                  //                   .size
                                  //                   .width *
                                  //               0.8,
                                  //           child: Column(
                                  //             crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //             children: [
                                  //               Text('오전'),
                                  //               SizedBox(
                                  //                 height: 10,
                                  //               ),
                                  //               Container(
                                  //                 height: 0.5,
                                  //                 color: Colors.black,
                                  //               ),
                                  //               SizedBox(
                                  //                 height: 10,
                                  //               ),
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.start,
                                  //                 children: [
                                  //                   customRadioTime(
                                  //                       timeList[0], 0),
                                  //                   customRadioTime(
                                  //                       timeList[1], 1),
                                  //                   customRadioTime(
                                  //                       timeList[2], 2),
                                  //                   customRadioTime(
                                  //                       timeList[3], 3),
                                  //                 ],
                                  //               ),
                                  //               SizedBox(
                                  //                 height: 10,
                                  //               ),
                                  //               Text('오후'),
                                  //               SizedBox(
                                  //                 height: 10,
                                  //               ),
                                  //               Container(
                                  //                 height: 0.5,
                                  //                 color: Colors.black,
                                  //               ),
                                  //               SizedBox(
                                  //                 height: 10,
                                  //               ),
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.start,
                                  //                 children: [
                                  //                   customRadioTime(
                                  //                       timeList[4], 4),
                                  //                   customRadioTime(
                                  //                       timeList[5], 5),
                                  //                   customRadioTime(
                                  //                       timeList[6], 6),
                                  //                   customRadioTime(
                                  //                       timeList[7], 7),
                                  //                 ],
                                  //               ),
                                  //               SizedBox(
                                  //                 height: 10,
                                  //               ),
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.start,
                                  //                 children: [
                                  //                   customRadioTime(
                                  //                       timeList[8], 8),
                                  //                   customRadioTime(
                                  //                       timeList[9], 9),
                                  //                   customRadioTime(
                                  //                       timeList[10], 10),
                                  //                   customRadioTime(
                                  //                       timeList[11], 11),
                                  //                 ],
                                  //               ),
                                  //               SizedBox(
                                  //                 height: 10,
                                  //               ),
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.start,
                                  //                 children: [
                                  //                   customRadioTime(
                                  //                       timeList[12], 12),
                                  //                   customRadioTime(
                                  //                       timeList[13], 13),
                                  //                   customRadioTime(
                                  //                       timeList[14], 14),
                                  //                   customRadioTime(
                                  //                       timeList[15], 15),
                                  //                 ],
                                  //               ),
                                  //               SizedBox(
                                  //                 height: 10,
                                  //               ),
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.start,
                                  //                 children: [
                                  //                   customRadioTime(
                                  //                       timeList[16], 16),
                                  //                   customRadioTime(
                                  //                       timeList[17], 17),
                                  //                 ],
                                  //               ),
                                  //               SizedBox(
                                  //                 height: 10,
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : Text(''),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 10, 30, 10),
                                    child: Text(
                                      '연락 방법',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      width: Get.width * 0.8,
                                      padding:
                                          EdgeInsets.only(left: 30, right: 30),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              customRadio(list[0], 0),
                                              customRadio(list[1], 1)
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              customRadio(list[2], 2),
                                              customRadio(list[3], 3)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Center(
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.fromLTRB(
                                  //         30, 10, 30, 0),
                                  //     child: Container(
                                  //       height: 50,
                                  //       child: InkWell(
                                  //         child: Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceBetween,
                                  //           children: [
                                  //             Text(
                                  //               '작업지시서 보기',
                                  //               style: TextStyle(
                                  //                   fontWeight: FontWeight.w600,
                                  //                   fontSize: 14),
                                  //             ),
                                  //             SizedBox(
                                  //               width: 5,
                                  //             ),
                                  //             Icon(
                                  //               Icons.arrow_forward_ios_rounded,
                                  //               size: 13,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //         onTap: () {
                                  //           Responsive.isMobile(context)
                                  //               ? Get.to(ResultPage(),
                                  //                   arguments: {
                                  //                       'data': processList[0],
                                  //                       'orderNo':
                                  //                           processList[0]
                                  //                               ['orderNo'],
                                  //                     })
                                  //               : Get.to(ResultPageWeb(),
                                  //                   arguments: {
                                  //                       'data': processList[0],
                                  //                       'orderNo':
                                  //                           processList[0]
                                  //                               ['orderNo'],
                                  //                     });
                                  //         },
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 10, 30, 0),
                                    child: Container(
                                      height: 50,
                                      child: InkWell(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '고객 문의 이력',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 13,
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            if (_showHistory) {
                                              _showHistory = false;
                                            } else {
                                              _showHistory = true;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  _showHistory && historyDataExist
                                      ? Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 5, 20, 0),
                                          height: showhistoryList.length * 100,
                                          child: ListView.separated(
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  title: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 80,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  '변경사항',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  showhistoryList[
                                                                          index]
                                                                      [
                                                                      'history'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              showhistoryList[
                                                                      index][
                                                                  'historyDate'],
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '연락방법',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              showhistoryList[
                                                                      index]
                                                                  ['contact'],
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '요청사항',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                (showhistoryList[index]
                                                                            [
                                                                            'bigo'] ==
                                                                        ''
                                                                    ? '기타 요청사항 없음'
                                                                    : showhistoryList[
                                                                            index]
                                                                        [
                                                                        'bigo']),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Divider(thickness: 1);
                                              },
                                              itemCount:
                                                  showhistoryList.length),
                                        )
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 30, 30, 0),
                                    child: Text(
                                      '요청사항',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 16),
                                        child: TextField(
                                          controller: _bigoController,
                                          style: TextStyle(fontSize: 12),
                                          maxLines: 5,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black54),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black54),
                                            ),
                                            hintText: '일정 확정 관련 특이사항을 입력하세요.',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Center(
                                    child: Container(
                                      width: Get.width * 0.3,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              //로그아웃 버튼
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,

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
                                                      color:
                                                          HexColor('#172543'),
                                                      width: 1.0), //선
                                                  shape:
                                                      StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                                  alignment: Alignment.center,
                                                ), //글자위치 변경
                                                onPressed: () {
                                                  if (_selectedIndex == -1) {
                                                    setState(() {
                                                      _viewTimeTable = true;
                                                    });
                                                    failAlert("연락 방법을 선택하세요.");
                                                  } else {
                                                    showDialog(
                                                        context: Get.context!,
                                                        builder: (context) =>
                                                            MessagePopup(
                                                              title: '고객 문의',
                                                              message:
                                                                  '고객 상담 내용을 변경하시겠습니까?',
                                                              okCallback: () {
                                                                // signOut();
                                                                //controller.ChangeInitPage();

                                                                // fixSchedule(
                                                                //     processList[
                                                                //             0][
                                                                //         'orderNo']);
                                                                //Get.to(WagesChargePage());
                                                                aaaa();
                                                                Get.back();
                                                                // Get.to(
                                                                //     ScheduleManage());
                                                                setState(() {});
                                                              },
                                                              cancleCallback:
                                                                  Get.back,
                                                            ));
                                                  }
                                                },
                                                child:
                                                    const Text('고객 문의 저장 하기'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ));
  }

  List<String> timeList = [
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
  ];
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  Future<void> fixSchedule(String orderNo) {
    return

        // visitType == "G"
        //     ? orders
        //         .doc(orderNo)
        //         .update({
        //           'gabong': visitFixedDate,
        //           'gabongTime': timeList[_selectedTime]
        //         })
        //         .then((value) => print("User Updated"))
        //         .catchError((error) => print("Failed to update user: $error"))
        //     :
        orders
            .doc(orderNo)
            .update({
              'finishDate': visitFixedDate,
              'finishTime': timeList[_selectedTime]
            })
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
  }

  User? auth = FirebaseAuth.instance.currentUser;
  List historyList = [];
  List showhistoryList = [];
  bool historyDataExist = false;
  String historyDataNotExist = "";

  _getHistoryList() async {
    if (phone.length == 11) {
      phone = phone.substring(7, 11);
    } else if (phone.length == 10) {
      phone = phone.substring(6, 10);
    }

    var historyCollection =
        FirebaseFirestore.instance.collection('scheduleHistory');

    try {
      var historyListReturn = await historyCollection
          .doc(name + '_' + phone + '_' + consultDate.replaceAll('-', ''))
          .get();
      showhistoryList = [];
      showhistoryList = historyListReturn['scheduleHistory'];
      setState(() {
        historyDataExist = true;
      });
    } catch (e) {
      setState(() {
        historyDataNotExist = '변경이력이 없습니다.';
        historyDataExist = false;
      });
      // var historyListSub = {
      //   'history': '변경 이력이 없습니다.',
      //   'historyDate': '',
      //   'bigo': '',
      //   'contact': ''
      // };
      // showhistoryList.add(historyListSub);
    }
  }

  void aaaa() async {
    print('asdsad');
    var _toDay = DateTime.now();
    var collection = FirebaseFirestore.instance.collection('scheduleHistory');

    if (phone.length == 11) {
      phone = phone.substring(7, 11);
    } else if (phone.length == 10) {
      phone = phone.substring(6, 10);
    }

    String newHistory = '담당자 ' +
        auth!.displayName.toString() +
        '이/가 ' +
        list[_selectedIndex] +
        ' 로(으로) 고객 문의 처리';
    var historyListSub = {
      'history': newHistory,
      'historyDate': _toDay.toString().substring(0, 16),
      'bigo': _bigoController.text,
      'contact': list[_selectedIndex]
    };
    try {
      var historyListReturn = await collection
          .doc(name + '_' + phone + '_' + consultDate.replaceAll('-', ''))
          .get();
      if (historyListReturn['scheduleHistory'] == null ||
          historyListReturn['scheduleHistory'] == []) {
        historyList = [];
      } else {
        historyList = historyListReturn['scheduleHistory'];
      }

      historyList.add(historyListSub);
      _updateHistory(historyList);
    } catch (e) {
      historyList = [];
      historyList.add(historyListSub);
      _updateHistory(historyList);
    }
  }

  void _updateHistory(historyList) {
    try {
      var collection = FirebaseFirestore.instance.collection('scheduleHistory');
      collection
          .doc(name +
              '_' +
              phone +
              '_' +
              consultDate.replaceAll('-', '')) // <-- Document ID
          .set({'scheduleHistory': historyList}) // <-- Add data
          .then((_) => print('Added'))
          .catchError((error) => print('Add failed: $error'));
    } catch (e) {
      print(e);
    }
  }

  int _selectedTime = -1;
  bool _viewTimeTable = false;
  void _selectTime(int index) {
    setState(() {
      _selectedTime = index;
      // _viewTimeTable = false;
    });
  }

  Widget customRadioTime(String text, int index) {
    var widVal = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(
          right: Responsive.isMobile(context) && Get.width <= 600 ? 4 : 10),
      child: OutlinedButton(
        onPressed: () {
          _selectTime(index);
        },
        child: Text(text,
            style: TextStyle(
                color: _selectedTime == index
                    ? HexColor('#FFFFFF')
                    : Colors.black87)),
        style: OutlinedButton.styleFrom(
          backgroundColor:
              _selectedTime == index ? HexColor('#172543') : Colors.transparent,
          //minimumSize: Size(Get.width * 0.45, 50), //최소 사이즈
          minimumSize: Responsive.isMobile(context)
              ? Get.width <= 600
                  ? Size(30, 40)
                  : Size(155, 40)
              : Size(Get.width * 0.11, 40), //최소 사이즈
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          side: BorderSide(
              width: _selectedTime == index ? 3 : 1,
              color: _selectedTime == index
                  ? HexColor('#172543')
                  : Colors.black87),
        ),
      ),
    );
  }

  int _selectedIndex = -1;
  List<String> list = ['전화', '카카오톡', '네이버톡톡', '문자'];
  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        minimumSize: Responsive.isMobile(context)
            ? Size(Get.width * 0.35, 40)
            : Size(Get.width * 0.2, 40), //최소 사이즈
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

  // showTimePicker() async {
  //   TimeOfDay t =
  //       await time(context: context, initialTime: initialTime);
  // }

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
        visitFixedDate = dateTime.toString().substring(0, 10);
      });
    });
  }
}
