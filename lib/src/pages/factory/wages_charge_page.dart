import 'package:bykak/src/components/responsive.dart';
import 'package:bykak/src/pages/factory/wages_charge_list_page.dart';
import 'package:bykak/src/widget/custom_elevated_buttod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class WagesChargePage extends StatefulWidget {
  WagesChargePage({Key? key}) : super(key: key);

  @override
  State<WagesChargePage> createState() => _WagesChargePageState();
}

class _WagesChargePageState extends State<WagesChargePage> {
  @override
  void initState() {
    _getStoreList();
    _getUserData();
    // TODO: implement initState
    super.initState();
  }

  DateTimeRange dateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  bool monthPick = false;

  String selectedTailorShop = "";
  User? auth = FirebaseAuth.instance.currentUser;

  String factoryName = "";
  _getUserData() async {
    try {
      var userResult = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth!.email.toString())
          .get();

      setState(() {
        factoryName = userResult['storeName'];
      });
    } catch (e) {
      print(e);
    }
  }

  _getStoreList() async {
    storeList = [];
    var storeReturn = await FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: '1')
        .get();
    //storeList.remove("");
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

  late List<String> storeList;
  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    final widthVal = MediaQuery.of(context).size.width;
    final heightVal = MediaQuery.of(context).size.height;
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
          '공임비청구',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: Responsive.isMobile(context)
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: widthVal,
                  height: heightVal,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    child: Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.topLeft,
                                  height: heightVal * 0.05,
                                  child: Text(
                                    '공임비 청구',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '업체선택',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      height: 60,
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: HexColor('#172543')),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                        //value: storeInitVal,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items: storeList.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Text(items)),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedTailorShop = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                        child: Text(
                                      '청구기간',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          customRadio('지난달', 0, widthVal),
                                          customRadio('이번달', 1, widthVal),
                                          customRadio('직접입력', 2, widthVal)
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    monthPick == false
                                        ? Container()
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  child: Text(
                                                '청구기간상세',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    customRadio1(
                                                        '전체', 0, widthVal),
                                                    customRadio1(
                                                        '1~14일', 1, widthVal),
                                                    customRadio1(
                                                        '15~말일', 2, widthVal)
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            // TextButton(
                                            //   onPressed: () {
                                            //     showDatePickerPopStart();
                                            //   },
                                            //   child:
                                            Container(
                                              width: 100,
                                              height: 40,
                                              // decoration: BoxDecoration(
                                              //     border: Border.all(
                                              //   width: 0.5,
                                              //   color: HexColor('#172543'),
                                              // )),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${start.year}-${start.month}-${start.day}',
                                                //startDate,
                                                style: TextStyle(
                                                    color: HexColor('#172543')),
                                              ),
                                            ),
                                            // ),
                                          ],
                                        ),
                                        Text('-'),
                                        Row(
                                          children: [
                                            // TextButton(
                                            //   onPressed: () {
                                            //     showDatePickerPopStart();
                                            //   },
                                            //   child:
                                            Container(
                                              width: 100,
                                              height: 40,
                                              // decoration: BoxDecoration(
                                              //     border: Border.all(
                                              //   width: 0.5,
                                              //   color: HexColor('#172543'),
                                              // )),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${end.year}-${end.month}-${end.day}',
                                                //startDate,
                                                style: TextStyle(
                                                    color: HexColor('#172543')),
                                              ),
                                            ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        //로그아웃 버튼
                                        width:
                                            MediaQuery.of(context).size.width,

                                        child: ElevatedButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.white, //글자색
                                            onSurface: Colors
                                                .white, //onpressed가 null일때 색상
                                            backgroundColor:
                                                HexColor('#172543'),
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
                                            if (_selectedIndex == 3 ||
                                                _selectedperiod == 3 ||
                                                selectedTailorShop == "") {
                                              chargeListFailAlert();
                                            } else {
                                              Get.to(WagesChargeListPage(),
                                                  arguments: {
                                                    'factoryName': factoryName,
                                                    'storeName':
                                                        selectedTailorShop,
                                                    'startDate': start,
                                                    'endDate': end,
                                                  });
                                            }
                                            // Get.to(WagesChargeListPage(),
                                            //     arguments: {
                                            //       'factoryName': factoryName,
                                            //       'storeName':
                                            //           selectedTailorShop,
                                            //       'startDate': start,
                                            //       'endDate': end,
                                            //     });
                                            // //loginFailAlert();
                                            // //Get.to(InputBottomSize());
                                            // // /saveDesign();
                                            // //createPdf2();
                                          },
                                          child: const Text('청구 목록 조회'),
                                        ),
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
                ),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: widthVal * 0.5,
                  height: heightVal,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    child: Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.topLeft,
                                  height: heightVal * 0.05,
                                  child: Text(
                                    '공임비 청구',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '업체선택',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      height: 60,
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: HexColor('#172543')),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                        //value: storeInitVal,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items: storeList.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Text(items)),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedTailorShop = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                        child: Text(
                                      '청구기간',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          customRadio('지난달', 0, widthVal),
                                          customRadio('이번달', 1, widthVal),
                                          customRadio('직접입력', 2, widthVal)
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    monthPick == false
                                        ? Container()
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  child: Text(
                                                '청구기간상세',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    customRadio1(
                                                        '전체', 0, widthVal),
                                                    customRadio1(
                                                        '1~14일', 1, widthVal),
                                                    customRadio1(
                                                        '15~말일', 2, widthVal)
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            // TextButton(
                                            //   onPressed: () {
                                            //     showDatePickerPopStart();
                                            //   },
                                            //   child:
                                            Container(
                                              width: 100,
                                              height: 40,
                                              // decoration: BoxDecoration(
                                              //     border: Border.all(
                                              //   width: 0.5,
                                              //   color: HexColor('#172543'),
                                              // )),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${start.year}-${start.month}-${start.day}',
                                                //startDate,
                                                style: TextStyle(
                                                    color: HexColor('#172543')),
                                              ),
                                            ),
                                            // ),
                                          ],
                                        ),
                                        Text('-'),
                                        Row(
                                          children: [
                                            // TextButton(
                                            //   onPressed: () {
                                            //     showDatePickerPopStart();
                                            //   },
                                            //   child:
                                            Container(
                                              width: 100,
                                              height: 40,
                                              // decoration: BoxDecoration(
                                              //     border: Border.all(
                                              //   width: 0.5,
                                              //   color: HexColor('#172543'),
                                              // )),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${end.year}-${end.month}-${end.day}',
                                                //startDate,
                                                style: TextStyle(
                                                    color: HexColor('#172543')),
                                              ),
                                            ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        //로그아웃 버튼
                                        width:
                                            MediaQuery.of(context).size.width,

                                        child: ElevatedButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.white, //글자색
                                            onSurface: Colors
                                                .white, //onpressed가 null일때 색상
                                            backgroundColor:
                                                HexColor('#172543'),
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
                                            if (_selectedIndex == 3 ||
                                                _selectedperiod == 3 ||
                                                selectedTailorShop == "") {
                                              chargeListFailAlert();
                                            } else {
                                              Get.to(WagesChargeListPage(),
                                                  arguments: {
                                                    'factoryName': factoryName,
                                                    'storeName':
                                                        selectedTailorShop,
                                                    'startDate': start,
                                                    'endDate': end,
                                                  });
                                            }

                                            //loginFailAlert();
                                            //Get.to(InputBottomSize());
                                            // /saveDesign();
                                            //createPdf2();
                                          },
                                          child: const Text('청구 목록 조회'),
                                        ),
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
                ),
              ),
            ),
    );
  }

  int _selectedIndex = 3;

  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
    var now = DateTime.now();
    if (_selectedIndex == 2) {
      _selectedperiod = 4;
      monthPick = false;
      showDatePickerPopStart();
    } else if (_selectedIndex == 1) {
      setState(() {
        _selectedperiod = 3;
        monthPick = true;
      });
    } else {
      setState(() {
        _selectedperiod = 3;
        monthPick = true;
      });
    }
  }

  Widget customRadio(String text, int index, withtVal) {
    return OutlinedButton(
      onPressed: () {
        changeIndex(index);
      },
      style: OutlinedButton.styleFrom(
        //minimumSize: Size(Get.width * 0.45, 50), //최소 사이즈

        backgroundColor:
            _selectedIndex == index ? HexColor('#172543') : Colors.transparent,
        //minimumSize: withtVal < 481 ? Size(120, 40) : Size(200, 40), //최소 사이즈
        fixedSize: Responsive.isMobile(context)
            ? Size(withtVal * 0.25, 40)
            : Size(withtVal * 0.13, 40), //최소 사이
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        side: BorderSide(
            width: _selectedIndex == index ? 3 : 1,
            color:
                _selectedIndex == index ? HexColor('#172543') : Colors.black87),
      ),
      child: Text(text,
          style: TextStyle(
              color: _selectedIndex == index
                  ? HexColor('#FFFFFF')
                  : Colors.black87)),
    );
  }

  int _selectedperiod = 3;
  void changeIndex1(int index) {
    setState(() {
      _selectedperiod = index;
    });
    var now = DateTime.now();
    if (_selectedIndex == 0) {
      if (_selectedperiod == 0) {
        setState(() {
          dateRange = DateTimeRange(
              start: DateTime(now.year, now.month - 1, 1),
              end: DateTime(now.year, now.month - 1 + 1, 0));
        });
      } else if (_selectedperiod == 1) {
        setState(() {
          dateRange = DateTimeRange(
              start: DateTime(now.year, now.month - 1, 1),
              end: DateTime(now.year, now.month - 1, 14));
        });
      } else {
        setState(() {
          dateRange = DateTimeRange(
              start: DateTime(now.year, now.month - 1, 15),
              end: DateTime(now.year, now.month - 1 + 1, 0));
        });
      }
    } else if (_selectedIndex == 1) {
      if (_selectedperiod == 0) {
        setState(() {
          dateRange = DateTimeRange(
              start: DateTime(now.year, now.month, 1),
              end: DateTime(now.year, now.month + 1, 0));
        });
      } else if (_selectedperiod == 1) {
        setState(() {
          dateRange = DateTimeRange(
              start: DateTime(now.year, now.month, 1),
              end: DateTime(now.year, now.month, 14));
        });
      } else {
        setState(() {
          dateRange = DateTimeRange(
              start: DateTime(now.year, now.month, 15),
              end: DateTime(now.year, now.month + 1, 0));
        });
      }
    }
  }

  Widget customRadio1(String text, int index, withtVal) {
    return OutlinedButton(
      onPressed: () {
        changeIndex1(index);
      },
      style: OutlinedButton.styleFrom(
        //minimumSize: Size(Get.width * 0.45, 50), //최소 사이즈

        backgroundColor:
            _selectedperiod == index ? HexColor('#172543') : Colors.transparent,
        //minimumSize: withtVal < 481 ? Size(120, 40) : Size(200, 40), //최소 사이즈
        fixedSize: Responsive.isMobile(context)
            ? Size(withtVal * 0.25, 40)
            : Size(withtVal * 0.13, 40), //최소 사이
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        side: BorderSide(
            width: _selectedperiod == index ? 3 : 1,
            color: _selectedperiod == index
                ? HexColor('#172543')
                : Colors.black87),
      ),
      child: Text(text,
          style: TextStyle(
              color: _selectedperiod == index
                  ? HexColor('#FFFFFF')
                  : Colors.black87)),
    );
  }

  /* DatePicker 띄우기 */
  Future showDatePickerPopStart() async {
    DateTimeRange? selectedDate = await showDateRangePicker(
      context: context,

      currentDate: DateTime.now(),
      // initialDate: DateTime.now(), //초기값
      firstDate: DateTime(2000), //시작일
      lastDate: DateTime(2100), //마지막일

      //initialDatePickerMode: DatePickerMode.year,
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

    if (selectedDate == null) return;
    //selectedDate.then((dateTime) {
    setState(() {
      dateRange = selectedDate;
    });
    //});
  }

  void chargeListFailAlert() {
    Fluttertoast.showToast(
        webBgColor: "linear-gradient(to right, #F44336, #F44336)",
        webPosition: "center",
        msg: "업체 및 청구기간을 확인하세요",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffF44336),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
