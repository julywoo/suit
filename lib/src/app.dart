import 'package:badges/badges.dart';
import 'package:bykak/src/components/alarm_popup.dart';
import 'package:bykak/src/components/hex_color.dart';

import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/model/factory/wages_charge_model.dart';
import 'package:bykak/src/pages/factory/charge_list_page.dart';
import 'package:bykak/src/pages/factory/factory_cost_update.dart';
import 'package:bykak/src/pages/factory/wages_charge_page.dart';
import 'package:bykak/src/pages/home.dart';
import 'package:bykak/src/pages/home_main.dart';
import 'package:bykak/src/pages/progress_page.dart';
import 'package:bykak/src/pages/qr_scan_page.dart';
import 'package:bykak/src/pages/qr_scanner_page.dart';
import 'package:bykak/src/pages/schedule_manage_page.dart';
import 'package:bykak/src/pages/search_page.dart';
import 'package:bykak/src/pages/user_manage_page.dart';
import 'package:bykak/src/pages/user_page.dart';
import 'package:bykak/src/user/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  late TabController _tabController; // use this instead of DefaultTabController
  var _userType;
  var _userGrade;
  @override
  void initState() {
    _tabController =
        TabController(length: 2, vsync: this); // initialise it here

    _getUserType();
    getData();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  User? auth = FirebaseAuth.instance.currentUser;

  _getUserType() async {
    try {
      var userType = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth!.email.toString())
          .get();
      setState(() {
        _userType = userType['userType'];
        _userGrade = userType['userGrade'];
      });
    } catch (e) {
      _userGrade = "";
    }
  }

  int alarmCount = 0;
  List alarmList = [];
  getData() async {
    alarmCount = 0;
    try {
      var alarmResult = await FirebaseFirestore.instance
          .collection('alarms')
          .where('recvUserList', isEqualTo: auth!.email.toString())
          .where('readState', isEqualTo: "N")
          .orderBy('sendDate', descending: true)
          .get();

      for (var doc in alarmResult.docs) {
        alarmCount += 1;
        //alarmList.add(doc);
      }

      setState(() {
        alarmCount = alarmCount;
      });
    } catch (e) {}
  }

  getDataCnt() async {
    alarmCount = 0;
    try {
      var alarmResult = await FirebaseFirestore.instance
          .collection('alarms')
          .where('recvUserList', isEqualTo: auth!.email.toString())
          .where('readState', isEqualTo: "N")
          .orderBy('sendDate', descending: true)
          .get();

      for (var doc in alarmResult.docs) {
        alarmCount += 1;
        //alarmList.add(doc);
      }

      setState(() {
        alarmCount = alarmCount;
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Future<void> signOut() async {
    await Firebase.initializeApp();

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthVal = MediaQuery.of(context).size.width;
    final _controller = widthVal < 481
        ? SidebarXController(selectedIndex: 0, extended: true)
        : SidebarXController(selectedIndex: 0, extended: true);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return WillPopScope(
      child: widthVal < 481
          ? Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.black,
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                elevation: 0,
              ),
              drawer: SidebarX(
                controller: _controller,
                theme: SidebarXTheme(
                  ///  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: mainColor,
                    //  borderRadius: BorderRadius.circular(20),
                  ),

                  textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                  selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                  itemTextPadding: const EdgeInsets.only(left: 30),
                  selectedItemTextPadding: const EdgeInsets.only(left: 30),
                  itemDecoration: BoxDecoration(
                    border: Border.all(color: mainColor),
                  ),
                  selectedIconTheme:
                      IconThemeData(size: 15, color: Colors.white),
                  selectedItemDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: mainColor.withOpacity(0.37),
                    ),
                    gradient: const LinearGradient(
                      colors: [accentMainColor, mainColor],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.28),
                        blurRadius: 30,
                      )
                    ],
                  ),
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                extendedTheme: const SidebarXTheme(
                  width: 200,
                  decoration: BoxDecoration(
                    color: mainColor,
                  ),
                ),
                footerDivider: divider,
                headerBuilder: (context, extended) {
                  return const SizedBox(
                    height: 70,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      // /child: Image.asset('assets/images/avatar.png'),
                    ),
                  );
                },
                footerBuilder: (context, extended) {
                  return extended == true
                      ? Container(
                          height: 100,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: Get.context!,
                                  builder: (context) => MessagePopup(
                                        title: '로그아웃',
                                        message: '로그아웃 하시겠습니까?',
                                        okCallback: () {
                                          signOut();
                                          //controller.ChangeInitPage();
                                          Get.offAll(LoginPage());
                                        },
                                        cancleCallback: Get.back,
                                      ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                Text(
                                  '로그아웃',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Container(),
                                Container(),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: 100,
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: Get.context!,
                                    builder: (context) => MessagePopup(
                                          title: '로그아웃',
                                          message: '로그아웃 하시겠습니까?',
                                          okCallback: () {
                                            signOut();
                                            //controller.ChangeInitPage();
                                            Get.offAll(LoginPage());
                                          },
                                          cancleCallback: Get.back,
                                        ));
                              },
                              icon: Icon(
                                size: 15,
                                Icons.logout,
                                color: Colors.white,
                              )),
                        );
                },
                //_userType "1" 테일러샵 "2" 제작공장
                items: _userType == "1"
                    ? _userGrade == "1"
                        ? [
                            SidebarXItem(
                              iconWidget: Container(
                                height: 20,
                                child: Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                              //icon: Icons.home,
                              label: 'Home',
                              onTap: () {
                                Get.to(App());
                              },
                            ),

                            SidebarXItem(
                              label: '알림',
                              iconWidget: alarmCount == 0
                                  ? Container(
                                      child: Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    )
                                  : Container(
                                      child: Badge(
                                        badgeContent:
                                            Text(alarmCount.toString()),
                                        child: Icon(
                                          Icons.notifications,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                              onTap: () {
                                showDialog(
                                    context: Get.context!,
                                    builder: (context) => AlarmPopup(
                                          title: '알림',
                                          //alarmList: alarmList,
                                          okCallback: () {
                                            try {
                                              setState(() {
                                                getDataCnt();
                                              });
                                            } catch (e) {}

                                            Get.back();
                                          },
                                          cancleCallback: Get.back,
                                        ));
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.search,
                              label: '상담 내역 조회',
                              onTap: () {
                                Get.to(SearchPage());
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.view_timeline,
                              label: '제작현황',
                              onTap: () {
                                Get.to(ProgressPage());
                              },
                            ),
                            // SidebarXItem(
                            //   icon: Icons.schedule_sharp,
                            //   label: '일정관리',
                            //   onTap: () {
                            //     Get.to(ScheduleManage());
                            //   },
                            // ),
                            // SidebarXItem(
                            //   icon: Icons.calendar_month_sharp,
                            //   label: '캘린더',
                            //   onTap: () {
                            //     Get.to(ProgressCalendar());
                            //   },
                            // ),

                            SidebarXItem(
                              icon: Icons.list,
                              label: '청구 목록 조회',
                              onTap: () {
                                Get.to(ChargeListPage());
                              },
                            ),
                            // SidebarXItem(
                            //   icon: Icons.qr_code_scanner_sharp,
                            //   label: 'QR 스캐너',
                            //   onTap: () {
                            //     Get.to(QrScannerPage());
                            //   },
                            // ),

                            SidebarXItem(
                              icon: Icons.people,
                              label: '사용자 관리',
                              onTap: () {
                                Get.to(UserManagePage());
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.person,
                              label: '마이페이지',
                              onTap: () {
                                Get.to(UserPage());
                              },
                            ),
                          ]
                        : [
                            SidebarXItem(
                              iconWidget: Container(
                                height: 20,
                                child: Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                              //icon: Icons.home,
                              label: 'Home',
                              onTap: () {
                                Get.to(App());
                              },
                            ),

                            SidebarXItem(
                              label: '알림',
                              iconWidget: alarmCount == 0
                                  ? Container(
                                      child: Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    )
                                  : Container(
                                      child: Badge(
                                        badgeContent:
                                            Text(alarmCount.toString()),
                                        child: Icon(
                                          Icons.notifications,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                              onTap: () {
                                showDialog(
                                    context: Get.context!,
                                    builder: (context) => AlarmPopup(
                                          title: '알림',
                                          //alarmList: alarmList,
                                          okCallback: () {
                                            try {
                                              setState(() {
                                                getDataCnt();
                                              });
                                            } catch (e) {}

                                            Get.back();
                                          },
                                          cancleCallback: Get.back,
                                        ));
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.search,
                              label: '상담 내역 조회',
                              onTap: () {
                                Get.to(SearchPage());
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.view_timeline,
                              label: '제작현황',
                              onTap: () {
                                Get.to(ProgressPage());
                              },
                            ),
                            // SidebarXItem(
                            //   icon: Icons.schedule_sharp,
                            //   label: '일정관리',
                            //   onTap: () {
                            //     Get.to(ScheduleManage());
                            //   },
                            // ),
                            // SidebarXItem(
                            //   icon: Icons.calendar_month_sharp,
                            //   label: '캘린더',
                            //   onTap: () {
                            //     Get.to(ProgressCalendar());
                            //   },
                            // ),

                            SidebarXItem(
                              icon: Icons.list,
                              label: '청구 목록 조회',
                              onTap: () {
                                Get.to(ChargeListPage());
                              },
                            ),
                            // SidebarXItem(
                            //   icon: Icons.qr_code_scanner_sharp,
                            //   label: 'QR 스캐너',
                            //   onTap: () {
                            //     Get.to(QrScannerPage());
                            //   },
                            // ),

                            SidebarXItem(
                              icon: Icons.person,
                              label: '마이페이지',
                              onTap: () {
                                Get.to(UserPage());
                              },
                            ),
                          ]
                    : _userGrade == "1"
                        ? [
                            SidebarXItem(
                              iconWidget: Container(
                                child: Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                              label: 'Home',
                              onTap: () {
                                Get.to(App());
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.search,
                              label: '상담 내역 조회',
                              onTap: () {
                                Get.to(SearchPage());
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.calculate,
                              label: '업체별 공임비 조회/수정',
                              onTap: () {
                                Get.to(FactoryCostUpdate());
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.markunread,
                              label: '공임비 청구',
                              onTap: () {
                                Get.to(WagesChargePage());
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.list,
                              label: '청구 목록 조회',
                              onTap: () {
                                Get.to(ChargeListPage());
                              },
                            ),
                            // SidebarXItem(
                            //   icon: Icons.qr_code_scanner_sharp,
                            //   label: 'QR 스캐너',
                            //   onTap: () {
                            //     Get.to(QrScannerPage());
                            //   },
                            // ),
                            SidebarXItem(
                              icon: Icons.people,
                              label: '사용자 관리',
                              onTap: () {
                                Get.to(UserManagePage());
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.person,
                              label: '마이페이지',
                              onTap: () {
                                Get.to(UserPage());
                              },
                            ),
                          ]
                        : [
                            SidebarXItem(
                              iconWidget: Container(
                                child: Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                              label: 'Home',
                              onTap: () {
                                Get.to(App());
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.search,
                              label: '상담 내역 조회',
                              onTap: () {
                                Get.to(SearchPage());
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.calculate,
                              label: '업체별 공임비 조회/수정',
                              onTap: () {
                                Get.to(FactoryCostUpdate());
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.markunread,
                              label: '공임비 청구',
                              onTap: () {
                                Get.to(WagesChargePage());
                              },
                            ),
                            SidebarXItem(
                              icon: Icons.list,
                              label: '청구 목록 조회',
                              onTap: () {
                                Get.to(ChargeListPage());
                              },
                            ),
                            // SidebarXItem(
                            //   icon: Icons.qr_code_scanner_sharp,
                            //   label: 'QR 스캐너',
                            //   onTap: () {
                            //     Get.to(QrScannerPage());
                            //   },
                            // ),
                            SidebarXItem(
                              icon: Icons.person,
                              label: '마이페이지',
                              onTap: () {
                                Get.to(UserPage());
                              },
                            ),
                          ],
              ),
              body: Center(
                child: Home(),
                //child: HomeMain(controller: _controller),
              ),
            )
          : Scaffold(
              body: Row(
              children: [
                SidebarX(
                  controller: _controller,
                  theme: SidebarXTheme(
                    //margin: EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      color: mainColor,
                      //  borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 12),
                    selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    itemTextPadding: const EdgeInsets.only(left: 30),
                    selectedItemTextPadding: const EdgeInsets.only(left: 30),
                    itemDecoration: BoxDecoration(
                      border: Border.all(color: mainColor),
                    ),
                    selectedIconTheme:
                        IconThemeData(size: 15, color: Colors.white),
                    selectedItemDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: mainColor.withOpacity(0.37),
                      ),
                      gradient: const LinearGradient(
                        colors: [accentMainColor, mainColor],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.28),
                          blurRadius: 30,
                        )
                      ],
                    ),
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  extendedTheme: const SidebarXTheme(
                    width: 200,
                    decoration: BoxDecoration(
                      color: mainColor,
                    ),
                    margin: EdgeInsets.only(right: 10),
                  ),
                  footerDivider: divider,
                  showToggleButton: false,
                  headerBuilder: (context, extended) {
                    return SizedBox(
                      height: 120,
                      child: Center(
                        // /child: Image.asset('assets/images/avatar.png'),
                        child: extended == true
                            ? Text(
                                auth!.displayName.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : const Text(''),
                      ),
                    );
                  },
                  footerBuilder: (context, extended) {
                    return Container(
                      height: 100,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: Get.context!,
                              builder: (context) => MessagePopup(
                                    title: '로그아웃',
                                    message: '로그아웃 하시겠습니까?',
                                    okCallback: () {
                                      signOut();
                                      //controller.ChangeInitPage();
                                      Get.offAll(LoginPage());
                                    },
                                    cancleCallback: Get.back,
                                  ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 15,
                            ),
                            Text(
                              '로그아웃',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            Container(),
                            Container(),
                          ],
                        ),
                      ),
                    );
                  },
                  items: _userType == "1"
                      ? _userGrade == "1"
                          ? [
                              SidebarXItem(
                                iconWidget: Container(
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                                label: 'Home',
                                onTap: () {
                                  Get.to(App());
                                },
                              ),
                              SidebarXItem(
                                //icon: Icons.alarm,
                                label: '알림',

                                iconWidget: alarmCount == 0
                                    ? Container(
                                        child: Icon(
                                          Icons.notifications,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      )
                                    : Container(
                                        child: Badge(
                                          badgeContent:
                                              Text(alarmCount.toString()),
                                          child: Icon(
                                            Icons.notifications,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                onTap: () {
                                  showDialog(
                                      context: Get.context!,
                                      builder: (context) => AlarmPopup(
                                            title: '알림',
                                            //alarmList: alarmList,
                                            okCallback: () {
                                              try {
                                                setState(() {
                                                  getDataCnt();
                                                });
                                              } catch (e) {}

                                              Get.back();
                                            },
                                            cancleCallback: Get.back,
                                          ));
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.search,
                                label: '상담 내역 조회',
                                onTap: () {
                                  Get.to(SearchPage());
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.view_timeline,
                                label: '제작현황',
                                onTap: () {
                                  Get.to(ProgressPage());
                                },
                              ),
                              // SidebarXItem(
                              //   icon: Icons.schedule_sharp,
                              //   label: '일정관리',
                              //   onTap: () {
                              //     Get.to(ScheduleManage());
                              //   },
                              // ),
                              // SidebarXItem(
                              //   icon: Icons.calendar_month_sharp,
                              //   label: '캘린더',
                              //   onTap: () {
                              //     Get.to(ProgressCalendar());
                              //   },
                              // ),
                              SidebarXItem(
                                icon: Icons.list,
                                label: '청구 목록 조회',
                                onTap: () {
                                  Get.to(ChargeListPage());
                                },
                              ),
                              // SidebarXItem(
                              //   icon: Icons.qr_code_scanner_sharp,
                              //   label: 'QR 스캐너',
                              //   onTap: () {
                              //     Get.to(QrScannerPage());
                              //   },
                              // ),

                              SidebarXItem(
                                icon: Icons.people,
                                label: '사용자 관리',
                                onTap: () {
                                  Get.to(UserManagePage());
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.person,
                                label: '마이페이지',
                                onTap: () {
                                  Get.to(UserPage());
                                },
                              ),
                            ]
                          : [
                              SidebarXItem(
                                iconWidget: Container(
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                                label: 'Home',
                                onTap: () {
                                  Get.to(App());
                                },
                              ),
                              SidebarXItem(
                                //icon: Icons.alarm,
                                label: '알림',

                                iconWidget: alarmCount == 0
                                    ? Container(
                                        child: Icon(
                                          Icons.notifications,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      )
                                    : Container(
                                        child: Badge(
                                          badgeContent:
                                              Text(alarmCount.toString()),
                                          child: Icon(
                                            Icons.notifications,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                onTap: () {
                                  showDialog(
                                      context: Get.context!,
                                      builder: (context) => AlarmPopup(
                                            title: '알림',
                                            //alarmList: alarmList,
                                            okCallback: () {
                                              try {
                                                setState(() {
                                                  getDataCnt();
                                                });
                                              } catch (e) {}

                                              Get.back();
                                            },
                                            cancleCallback: Get.back,
                                          ));
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.search,
                                label: '상담 내역 조회',
                                onTap: () {
                                  Get.to(SearchPage());
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.view_timeline,
                                label: '제작현황',
                                onTap: () {
                                  Get.to(ProgressPage());
                                },
                              ),
                              // SidebarXItem(
                              //   icon: Icons.schedule_sharp,
                              //   label: '일정관리',
                              //   onTap: () {
                              //     Get.to(ScheduleManage());
                              //   },
                              // ),
                              // SidebarXItem(
                              //   icon: Icons.calendar_month_sharp,
                              //   label: '캘린더',
                              //   onTap: () {
                              //     Get.to(ProgressCalendar());
                              //   },
                              // ),
                              SidebarXItem(
                                icon: Icons.list,
                                label: '청구 목록 조회',
                                onTap: () {
                                  Get.to(ChargeListPage());
                                },
                              ),
                              // SidebarXItem(
                              //   icon: Icons.qr_code_scanner_sharp,
                              //   label: 'QR 스캐너',
                              //   onTap: () {
                              //     Get.to(QrScannerPage());
                              //   },
                              // ),

                              SidebarXItem(
                                icon: Icons.person,
                                label: '마이페이지',
                                onTap: () {
                                  Get.to(UserPage());
                                },
                              ),
                            ]
                      : _userGrade == "1"
                          ? [
                              SidebarXItem(
                                iconWidget: Container(
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                                label: 'Home',
                                onTap: () {
                                  Get.to(App());
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.search,
                                label: '작업지시서 조회',
                                onTap: () {
                                  Get.to(SearchPage());
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.calculate,
                                label: '업체별 공임비 조회/수정',
                                onTap: () {
                                  Get.to(const FactoryCostUpdate());
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.markunread,
                                label: '공임비 청구',
                                onTap: () {
                                  Get.to(WagesChargePage());
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.list,
                                label: '청구 목록 조회',
                                onTap: () {
                                  Get.to(ChargeListPage());
                                },
                              ),
                              // SidebarXItem(
                              //   icon: Icons.qr_code_scanner_sharp,
                              //   label: 'QR 스캐너',
                              //   onTap: () {
                              //     Get.to(QrScannerPage());
                              //   },
                              // ),
                              SidebarXItem(
                                icon: Icons.people,
                                label: '사용자 관리',
                                onTap: () {
                                  Get.to(UserManagePage());
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.person,
                                label: '마이페이지',
                                onTap: () {
                                  Get.to(UserPage());
                                },
                              ),
                            ]
                          : [
                              SidebarXItem(
                                iconWidget: Container(
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                                label: 'Home',
                                onTap: () {
                                  Get.to(App());
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.search,
                                label: '작업지시서 조회',
                                onTap: () {
                                  Get.to(SearchPage());
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.calculate,
                                label: '업체별 공임비 조회/수정',
                                onTap: () {
                                  Get.to(const FactoryCostUpdate());
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.markunread,
                                label: '공임비 청구',
                                onTap: () {
                                  Get.to(WagesChargePage());
                                },
                              ),
                              SidebarXItem(
                                icon: Icons.list,
                                label: '청구 목록 조회',
                                onTap: () {
                                  Get.to(ChargeListPage());
                                },
                              ),
                              // SidebarXItem(
                              //   icon: Icons.qr_code_scanner_sharp,
                              //   label: 'QR 스캐너',
                              //   onTap: () {
                              //     Get.to(QrScannerPage());
                              //   },
                              // ),
                              SidebarXItem(
                                icon: Icons.person,
                                label: '마이페이지',
                                onTap: () {
                                  Get.to(UserPage());
                                },
                              ),
                            ],
                ),
                Expanded(
                  child: Center(
                    //child: HomeMain(controller: _controller),
                    child: Home(),
                  ),
                ),
              ],
            )),
      onWillPop: () async {
        return false;
      },
    );
  }
}
