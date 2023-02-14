import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class UserManagePage extends StatefulWidget {
  UserManagePage({Key? key}) : super(key: key);

  @override
  State<UserManagePage> createState() => _UserManagePageState();
}

class _UserManagePageState extends State<UserManagePage> {
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  List processList = [];
  List processDetail = [];
  var doc;
  int listCount = 0;
  int dataCount = 0;

  final firestore = FirebaseFirestore.instance;
  User? auth = FirebaseAuth.instance.currentUser;
  TextEditingController searchUser = new TextEditingController();
  String storeName = "";
  String userType = "";
  String startDate = "";
  String endDate = "";
  String userId = "";

  // var factoryPartInit = '자켓';
  // var tailorPartInit = '상담';
  List<String> userFactoryPart = [
    '선택',
    '재단',
    '자켓',
    '바지',
    '조끼',
    '셔츠',
    '코트',
  ];

  List<String> userTailorPart = [
    '선택',
    '상담',
  ];

  Future<void> deleteUser(String email) async {
    print(FirebaseAuth.instance.currentUser!.delete());

    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      // if (user != null) {
      //   user.delete();
      // }
    });
    // final user = FirebaseAuth.instance.currentUser;
    // await user?.delete();
  }

  var checkUserPart;
  var userPart;

  getData() async {
    processList = [];
    try {
      try {
        var userResult = await firestore
            .collection('users')
            .doc(auth!.email.toString())
            .get();

        setState(() {
          storeName = userResult['storeName'];
          userType = userResult['userType'];
          userId = userResult['userId'];
        });
      } catch (e) {}

      if (userType == "2") {
        var result = await firestore
            .collection('users')
            .where('storeName', isEqualTo: storeName)
            .get();

        for (doc in result.docs) {
          setState(() {
            processList.add(doc);
          });
        }
      } else {
        var result = await firestore
            .collection('users')
            .where('storeName', isEqualTo: storeName)
            .get();

        for (doc in result.docs) {
          //if (doc['storeName'] == storeName) {
          setState(() {
            processList.add(doc);
          });
        }

        //checkUserPart = List<String>.filled(processList.length, "");
      }
    } catch (e) {
      print(e);
    }
  }

  getSearchData(String searchUser) async {
    processList = [];

    try {
      try {
        var userResult = await firestore
            .collection('users')
            .doc(auth!.email.toString())
            .get();

        setState(() {
          storeName = userResult['storeName'];
          userType = userResult['userType'];
          userId = userResult['userId'];
        });
      } catch (e) {}

      if (userType == "2") {
        var result = await firestore
            .collection('users')
            .where('storeName', isEqualTo: storeName)
            .get();

        for (doc in result.docs) {
          setState(() {
            processList.add(doc);
          });
        }
      } else {
        var result = searchUser == ""
            ? await firestore
                .collection('users')
                .where('storeName', isEqualTo: storeName)
                .where('userName', isEqualTo: searchUser)
                .get()
            : await firestore
                .collection('users')
                .where('storeName', isEqualTo: storeName)
                .where('userName', isEqualTo: searchUser)
                .get();

        for (doc in result.docs) {
          dataCount += 1;

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
  static const String _title = '사용자 관리';
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();

  final List<int> shades = [100, 200, 300, 400, 500, 600, 700, 800, 900];
  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();
  int checkDate = 0;
  @override
  Widget build(BuildContext context) {
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
          '사용자 관리',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SizedBox(
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
                          padding: EdgeInsets.only(
                            top: 20,
                            left: 20,
                          ),
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [],
                              ),
                              Text(
                                '사용자명',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 60,
                                width: 300,
                                child: CustomTextFormField(
                                  lines: 1,
                                  hint: "",
                                  controller: searchUser,
                                  searchMethod: getSearchData,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  top: 5,
                                ),
                                width: 80,
                                child: ElevatedButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white, //글자색
                                    onSurface:
                                        Colors.white, //onpressed가 null일때 색상
                                    backgroundColor: HexColor('#172543'),
                                    shadowColor: Colors.white, //그림자 색상
                                    elevation: 1, // 버튼 입체감
                                    textStyle: TextStyle(fontSize: 12),
                                    //padding: EdgeInsets.all(16.0),
                                    minimumSize: Size(75, 40), //최소 사이즈
                                    maximumSize: Size(75, 40), //최소 사이즈,
                                    side: BorderSide(
                                        color: HexColor('#172543'),
                                        width: 1.0), //선
                                    shape:
                                        StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                    alignment: Alignment.center,
                                  ), //글자위치 변경
                                  onPressed: () {
                                    getSearchData(searchUser.text.toString());
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
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'No',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '담당자명',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '소속',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '담당업무선택',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '담당업무',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '이메일',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '연락처',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '담당자권한',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '등록일자',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '승인여부',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '계정승인/수정',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        // DataColumn(
                        //   label: Text(
                        //     '계정삭제',
                        //     style: TextStyle(
                        //         fontStyle: FontStyle.italic,
                        //         fontWeight: FontWeight.w600),
                        //   ),
                        // ),
                      ],
                      rows: List<DataRow>.generate(
                        processList.length,
                        (index) => DataRow(
                          cells: <DataCell>[
                            DataCell(Center(
                              child: Text((index + 1).toString()),
                            )),
                            DataCell(Center(
                              child: Container(
                                  child: Text(processList[index]['userName'])),
                            )),
                            DataCell(Center(
                              child: Container(
                                  child: Text(processList[index]['storeName'])),
                            )),
                            DataCell(Center(
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

                                value: '선택',

                                // userType == "1"
                                //     ? tailorPartInit
                                //     : factoryPartInit,

                                items: userType == "1"
                                    ? userTailorPart.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Container(
                                            child: Text(
                                              items,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        );
                                      }).toList()
                                    : userFactoryPart.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(
                                            items,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        );
                                      }).toList(),

                                onChanged: (String? newValue) {
                                  setState(() {
                                    //checkUserPart = newValue!;
                                    userPart = newValue!;
                                  });
                                },
                              ),
                            )),
                            DataCell(Center(
                              child: Container(
                                  child: Text(userType == "1"
                                      ? processList[index]['userTailorPart'] ??
                                          ""
                                      : processList[index]['userFactoryPart'] ??
                                          "")),
                            )),
                            DataCell(Center(
                              child: Container(
                                  child: Text(processList[index]['userId'])),
                            )),
                            DataCell(Center(
                              child: Container(
                                  child: Text(processList[index]['userPhone'] ==
                                          null
                                      ? ""
                                      : phoneNumber(
                                          processList[index]['userPhone']))),
                            )),
                            DataCell(Center(
                              child: Container(
                                  child: Text(
                                      processList[index]['userGrade'] == "1"
                                          ? "관리자"
                                          : "일반사용자")),
                            )),
                            DataCell(Center(
                              child: Container(
                                  child:
                                      Text(processList[index]['registDate'])),
                            )),
                            DataCell(Center(
                              child: Container(
                                  child: Text(
                                      processList[index]['userAuthority'] == "1"
                                          ? "승인"
                                          : "대기")),
                            )),
                            DataCell(Center(
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 5,
                                ),
                                width: 80,
                                child: ElevatedButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white, //글자색
                                    onSurface:
                                        Colors.white, //onpressed가 null일때 색상
                                    backgroundColor: HexColor('#172543'),
                                    shadowColor: Colors.white, //그림자 색상
                                    elevation: 1, // 버튼 입체감
                                    textStyle: TextStyle(fontSize: 12),
                                    //padding: EdgeInsets.all(16.0),
                                    minimumSize: Size(75, 35), //최소 사이즈
                                    maximumSize: Size(75, 35), //최소 사이즈,
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
                                        title: '계정 변경',
                                        message: '해당 계정의 정보를 변경 하시겠습니까?',
                                        okCallback: () {
                                          userType == "1"
                                              ? _updateUserData(
                                                  processList[index]['userId'],
                                                  userPart,
                                                  userType)
                                              : _updateUserData(
                                                  processList[index]['userId'],
                                                  userPart,
                                                  userType);
                                          //controller.ChangeInitPage();
                                          //Get.to(SearchPage());
                                          Get.back();
                                          setState(() {
                                            getData();
                                          });
                                        },
                                        cancleCallback: Get.back,
                                      ),
                                    );
                                  },
                                  child: Center(
                                    child: processList[index]
                                                ['userAuthority'] !=
                                            "1"
                                        ? Text('승인')
                                        : Text('수정'),
                                  ),
                                ),
                              ),
                            )),
                            // userId != processList[index]['userId']
                            //     ? DataCell(Center(
                            //         child: Container(
                            //           padding: EdgeInsets.only(
                            //             top: 5,
                            //           ),
                            //           width: 80,
                            //           child: ElevatedButton(
                            //             style: TextButton.styleFrom(
                            //               primary: Colors.white, //글자색
                            //               onSurface: Colors
                            //                   .white, //onpressed가 null일때 색상
                            //               backgroundColor: HexColor('#172543'),
                            //               shadowColor: Colors.white, //그림자 색상
                            //               elevation: 1, // 버튼 입체감
                            //               textStyle: TextStyle(fontSize: 12),
                            //               //padding: EdgeInsets.all(16.0),
                            //               minimumSize: Size(75, 35), //최소 사이즈
                            //               maximumSize: Size(75, 35), //최소 사이즈,
                            //               side: BorderSide(
                            //                   color: HexColor('#172543'),
                            //                   width: 1.0), //선
                            //               shape:
                            //                   StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                            //               alignment: Alignment.center,
                            //             ), //글자위치 변경
                            //             onPressed: () {
                            //               showDialog(
                            //                   context: Get.context!,
                            //                   builder: (context) =>
                            //                       MessagePopup(
                            //                         title: '계정삭제',
                            //                         message: '해당 계정을 삭제하시겠습니까?',
                            //                         okCallback: () async {
                            //                           // await firestore
                            //                           //     .collection(
                            //                           //         'users')
                            //                           //     .doc(processList[
                            //                           //             index]
                            //                           //         [
                            //                           //         'userId'])
                            //                           //     .delete();

                            //                           deleteUser(
                            //                               processList[index]
                            //                                   ['userId']);
                            //                           Get.back();
                            //                           setState(() {
                            //                             getData();
                            //                           });
                            //                           //controller.ChangeInitPage();
                            //                         },
                            //                         cancleCallback: Get.back,
                            //                       ));
                            //             },
                            //             child: Center(
                            //               child: Text('삭제'),
                            //             ),
                            //           ),
                            //         ),
                            //       ))
                            //     : DataCell(Container()),
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

  String phoneNumber(String val) {
    String returnVal = val.replaceAllMapped(RegExp(r'(\d{3})(\d{3,4})(\d+)'),
        (Match m) => "${m[1]}-${m[2]}-${m[3]}");

    return returnVal;
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

  _updateUserData(String userId, String checkUserPart, userType) {
    userType == "1"
        ? FirebaseFirestore.instance.collection('users').doc(userId).set({
            //'suitDesign': _suitDesign!.toJson(),
            'userAuthority': '1',
            'userTailorPart': checkUserPart,
          }, SetOptions(merge: true))
        : FirebaseFirestore.instance.collection('users').doc(userId).set({
            //'suitDesign': _suitDesign!.toJson(),
            'userAuthority': '1',
            'userFactoryPart': checkUserPart,
          }, SetOptions(merge: true));
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
