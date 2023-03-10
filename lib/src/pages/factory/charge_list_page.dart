import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:bykak/src/components/alert_fucntion.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/components/number_format.dart';
import 'package:bykak/src/pages/factory/charge_list_detail_page.dart';
import 'package:bykak/src/pages/factory/wages_charge_page.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ChargeListPage extends StatefulWidget {
  const ChargeListPage({Key? key}) : super(key: key);

  @override
  State<ChargeListPage> createState() => _ChargeListPageState();
}

class _ChargeListPageState extends State<ChargeListPage> {
  TextEditingController searchStore = new TextEditingController();

  final _verticalScrollController2 = ScrollController();
  final _horizontalScrollController2 = ScrollController();
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  final _verticalScrollController1 = ScrollController();
  final _horizontalScrollController1 = ScrollController();

  String startDate = "";
  String endDate = "";
  bool _isLoading = true;

  User? auth = FirebaseAuth.instance.currentUser;

  String userType = "";
  String storeName = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfo();

    // Future.delayed(Duration(seconds: 2), () {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
  }

  _getUserInfo() async {
    try {
      var userResult =
          await firestore.collection('users').doc(auth!.email.toString()).get();

      // setState(() {
      userType = userResult['userType'];
      storeName = userResult['storeName'];
      // });
    } catch (e) {}

    _getChargeList(userType, storeName);
  }

  late List chargeList;
  final firestore = FirebaseFirestore.instance;

  //????????????
  _getChargeList(String userType, String storeName) async {
    var _toDay = DateTime.now();
    setState(() {
      chargeList = [];
      startDate = _toDay.toString().substring(0, 10);
      endDate = _toDay.toString().substring(0, 10);
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });

    var doc;

    if (userType == "1") {
      try {
        var listResult = await firestore
            .collection('charges')
            .where('tailorShop', isEqualTo: storeName)
            .get();

        //if (listResult.docs.length != 0) {

        for (doc in listResult.docs) {
          setState(() {
            chargeList.add(doc);
          });
        }

        // } else {}
      } catch (e) {
        print(e);
        printError();
      }
    } else {
      try {
        var listResult = await firestore
            .collection('charges')
            .where('factory', isEqualTo: storeName)
            .get();

        //  if (listResult.docs.length != 0) {

        for (doc in listResult.docs) {
          setState(() {
            chargeList.add(doc);
          });
        }

        // } else {}
      } catch (e) {
        print(e);
        printError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _horizontal = ScrollController(),
        _vertical = ScrollController();
    return userType == "1"
        ? Scaffold(
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
                '?????? ?????? ??????',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
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
                : SizedBox(
                    height: Get.height,
                    width: Get.width,
                    child: Scrollbar(
                      controller: _vertical,
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: Scrollbar(
                        controller: _horizontal,
                        thumbVisibility: true,
                        trackVisibility: true,
                        notificationPredicate: (notif) => notif.depth == 1,
                        child: SingleChildScrollView(
                          controller: _vertical,
                          child: SingleChildScrollView(
                            controller: _horizontal,
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 15),
                                      height: 220,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '????????????',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Text('????????????'),
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        startDate,
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                '#172543')),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text('-  '),
                                              Row(
                                                children: [
                                                  Text('????????????'),
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        endDate,
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                '#172543')),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '?????????',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                            width: 80,
                                            child: ElevatedButton(
                                              style: TextButton.styleFrom(
                                                primary: Colors.white, //?????????
                                                onSurface: Colors
                                                    .white, //onpressed??? null?????? ??????
                                                backgroundColor:
                                                    HexColor('#172543'),
                                                shadowColor:
                                                    Colors.white, //????????? ??????
                                                elevation: 1, // ?????? ?????????
                                                textStyle:
                                                    TextStyle(fontSize: 12),
                                                //padding: EdgeInsets.all(16.0),
                                                minimumSize:
                                                    Size(75, 40), //?????? ?????????
                                                maximumSize:
                                                    Size(75, 40), //?????? ?????????,
                                                side: BorderSide(
                                                    color: HexColor('#172543'),
                                                    width: 1.0), //???
                                                shape:
                                                    StadiumBorder(), // : ????????????, CircleBorder : ??????????????????, StadiumBorder : ???????????? ????????????,
                                                alignment: Alignment.center,
                                              ), //???????????? ??????
                                              onPressed: () {
                                                if (DateTime.parse(startDate)
                                                        .compareTo(
                                                            DateTime.parse(
                                                                endDate)) <
                                                    1) {
                                                  getSearchData(
                                                      searchStore.text
                                                          .toString(),
                                                      startDate,
                                                      endDate);
                                                } else {
                                                  failAlert(
                                                      "?????? ???????????? ???????????? ???????????????.");
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
                                                  Text('??????'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      height: 5,
                                      color: Colors.black12,
                                    ),
                                  ],
                                ),
                                DataTable(
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          '????????????',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '???????????????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ?????? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ?????? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ??? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    // DataColumn(
                                    //   label: Text(
                                    //     '?????? ?????? ??????',
                                    //     style: TextStyle(
                                    //         fontStyle: FontStyle.italic,
                                    //         fontWeight:
                                    //             FontWeight.w600),
                                    //   ),
                                    // ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ?????? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                  rows: List<DataRow>.generate(
                                    chargeList.length,
                                    (index) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(Center(
                                          child: Text(
                                              chargeList[index]['chargeNo']),
                                        )),
                                        DataCell(Center(
                                          child: Text(chargeList[index]
                                                  ['factory'] ??
                                              ""),
                                        )),
                                        DataCell(Center(
                                          child: Text(chargeList[index]
                                                  ['tailorShop'] ??
                                              ""),
                                        )),
                                        DataCell(Center(
                                          child: Text(chargeList[index]
                                                  ['chargeStartDate'] ??
                                              ""),
                                        )),
                                        DataCell(Center(
                                          child: Text(chargeList[index]
                                                  ['chargeEndDate'] ??
                                              ""),
                                        )),
                                        DataCell(Center(
                                          child: Text(moneyFormatText(
                                                  chargeList[index]
                                                      ['chargeGabongCost']) +
                                              ' ???'),
                                        )),
                                        DataCell(Center(
                                          child: Text(moneyFormatText(
                                                  chargeList[index]
                                                      ['chargeBongjeCost']) +
                                              ' ???'),
                                        )),
                                        DataCell(Center(
                                          child: Text(moneyFormatText(
                                                  chargeList[index]
                                                      ['chargeCost']) +
                                              ' ???'),
                                        )),
                                        // DataCell(Center(
                                        //   child: Text(chargeList[index]
                                        //           ['chargeComplete'] ??
                                        //       "N"),
                                        // )),
                                        DataCell(
                                          Center(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                top: 5,
                                              ),
                                              width: 80,
                                              child: ElevatedButton(
                                                style: TextButton.styleFrom(
                                                  primary: Colors.white, //?????????
                                                  onSurface: Colors
                                                      .white, //onpressed??? null?????? ??????
                                                  backgroundColor:
                                                      HexColor('#172543'),
                                                  shadowColor:
                                                      Colors.white, //????????? ??????
                                                  elevation: 1, // ?????? ?????????
                                                  textStyle:
                                                      TextStyle(fontSize: 12),
                                                  //padding: EdgeInsets.all(16.0),
                                                  minimumSize:
                                                      Size(75, 35), //?????? ?????????
                                                  maximumSize:
                                                      Size(75, 35), //?????? ?????????,
                                                  side: BorderSide(
                                                      color:
                                                          HexColor('#172543'),
                                                      width: 1.0), //???
                                                  shape:
                                                      StadiumBorder(), // : ????????????, CircleBorder : ??????????????????, StadiumBorder : ???????????? ????????????,
                                                  alignment: Alignment.center,
                                                ), //???????????? ??????
                                                onPressed: () {
                                                  //
                                                  Get.to(ChargeListDetail(),
                                                      arguments: {
                                                        'chargeNoVal':
                                                            chargeList[index]
                                                                ['chargeNo'],
                                                        'factoryName':
                                                            chargeList[index]
                                                                ['factory'],
                                                        'storeName':
                                                            chargeList[index]
                                                                ['tailorShop'],
                                                        'startDate': chargeList[
                                                                index]
                                                            ['chargeStartDate'],
                                                        'endDate': chargeList[
                                                                index]
                                                            ['chargeEndDate'],
                                                        'chargeComplete':
                                                            chargeList[index][
                                                                'chargeComplete'],
                                                        'orderNoChargeType':
                                                            chargeList[index][
                                                                'orderNoChargeType'],
                                                        'orderNoList':
                                                            chargeList[index]
                                                                ['orderNoList'],
                                                      });
                                                },
                                                child: Text('??????'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        chargeList[index]['chargeComplete'] ==
                                                "Y"
                                            ? DataCell(
                                                Center(
                                                  child: Text('?????? ??????',
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                ),
                                              )
                                            : chargeList[index]
                                                        ['chargeComplete'] ==
                                                    "W"
                                                ? DataCell(
                                                    Center(
                                                      child: Text(
                                                        '?????? ?????? ??????',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  )
                                                : DataCell(
                                                    Center(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 5,
                                                        ),
                                                        width: 120,
                                                        child: ElevatedButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            primary: Colors
                                                                .white, //?????????
                                                            onSurface: Colors
                                                                .white, //onpressed??? null?????? ??????
                                                            backgroundColor:
                                                                HexColor(
                                                                    '#172543'),
                                                            shadowColor: Colors
                                                                .white, //????????? ??????
                                                            elevation:
                                                                1, // ?????? ?????????
                                                            textStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        12),
                                                            //padding: EdgeInsets.all(16.0),
                                                            minimumSize: Size(
                                                                75,
                                                                35), //?????? ?????????
                                                            maximumSize: Size(
                                                                75,
                                                                35), //?????? ?????????,
                                                            side: BorderSide(
                                                                color: HexColor(
                                                                    '#172543'),
                                                                width: 1.0), //???
                                                            shape:
                                                                StadiumBorder(), // : ????????????, CircleBorder : ??????????????????, StadiumBorder : ???????????? ????????????,
                                                            alignment: Alignment
                                                                .center,
                                                          ), //???????????? ??????
                                                          onPressed: () {
                                                            showDialog(
                                                                context: Get
                                                                    .context!,
                                                                builder:
                                                                    (context) =>
                                                                        MessagePopup(
                                                                          title:
                                                                              '????????????',
                                                                          message:
                                                                              '?????? ?????? ????????? ?????? ??????????????? ??????????????????????',
                                                                          okCallback:
                                                                              () async {
                                                                            // signOut();
                                                                            //controller.ChangeInitPage();
                                                                            updateCharges(chargeList[index]['chargeNo']);
                                                                            //Get.to(WagesChargePage());
                                                                            setState(() {
                                                                              _isLoading = true;
                                                                              // _getUserInfo();

                                                                              // Get.to(const ChargeListPage());
                                                                              _getChargeList(userType, storeName);
                                                                            });
                                                                            Get.back();
                                                                          },
                                                                          cancleCallback:
                                                                              Get.back,
                                                                        ));
                                                          },
                                                          child:
                                                              Text('?????? ?????? ??????'),
                                                        ),
                                                      ),
                                                    ),
                                                  )
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
                  ),
            // Column(
            //               children: [

            //                 Expanded(
            //                   child: SingleChildScrollView(
            //                     child: Container(
            //                       padding: EdgeInsets.only(top: 10),
            //                       height: MediaQuery.of(context).size.height,
            //                       width: MediaQuery.of(context).size.width,
            //                       child: AdaptiveScrollbar(
            //                         underColor: Colors.blueGrey.withOpacity(0.3),
            //                         sliderDefaultColor: Colors.grey.withOpacity(0.7),
            //                         sliderActiveColor: Colors.grey,
            //                         controller: _verticalScrollController,
            //                         child: AdaptiveScrollbar(
            //                           controller: _horizontalScrollController,
            //                           position: ScrollbarPosition.bottom,
            //                           underColor: Colors.blueGrey.withOpacity(0.3),
            //                           sliderDefaultColor:
            //                               Colors.grey.withOpacity(0.7),
            //                           sliderActiveColor: Colors.grey,
            //                           child: SingleChildScrollView(
            //                             controller: _verticalScrollController,
            //                             scrollDirection: Axis.vertical,
            //                             child: SingleChildScrollView(
            //                               controller: _horizontalScrollController,
            //                               scrollDirection: Axis.horizontal,
            //                               child: Padding(
            //                                 padding: const EdgeInsets.only(
            //                                     right: 8.0, bottom: 16.0),
            //                                 child: SingleChildScrollView(
            //                                   scrollDirection: Axis.horizontal,
            //                                   child:

            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //       // ),
            //     )
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton.extended(
                backgroundColor: mainColor,
                onPressed: () {
                  Get.to(WagesChargePage());
                },
                label: Row(
                  children: [
                    Icon(Icons.markunread),
                    SizedBox(
                      width: 5,
                    ),
                    Text('????????? ??????'),
                  ],
                )),
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
                '?????? ?????? ??????',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
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
                : SizedBox(
                    height: Get.height,
                    width: Get.width,
                    child: Scrollbar(
                      controller: _vertical,
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: Scrollbar(
                        controller: _horizontal,
                        thumbVisibility: true,
                        trackVisibility: true,
                        notificationPredicate: (notif) => notif.depth == 1,
                        child: SingleChildScrollView(
                          controller: _vertical,
                          child: SingleChildScrollView(
                            controller: _horizontal,
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 15),
                                      height: 220,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '????????????',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Text('????????????'),
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        startDate,
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                '#172543')),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text('-  '),
                                              Row(
                                                children: [
                                                  Text('????????????'),
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        endDate,
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                '#172543')),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '?????????',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                            width: 80,
                                            child: ElevatedButton(
                                              style: TextButton.styleFrom(
                                                primary: Colors.white, //?????????
                                                onSurface: Colors
                                                    .white, //onpressed??? null?????? ??????
                                                backgroundColor:
                                                    HexColor('#172543'),
                                                shadowColor:
                                                    Colors.white, //????????? ??????
                                                elevation: 1, // ?????? ?????????
                                                textStyle:
                                                    TextStyle(fontSize: 12),
                                                //padding: EdgeInsets.all(16.0),
                                                minimumSize:
                                                    Size(75, 40), //?????? ?????????
                                                maximumSize:
                                                    Size(75, 40), //?????? ?????????,
                                                side: BorderSide(
                                                    color: HexColor('#172543'),
                                                    width: 1.0), //???
                                                shape:
                                                    StadiumBorder(), // : ????????????, CircleBorder : ??????????????????, StadiumBorder : ???????????? ????????????,
                                                alignment: Alignment.center,
                                              ), //???????????? ??????
                                              onPressed: () {
                                                if (DateTime.parse(startDate)
                                                        .compareTo(
                                                            DateTime.parse(
                                                                endDate)) <
                                                    1) {
                                                  getSearchData(
                                                      searchStore.text
                                                          .toString(),
                                                      startDate,
                                                      endDate);
                                                } else {
                                                  failAlert(
                                                      "?????? ???????????? ???????????? ???????????????.");
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
                                                  Text('??????'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      height: 5,
                                      color: Colors.black12,
                                    ),
                                  ],
                                ),
                                DataTable(
                                  sortAscending: true,
                                  sortColumnIndex: 0,
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        '????????????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '???????????????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ?????? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ?????? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ??? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    // DataColumn(
                                    //   label: Text(
                                    //     '?????? ?????? ??????',
                                    //     style: TextStyle(
                                    //         fontStyle: FontStyle.italic,
                                    //         fontWeight:
                                    //             FontWeight.w600),
                                    //   ),
                                    // ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ?????? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '?????? ?????? ??????',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                  rows: List<DataRow>.generate(
                                    chargeList.length,
                                    (index) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(Center(
                                          child: Text(
                                              chargeList[index]['chargeNo']),
                                        )),
                                        DataCell(Center(
                                          child: Text(chargeList[index]
                                                  ['factory'] ??
                                              ""),
                                        )),
                                        DataCell(Center(
                                          child: Text(chargeList[index]
                                                  ['tailorShop'] ??
                                              ""),
                                        )),
                                        DataCell(Center(
                                          child: Text(chargeList[index]
                                                  ['chargeStartDate'] ??
                                              ""),
                                        )),
                                        DataCell(Center(
                                          child: Text(chargeList[index]
                                                  ['chargeEndDate'] ??
                                              ""),
                                        )),
                                        DataCell(Center(
                                          child: Text(moneyFormatText(
                                                  chargeList[index]
                                                      ['chargeGabongCost']) +
                                              ' ???'),
                                        )),
                                        DataCell(Center(
                                          child: Text(moneyFormatText(
                                                  chargeList[index]
                                                      ['chargeBongjeCost']) +
                                              ' ???'),
                                        )),
                                        DataCell(Center(
                                          child: Text(moneyFormatText(
                                                  chargeList[index]
                                                      ['chargeCost']) +
                                              ' ???'),
                                        )),
                                        // DataCell(Center(
                                        //   child: Text(chargeList[index]
                                        //           ['chargeComplete'] ??
                                        //       "N"),
                                        // )),
                                        DataCell(
                                          Center(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                top: 5,
                                              ),
                                              width: 80,
                                              child: ElevatedButton(
                                                style: TextButton.styleFrom(
                                                  primary: Colors.white, //?????????
                                                  onSurface: Colors
                                                      .white, //onpressed??? null?????? ??????
                                                  backgroundColor:
                                                      HexColor('#172543'),
                                                  shadowColor:
                                                      Colors.white, //????????? ??????
                                                  elevation: 1, // ?????? ?????????
                                                  textStyle:
                                                      TextStyle(fontSize: 12),
                                                  //padding: EdgeInsets.all(16.0),
                                                  minimumSize:
                                                      Size(75, 35), //?????? ?????????
                                                  maximumSize:
                                                      Size(75, 35), //?????? ?????????,
                                                  side: BorderSide(
                                                      color:
                                                          HexColor('#172543'),
                                                      width: 1.0), //???
                                                  shape:
                                                      StadiumBorder(), // : ????????????, CircleBorder : ??????????????????, StadiumBorder : ???????????? ????????????,
                                                  alignment: Alignment.center,
                                                ), //???????????? ??????
                                                onPressed: () {
                                                  //
                                                  Get.to(ChargeListDetail(),
                                                      arguments: {
                                                        'chargeNoVal':
                                                            chargeList[index]
                                                                ['chargeNo'],
                                                        'factoryName':
                                                            chargeList[index]
                                                                ['factory'],
                                                        'storeName':
                                                            chargeList[index]
                                                                ['tailorShop'],
                                                        'startDate': chargeList[
                                                                index]
                                                            ['chargeStartDate'],
                                                        'endDate': chargeList[
                                                                index]
                                                            ['chargeEndDate'],
                                                        'chargeComplete':
                                                            chargeList[index][
                                                                'chargeComplete'],
                                                        'orderNoChargeType':
                                                            chargeList[index][
                                                                'orderNoChargeType'],
                                                        'orderNoList':
                                                            chargeList[index]
                                                                ['orderNoList'],
                                                      });
                                                },
                                                child: Text('??????'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        chargeList[index]['chargeComplete'] ==
                                                "Y"
                                            ? DataCell(
                                                Center(
                                                  child: Text('?????? ?????? ?????? ??????',
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                ),
                                              )
                                            : DataCell(
                                                Center(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                      top: 5,
                                                    ),
                                                    width: 140,
                                                    child: ElevatedButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        primary:
                                                            Colors.white, //?????????
                                                        onSurface: Colors
                                                            .white, //onpressed??? null?????? ??????
                                                        backgroundColor:
                                                            HexColor('#172543'),
                                                        shadowColor: Colors
                                                            .white, //????????? ??????
                                                        elevation: 1, // ?????? ?????????
                                                        textStyle: TextStyle(
                                                            fontSize: 12),
                                                        //padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(
                                                            75, 35), //?????? ?????????
                                                        maximumSize: Size(
                                                            75, 35), //?????? ?????????,
                                                        side: BorderSide(
                                                            color: HexColor(
                                                                '#172543'),
                                                            width: 1.0), //???
                                                        shape:
                                                            StadiumBorder(), // : ????????????, CircleBorder : ??????????????????, StadiumBorder : ???????????? ????????????,
                                                        alignment:
                                                            Alignment.center,
                                                      ), //???????????? ??????
                                                      onPressed: () {
                                                        showDialog(
                                                            context:
                                                                Get.context!,
                                                            builder: (context) =>
                                                                MessagePopup(
                                                                  title:
                                                                      '?????? ?????? ??????',
                                                                  message:
                                                                      '?????? ?????? ????????? ?????? ???????????????????',
                                                                  okCallback:
                                                                      () async {
                                                                    // signOut();
                                                                    //controller.ChangeInitPage();
                                                                    _deleteChargeData(
                                                                        chargeList[index]
                                                                            [
                                                                            'chargeNo']);
                                                                    //Get.to(WagesChargePage());

                                                                    Get.back();
                                                                  },
                                                                  cancleCallback:
                                                                      Get.back,
                                                                ));
                                                      },
                                                      child: Text('?????? ?????? ??????'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        chargeList[index]['chargeComplete'] ==
                                                "Y"
                                            ? DataCell(
                                                Center(
                                                  child: Text('?????? ?????? ??????',
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                ),
                                              )
                                            : chargeList[index]
                                                        ['chargeComplete'] ==
                                                    "N"
                                                ? DataCell(
                                                    Center(
                                                      child: Text('?????? ?????? ??????',
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                    ),
                                                  )
                                                : DataCell(
                                                    Center(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 5,
                                                        ),
                                                        width: 120,
                                                        child: ElevatedButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            primary: Colors
                                                                .white, //?????????
                                                            onSurface: Colors
                                                                .white, //onpressed??? null?????? ??????
                                                            backgroundColor:
                                                                HexColor(
                                                                    '#172543'),
                                                            shadowColor: Colors
                                                                .white, //????????? ??????
                                                            elevation:
                                                                1, // ?????? ?????????
                                                            textStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        12),
                                                            //padding: EdgeInsets.all(16.0),
                                                            minimumSize: Size(
                                                                75,
                                                                35), //?????? ?????????
                                                            maximumSize: Size(
                                                                75,
                                                                35), //?????? ?????????,
                                                            side: BorderSide(
                                                                color: HexColor(
                                                                    '#172543'),
                                                                width: 1.0), //???
                                                            shape:
                                                                StadiumBorder(), // : ????????????, CircleBorder : ??????????????????, StadiumBorder : ???????????? ????????????,
                                                            alignment: Alignment
                                                                .center,
                                                          ), //???????????? ??????
                                                          onPressed: () {
                                                            showDialog(
                                                                context: Get
                                                                    .context!,
                                                                builder:
                                                                    (context) =>
                                                                        MessagePopup(
                                                                          title:
                                                                              '????????????',
                                                                          message:
                                                                              '?????? ??? ?????? ?????? ????????? ??????????????????????',
                                                                          okCallback:
                                                                              () async {
                                                                            // signOut();
                                                                            //controller.ChangeInitPage();
                                                                            _updateChargeData(chargeList[index]['chargeNo']);
                                                                            //Get.to(WagesChargePage());

                                                                            Get.back();
                                                                          },
                                                                          cancleCallback:
                                                                              Get.back,
                                                                        ));
                                                          },
                                                          child:
                                                              Text('?????? ?????? ??????'),
                                                        ),
                                                      ),
                                                    ),
                                                  )
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
                  ),
          );
  }

  /* DatePicker ????????? */
  void showDatePickerPopStart() {
    Future<DateTime?> selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(), //?????????
      firstDate: DateTime(2000), //?????????
      lastDate: DateTime(2100), //????????????
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
          //data: ThemeData.light(), //?????? ??????
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

  /* DatePicker ????????? */
  void showDatePickerPopEnd() {
    Future<DateTime?> selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(), //?????????
      firstDate: DateTime(2000), //?????????
      lastDate: DateTime(2100), //????????????
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
          //data: ThemeData.light(), //?????? ??????
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

  CollectionReference charges =
      FirebaseFirestore.instance.collection('charges');

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> updateCharges(String chargeNo) {
    return charges
        .doc(chargeNo)
        .update({'chargeComplete': 'W'})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> acceptCharges(String chargeNo) {
    return charges
        .doc(chargeNo)
        .update({'chargeComplete': 'Y'})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateOrders(String orderNo, String orderNoChargeType) {
    if (orderNoChargeType == "G") {
      return orders
          .doc(orderNo)
          .update({'gabongChargeComplete': 'Y'})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else if (orderNoChargeType == "B") {
      return orders
          .doc(orderNo)
          .update({'bongjeChargeComplete': 'Y'})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else {
      return orders
          .doc(orderNo)
          .update({'bongjeChargeComplete': 'Y', 'gabongChargeComplete': 'Y'})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future<void> _deleteChargeData(String chargeNo) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await firestore.collection('charges').doc(chargeNo).delete();

      try {
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _isLoading = false;
          });
        });
        _getUserInfo();
      } catch (e) {}
    } catch (e) {
      print(e.toString());
    }
  }

  _updateChargeData(String chargeNo) async {
    //?????? ????????? ?????? ????????????
    try {
      acceptCharges(chargeNo);

      try {
        var orderListResult =
            await firestore.collection('charges').doc(chargeNo).get();
        List orderNoList = [];
        List orderNoChargeType = [];
        setState(() {
          orderNoList = orderListResult['orderNoList'];
          orderNoChargeType = orderListResult['orderNoChargeType'];
        });

        for (var i = 0; i < orderNoList.length; i++) {
          updateOrders(orderNoList[i], orderNoChargeType[i]);
        }
      } catch (e) {}

      setState(() {
        _isLoading = true;
        // _getUserInfo();

        // Get.to(const ChargeListPage());
        _getChargeList(userType, storeName);
      });
    } catch (e) {
      print(e);
    }
  }

  getSearchData(String searchStore, String startDate, String endDate) async {
    chargeList = [];
    var doc;
    var result;
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
        result = await firestore
            .collection('charges')
            .where('factory', isEqualTo: storeName)
            .get();

        for (doc in result.docs) {
          if (DateTime.parse(doc['chargeStartDate'])
                      .add(Duration(seconds: 1))
                      .compareTo(DateTime.parse(startDate)) >
                  0 &&
              DateTime.parse(doc['chargeStartDate'])
                      .add(Duration(seconds: 1))
                      .compareTo(DateTime.parse(endDate)) <
                  0) {
            if (doc['tailorShop'].toString().contains(searchStore)) {
              setState(
                () {
                  chargeList.add(doc);
                },
              );
            }
          }
        }
      } else {
        result = await firestore
            .collection('charges')
            .where('tailorShop', isEqualTo: storeName)
            .get();

        for (doc in result.docs) {
          if (DateTime.parse(doc['chargeStartDate'])
                      .add(Duration(seconds: 1))
                      .compareTo(DateTime.parse(startDate)) >
                  0 &&
              DateTime.parse(doc['chargeStartDate'])
                      .add(Duration(seconds: 1))
                      .compareTo(DateTime.parse(endDate)) <
                  0) {
            if (doc['factory'].toString().contains(searchStore)) {
              setState(
                () {
                  chargeList.add(doc);
                },
              );
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
