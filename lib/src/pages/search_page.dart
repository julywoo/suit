import 'package:bykak/src/app.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/process_popup.dart';
import 'package:bykak/src/model/suit_option.dart';
import 'package:bykak/src/pages/input_shirt_size.dart';
import 'package:bykak/src/pages/input_top_size.dart';
import 'package:bykak/src/pages/result_page.dart';
import 'package:bykak/src/pages/result_page_web.dart';
import 'package:bykak/src/pages/shirt_result_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

final firestore = FirebaseFirestore.instance;

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();

  String _searchText = "";

  // //var f = NumberFormat('##:##');
  // final f = new DateFormat('hh:mm');

  _SearchPageState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  User? auth = FirebaseAuth.instance.currentUser;
  String storeName = "";
  String userType = "";
  int limitcount = 10;
  int capatityCnt = 0;
  var doc;
  late List<String> factoryList;
  late List<String> factoryCapacity;
  late List<String> brandRateList;
  getData() async {
    try {
      factoryList = [];
      factoryCapacity = [];
      var result = await firestore
          .collection('users')
          //.orderBy('productionProcess', descending: false)
          .where('userId', isEqualTo: auth!.email.toString())
          .get();

      for (doc in result.docs) {
        setState(() {
          storeName = doc['storeName'];
          userType = doc['userType'];
        });
      }

      try {
        var factoryResult = await firestore
            .collection('produceCost')
            //.doc(doc['storeName'])
            .get();

        for (var doc in factoryResult.docs) {
          factoryList.add(doc['factoryName']);
        }
      } catch (e) {}

      brandRateList = [];
      var brandListResult =
          await firestore.collection('tailorShop').doc(doc['storeName']).get();

      setState(() {
        if (brandListResult['brandRate1'] != "") {
          brandRateList.add(brandListResult['brandRate1']);
        }
        if (brandListResult['brandRate2'] != "") {
          brandRateList.add(brandListResult['brandRate2']);
        }
        if (brandListResult['brandRate3'] != "") {
          brandRateList.add(brandListResult['brandRate3']);
        }
        if (brandListResult['brandRate4'] != "") {
          brandRateList.add(brandListResult['brandRate4']);
        }
        if (brandListResult['brandRate5'] != "") {
          brandRateList.add(brandListResult['brandRate5']);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getData();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
  }

  @override
  void dispose() {
    // 세로 화면 고정

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  //final auth = FirebaseAuth.instance.currentUser;

  Widget _buildBody(BuildContext context) {
    return userType == "2"
        ? StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('factory', isEqualTo: storeName)
                .orderBy('consultDate', descending: true)
                .limit(limitcount)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return _buildList(context, snapshot.data!.docs);
            },
          )
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('storeName', isEqualTo: storeName)
                .orderBy('consultDate', descending: true)
                .limit(limitcount)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return _buildList(context, snapshot.data!.docs);
            },
          );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    //String storeName = auth!.displayName.toString();
    var widVal = MediaQuery.of(context).size.width;

    List<DocumentSnapshot> searchResults = [];
    for (DocumentSnapshot d in snapshot) {
      if (userType == "2") {
        if (d.data().toString().contains(_searchText)) {
          searchResults.add(d);
        }
        //}
      } else {
        if (d.data().toString().contains(_searchText)) {
          searchResults.add(d);
        }
        //}
      }
    }

    return Expanded(
      child:
          // _isLoading
          //     ? Center(
          //         child: SizedBox(
          //           height: 30,
          //           width: 30,
          //           child: CircularProgressIndicator(
          //             color: HexColor('#172543'),
          //           ),
          //         ),
          //       )
          //     :
          Container(
        width: widVal < 481 ? widVal : 800,
        child: LazyLoadScrollView(
          isLoading: true,
          onEndOfPage: () => loadMore(),
          scrollOffset: 10,
          child: ListView(
            children: searchResults
                .map((json) => _buildListItem(context, json))
                .toList(),
          ),
        ),
      ),
    );
  }

  bool _isLoading = false;
  void loadMore() async {
    setState(() {
      _isLoading = true;
    });

    // Add in an artificial delay
    await new Future.delayed(const Duration(seconds: 2));
    setState(
      () {
        _isLoading = false;
        limitcount += 10;
      },
    );
  }

  Future _loadMore() async {}

  Widget _buildListItem(BuildContext context, data) {
    String orderType = "";
    var step, stepVal;
    try {
      step = data['productionProcess'];
      step = data['productionProcess'];
      stepVal = processOption[step];

      if (data['orderType'] == "0") {
        orderType = "SUIT";
      } else if (data['orderType'] == "1") {
        orderType = "JACKET";
      } else if (data['orderType'] == "2") {
        orderType = "SHIRT";
      } else if (data['orderType'] == "3") {
        orderType = "PANTS";
      } else if (data['orderType'] == "4") {
        orderType = "VEST";
      } else {
        orderType = "COAT";
      }
    } catch (e) {
      step = 0;
      stepVal = processOption[step];
    }

    var widVal = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),

      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: HexColor('#172543')),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          child: ListTile(
            title: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                          color: HexColor('#FFFFFF'),
                          borderRadius: new BorderRadius.circular(20),
                          border: Border.all()),
                      child: Center(
                        child: Text(
                          orderType,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    userType == "1"
                        ? Container(
                            padding: EdgeInsets.only(left: 10),
                            child: ElevatedButton(
                              style: TextButton.styleFrom(
                                primary: Colors.white, //글자색
                                onSurface: Colors.white, //onpressed가 null일때 색상
                                //backgroundColor: HexColor('#172543'),
                                backgroundColor: HexColor(processColor[step]),
                                shadowColor: Colors.white, //그림자 색상
                                elevation: 1, // 버튼 입체감
                                textStyle: TextStyle(fontSize: 10),
                                //padding: EdgeInsets.all(16.0),
                                minimumSize: Size(100, 30), //최소 사이즈
                                side: BorderSide(
                                    color: HexColor(processColor[step]),
                                    width: 1.0), //선
                                shape:
                                    StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                alignment: Alignment.center,
                              ), //글자위치 변경
                              onPressed: () {
                                step == processOption.length - 1
                                    ? null
                                    : showDialog(
                                        context: Get.context!,
                                        builder: (context) => ProcessPopup(
                                              title: '제작 현황 변경',
                                              message:
                                                  '제작 현황을 아래와 같이 변경 하시겠습니까?',
                                              factoryList: factoryList,
                                              brandRateList: brandRateList,
                                              factoryCapacity: factoryCapacity,
                                              step: step,
                                              orderNo: data['orderNo'],
                                              userId: auth!.email.toString(),
                                              customerName: data['name'],
                                              storeName: storeName,
                                              factoryName:
                                                  data['factory'] ?? "",
                                              orderType:
                                                  data['orderType'] ?? "",
                                              pabricSub1:
                                                  data['pabricSub1'] ?? "",
                                              pabricSub2:
                                                  data['pabricSub2'] ?? "",
                                              length: processOption.length - 1,
                                              cancleCallback: Get.back,
                                            ));
                              },
                              child: Text(stepVal),
                            ),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data['name']
                        //store.StoreName,
                        ),
                    Text(data['consultDate']
                        //store.StoreName,
                        ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    // data['topSize']['shoulder'] != null ||
                    //         data['shirtSize']['shoulder'] != null

                    // userType == "1"
                    //     ? ElevatedButton(
                    //         style: TextButton.styleFrom(
                    //           primary: HexColor('#172543'), //글자색
                    //           onSurface: Colors.white, //onpressed가 null일때 색상
                    //           backgroundColor: HexColor('#FFFFFF'),
                    //           shadowColor: Colors.white, //그림자 색상
                    //           elevation: 1, // 버튼 입체감
                    //           textStyle: TextStyle(fontSize: 12),
                    //           //padding: EdgeInsets.all(16.0),
                    //           minimumSize: Size(
                    //               widVal < 481
                    //                   ? MediaQuery.of(context).size.width * 0.35
                    //                   : 800 * 0.35,
                    //               30), //최소 사이즈
                    //           side: BorderSide(
                    //               color: HexColor('#172543'), width: 1.0), //선
                    //           shape:
                    //               StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                    //           alignment: Alignment.center,
                    //         ), //글자위치 변경
                    //         onPressed: () {
                    //           try {
                    //             data['orderType'] == '2'
                    //                 ? Get.to(InputShirtSize(), arguments: {
                    //                     'orderNo': data['orderNo'],
                    //                     'orderData': data,
                    //                   })
                    //                 : Get.to(InputTopSize(), arguments: {
                    //                     'orderNo': data['orderNo'],
                    //                     'orderData': data,
                    //                   });
                    //           } catch (e) {
                    //             print(e);
                    //           }
                    //         },
                    //         child: Text('사이즈 입력'))
                    //     : Container(),
                    ElevatedButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white, //글자색
                          onSurface: Colors.white, //onpressed가 null일때 색상
                          backgroundColor: HexColor('#172543'),
                          shadowColor: Colors.white, //그림자 색상
                          elevation: 1, // 버튼 입체감
                          textStyle: TextStyle(fontSize: 12),
                          //padding: EdgeInsets.all(16.0),
                          minimumSize: Size(
                              widVal < 481
                                  ? MediaQuery.of(context).size.width * 0.35
                                  : 800 * 0.35,
                              30), //최소 사이즈
                          side: BorderSide(
                              color: HexColor('#172543'), width: 1.0), //선
                          shape:
                              StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                          alignment: Alignment.center,
                        ), //글자위치 변경
                        onPressed: () {
                          try {
                            // data['orderType'] == '2'
                            //     ? Get.to(ShirtResultPage(), arguments: {
                            //         'data': data,
                            //         'orderNo': data['orderNo']
                            //       })
                            //     :
                            widVal > 480
                                ? Get.to(ResultPageWeb(), arguments: {
                                    'data': data,
                                    'orderNo': data['orderNo'],
                                  })
                                : Get.to(ResultPageWeb(), arguments: {
                                    'data': data,
                                    'orderNo': data['orderNo'],
                                  });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text('작업지시서 조회')),
                  ],
                ),
              ],
            ),
            // subtitle: (Text(store.StoreAddr)),
          ),
        ),
      ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var widthVal = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#172543'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.white),
        ),
        elevation: 0,
        title: Text(
          '작업지시서 조회',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(App());
            },
            icon: Icon(Icons.home_filled, size: 25.0, color: Colors.white),
          ),
          Container(
            width: 25,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  width: widthVal < 481 ? widthVal : 800,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextField(
                            focusNode: focusNode,
                            style: TextStyle(fontSize: 16),
                            autofocus: false,
                            controller: _filter,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black87,
                                ),
                                hintText: '검색',
                                labelStyle: TextStyle(color: Colors.black38),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor('#172543')),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor('#172543')),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor('#172543')),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBody(context),
                // TextButton(
                //   onPressed: () {
                //     setState(() {
                //       limitcount = limitcount + 10;
                //     });
                //   },
                //   child: Container(
                //     height: 30,
                //     width: 300,
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Text(
                //           '더보기',
                //           style: TextStyle(color: HexColor('#172543')),
                //         ),
                //         Icon(
                //           Icons.arrow_drop_down,
                //           color: HexColor('#172543'),
                //         )
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateProcess(int step, String orderNo) {
    try {
      FirebaseFirestore.instance.collection('orders').doc(orderNo).set({
        //'suitDesign': _suitDesign!.toJson(),
        'productionProcess': step
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  void FailAlert() {
    Fluttertoast.showToast(
        msg: "신체 사이즈 미입력 작업 지시서\n 고객의 사이즈를 입력하세요.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffF44336),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
