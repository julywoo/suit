import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:bykak/src/components/alert_fucntion.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/responsive.dart';
import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/shirt_size_model.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/model/vest_size_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class CustomerList extends StatefulWidget {
  CustomerList({Key? key}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList>
    with TickerProviderStateMixin {
  final controller1 = ScrollController();
  final controllerPoint = TextEditingController();
  //final controller2 = ScrollController();

  final textController = TextEditingController();
  String _searchText = "";
  late TabController _tabController;
  var controller2;
  bool _isLoading = true;

  User? auth = FirebaseAuth.instance.currentUser;

  final firestore = FirebaseFirestore.instance;
  String storeName = "";
  getData() async {
    try {
      var userResult =
          await firestore.collection('users').doc(auth!.email.toString()).get();

      setState(() {
        storeName = userResult['storeName'];
      });
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    textController.addListener(aaaA);
    getData();
    setState(() {
      _isLoading = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    // 텍스트에디팅컨트롤러를 제거하고, 등록된 리스너도 제거된다.
    textController.dispose();
    super.dispose();
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('customers')
          .orderBy('lastVisitDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: HexColor('#172543'),
              ),
            ),
          );
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    //String storeName = auth!.displayName.toString();
    var widVal = MediaQuery.of(context).size.width;

    List<DocumentSnapshot> searchResults = [];
    for (DocumentSnapshot d in snapshot) {
      if (_searchText.isNotEmpty) {
        if (d.data().toString().contains(_searchText) &&
            d.data().toString().contains(storeName)) {
          searchResults.add(d);
        }
      }
    }

    return Container(
      child: ListView(
        children:
            searchResults.map((json) => _buildListItem(context, json)).toList(),
      ),
    );
  }

  String name = "";
  String phone = "";
  String birthDate = "";
  String gender = "";
  int point = 0;
  int accruedPoint = 0;
  int purchaseCount = 0;
  int purchaseAmount = 0;

  String firstVisitDate = "";
  String lastVisitDate = "";

  String etc = "";
  String height = "";
  String weight = "";
  String shoulderShape = "";
  String legShape = "";
  String posture = "";
  String eventAgree = "";
  List pointHistory = [];

  late TopSize? topSize;

  late BottomSize? bottomSize;
  late VestSize? vestSize;
  late ShirtSize? shirtSize;

  Widget _buildListItem(BuildContext context, data) {
    controller2 = PrimaryScrollController.of(context);
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      phoneMaskingFormat(data['phone']),
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      data['name'],
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  data['purchaseCount'] == 1
                      ? (dateFormat(data['firstVisitDate']) + ' 최초방문')
                      : (dateFormat(data['lastVisitDate']) + ' 최종방문'),
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Row(
                  children: [
                    Text(
                      '보유 적립금',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      numberFormat(data['point']) + ' P',
                      style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Text(
                      '누적 적립금',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      numberFormat(data['accruedPoint']) + ' P',
                      style: TextStyle(
                          color: HexColor('e8764e'),
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
                child: Text(
              '방문 상담 횟수 ' + data['purchaseCount'].toString() + '회',
              style: TextStyle(fontSize: 13),
            )),
          ],
        ),
      ),
      onTap: () {
        setState(
          () {
            detailView = true;
            _isLoading = true;
            Future.delayed(Duration(seconds: 1), () {
              setState(() {
                _isLoading = false;
              });
            });
            _tabController =
                TabController(length: 5, vsync: this, initialIndex: 0);
            controller2?.animateTo(0,
                duration: Duration(milliseconds: 100), curve: Curves.ease);
            name = data['name'];
            phone = data['phone'];
            point = data['point'];
            accruedPoint = data['accruedPoint'];
            purchaseCount = data['purchaseCount'];

            purchaseAmount = data['purchaseAmount'] ?? 0;
            firstVisitDate = data['firstVisitDate'] ?? ' ';

            lastVisitDate = data['lastVisitDate'] ?? ' ';

            birthDate = data['birthDate'] ?? '생일 정보가 없습니다.';
            gender = data['gender'] ?? ' ';
            etc = data['etc'] ?? ' ';
            height = data['height'] ?? ' ';
            weight = data['weight'] ?? ' ';
            shoulderShape = data['shoulderShape'] ?? ' ';
            legShape = data['legShape'] ?? ' ';
            posture = data['posture'] ?? ' ';
            eventAgree = data['eventAgree'];
          },
        );
      },
    );
  }

  bool detailView = false;
  void aaaA() {
    setState(() {
      _searchText = textController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black),
        ),
        elevation: 2,
        title: Text(
          '고객 관리',
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      body: Responsive.isMobile(context)
          ? Container(
              padding: EdgeInsets.all(10),
              height: Get.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      detailView
                          ? Container(
                              width: Get.width * 0.9,
                              height: Get.height,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: detailView
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
                                        : SingleChildScrollView(
                                            controller: controller2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10),
                                                          child: IconButton(
                                                            icon: Icon(
                                                                Icons.close),
                                                            onPressed: () {
                                                              setState(() {
                                                                detailView =
                                                                    false;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 20),
                                                        child: Text(
                                                          '고객 기본 정보',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: 80,
                                                                    child: Text(
                                                                      '성명',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black54),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    name,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: 80,
                                                                    child: Text(
                                                                      '연락처',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black54),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    phoneMaskingFormat(
                                                                        phone),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: 80,
                                                                    child: Text(
                                                                      '성별',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black54),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    gender ==
                                                                            '0'
                                                                        ? '남성'
                                                                        : '여성',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: 80,
                                                                    child: Text(
                                                                      '생일',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black54),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    birthDate,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Text(
                                                                '체형',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 30,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '최초 방문일자',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                              Text(
                                                                '최종 방문일자',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                              Text(
                                                                '고객 특이사항',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 30,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                dateFormat(
                                                                    firstVisitDate),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                dateFormat(
                                                                    lastVisitDate),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                etc,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                        height: 1,
                                                        color: Colors.black54,
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: Get.width *
                                                                0.35,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text('보유 적립금'),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                                  child: Text(
                                                                    numberFormat(
                                                                            point) +
                                                                        ' P',
                                                                    style: TextStyle(
                                                                        color:
                                                                            mainColor,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: Get.width *
                                                                0.35,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text('누적 적립금'),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                                  child: Text(
                                                                    numberFormat(
                                                                            accruedPoint) +
                                                                        ' P',
                                                                    style: TextStyle(
                                                                        color: HexColor(
                                                                            'e8764e'),
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: Get.width *
                                                                0.35,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text('방문 횟수'),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                                  child: Text(
                                                                    numberFormat(
                                                                            purchaseCount) +
                                                                        ' 회',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: Get.width *
                                                                0.35,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text('구매 금액'),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                                  child: Text(
                                                                    numberFormat(
                                                                            purchaseAmount) +
                                                                        ' 원',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 20),
                                                        height: 1,
                                                        color: Colors.black54,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 20,
                                                                bottom: 20),
                                                        child: Text(
                                                          '채촌 정보',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          TabBar(
                                                            labelStyle: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            indicatorColor:
                                                                HexColor(
                                                                    '#172543'),
                                                            indicatorWeight:
                                                                3.0,
                                                            controller:
                                                                _tabController,
                                                            tabs: const <
                                                                Widget>[
                                                              Tab(
                                                                text: '자켓',
                                                              ),
                                                              Tab(
                                                                text: '조끼',
                                                              ),
                                                              Tab(
                                                                text: '바지',
                                                              ),
                                                              Tab(
                                                                text: '셔츠',
                                                              ),
                                                              Tab(
                                                                text: '코트',
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            height: 300,
                                                            child: TabBarView(
                                                              controller:
                                                                  _tabController,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      top: 10),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            140,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('어깨'),
                                                                            Spacer(),
                                                                            Text('앞어깨'),
                                                                            Spacer(),
                                                                            Text('등어깨'),
                                                                            Spacer(),
                                                                            Text('진동'),
                                                                            Spacer(),
                                                                            Text('소매'),
                                                                            Spacer(),
                                                                            Text('상동'),
                                                                            Spacer(),
                                                                            Text('암홀'),
                                                                            Spacer(),
                                                                            Text('각도'),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            140,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('앞길'),
                                                                            Spacer(),
                                                                            Text('중동'),
                                                                            Spacer(),
                                                                            Text('하동'),
                                                                            Spacer(),
                                                                            Text('상의장'),
                                                                            Spacer(),
                                                                            Text('앞폼'),
                                                                            Spacer(),
                                                                            Text('뒷폼'),
                                                                            Spacer(),
                                                                            Text('총장'),
                                                                            Spacer(),
                                                                            Text(''),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      top: 10),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            150,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('조끼장'),
                                                                            Spacer(),
                                                                            Text('앞길'),
                                                                            Spacer(),
                                                                            Text('각도'),
                                                                            Spacer(),
                                                                            Text('상동'),
                                                                            Spacer(),
                                                                            Text('중동'),
                                                                            Spacer(),
                                                                            Text(''),
                                                                            Spacer(),
                                                                            Text(''),
                                                                            Spacer(),
                                                                            Text(''),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      top: 10),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            150,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('허리'),
                                                                            Spacer(),
                                                                            Text('힙'),
                                                                            Spacer(),
                                                                            Text('밑위길이'),
                                                                            Spacer(),
                                                                            Text('바깥기장'),
                                                                            Spacer(),
                                                                            Text('허벅지'),
                                                                            Spacer(),
                                                                            Text('둘레'),
                                                                            Spacer(),
                                                                            Text('밑통'),
                                                                            Spacer(),
                                                                            Text(''),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      top: 10),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            140,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('목'),
                                                                            Spacer(),
                                                                            Text('어꺠'),
                                                                            Spacer(),
                                                                            Text('소매'),
                                                                            Spacer(),
                                                                            Text('상동'),
                                                                            Spacer(),
                                                                            Text('중동'),
                                                                            Spacer(),
                                                                            Text('힢'),
                                                                            Spacer(),
                                                                            Text('기장'),
                                                                            Spacer(),
                                                                            Text('암홀'),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            140,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('팔통'),
                                                                            Spacer(),
                                                                            Text('손목'),
                                                                            Spacer(),
                                                                            Text(''),
                                                                            Spacer(),
                                                                            Text(''),
                                                                            Spacer(),
                                                                            Text(''),
                                                                            Spacer(),
                                                                            Text(''),
                                                                            Spacer(),
                                                                            Text(''),
                                                                            Spacer(),
                                                                            Text(''),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Column(),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),

                                                      // Padding(
                                                      //   padding:
                                                      //       const EdgeInsets
                                                      //               .only(
                                                      //           top: 20,
                                                      //           bottom: 20),
                                                      //   child: Text(
                                                      //     '구매이력 및 포인트 적립이력',
                                                      //     style: TextStyle(
                                                      //         fontWeight:
                                                      //             FontWeight
                                                      //                 .bold,
                                                      //         fontSize: 18),
                                                      //   ),
                                                      // ),
                                                      // Container(
                                                      //   height: 250,
                                                      //   child: pointHistory
                                                      //               .length ==
                                                      //           0
                                                      //       ? Center(
                                                      //           child: Text(
                                                      //               '구매 이력 및 포인트 적립 이력이 없습니다.'))
                                                      //       : Text('aaa'),
                                                      // )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                    : Container(
                                        height: Get.height,
                                        child: Center(
                                          child:
                                              Text('고객 검색 후, 조회할 고객을 선택하세요.'),
                                        ),
                                      ),
                              ),
                            )
                          : Container(
                              width: Get.width * 0.9,
                              height: Get.height,
                              child: Card(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),

                                        /// In AnimSearchBar widget, the width, textController, onSuffixTap are required properties.
                                        /// You have also control over the suffixIcon, prefixIcon, helpText and animationDurationInMilli
                                        child: AnimSearchBar(
                                          helpText: '이름 또는 연락처를 입력하세요.',
                                          style: TextStyle(fontSize: 14),
                                          autoFocus: true,
                                          closeSearchOnSuffixTap: false,
                                          width: Get.width,
                                          textController: textController,
                                          onSuffixTap: () {
                                            setState(() {
                                              textController.clear();
                                            });
                                          },
                                          onSubmitted: (String) {},
                                        ),
                                      ),
                                      height: 100,
                                    ), // Expanded(

                                    //   child: Container(),
                                    //   flex: 1,
                                    // ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        // child: SingleChildScrollView(
                                        //   controller: controller1,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  child: _buildBody(context),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //    ),
                                      ),
                                    ),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              height: Get.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 400,
                    height: Get.height,
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, right: 10, left: 10),

                              /// In AnimSearchBar widget, the width, textController, onSuffixTap are required properties.
                              /// You have also control over the suffixIcon, prefixIcon, helpText and animationDurationInMilli
                              child: AnimSearchBar(
                                helpText: '이름 또는 연락처를 입력하세요.',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                autoFocus: true,
                                closeSearchOnSuffixTap: false,
                                width: 400,
                                textController: textController,
                                onSuffixTap: () {
                                  setState(() {
                                    textController.clear();
                                  });
                                },
                                onSubmitted: (String) {},
                              ),
                            ),
                            height: 100,
                          ), // Expanded(

                          //   child: Container(),
                          //   flex: 1,
                          // ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              // child: SingleChildScrollView(
                              //   controller: controller1,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: _buildBody(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //    ),
                            ),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 800,
                    height: Get.height,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: detailView
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
                                : SingleChildScrollView(
                                    controller: controller2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(30),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20),
                                                child: IconButton(
                                                  icon: Icon(
                                                      Icons.arrow_back_sharp),
                                                  onPressed: () {
                                                    setState(() {
                                                      detailView = false;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20),
                                                child: Text(
                                                  '고객 기본 정보',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 80,
                                                            child: Text(
                                                              '성명',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ),
                                                          Text(
                                                            name,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 80,
                                                            child: Text(
                                                              '연락처',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ),
                                                          Text(
                                                            phoneMaskingFormat(
                                                                phone),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 80,
                                                            child: Text(
                                                              '성별',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ),
                                                          Text(
                                                            gender == '0'
                                                                ? '남성'
                                                                : '여성',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 80,
                                                            child: Text(
                                                              '생일',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ),
                                                          Text(
                                                            birthDate,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        '체형',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '최초 방문일자',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                      Text(
                                                        '최종 방문일자',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                      Text(
                                                        '고객 특이사항',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        dateFormat(
                                                            firstVisitDate),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        dateFormat(
                                                            lastVisitDate),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        etc,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                height: 1,
                                                color: Colors.black54,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 150,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('보유 적립금'),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: Text(
                                                                numberFormat(
                                                                        point) +
                                                                    ' P',
                                                                style: TextStyle(
                                                                    color:
                                                                        mainColor,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('누적 적립금'),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: Text(
                                                                numberFormat(
                                                                        accruedPoint) +
                                                                    ' P',
                                                                style: TextStyle(
                                                                    color: HexColor(
                                                                        'e8764e'),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('방문 횟수'),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: Text(
                                                                numberFormat(
                                                                        purchaseCount) +
                                                                    ' 회',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('구매 금액'),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: Text(
                                                                numberFormat(
                                                                        purchaseAmount) +
                                                                    ' 원',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 20,
                                                    ),
                                                    child: Text(
                                                      '포인트',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    height: 50,
                                                    padding: EdgeInsets.only(
                                                        top: 5, right: 10),
                                                    child: TextFormField(
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                      inputFormatters: [
                                                        ThousandsFormatter()
                                                      ],
                                                      controller:
                                                          controllerPoint,
                                                      decoration:
                                                          InputDecoration(
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          borderSide:
                                                              BorderSide(
                                                            color: mainColor,
                                                          ),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 20,
                                                          vertical: 20,
                                                        ),
                                                        hintStyle:
                                                            const TextStyle(
                                                                fontSize: 14),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                      ),
                                                      onChanged: (val) {},
                                                      onSaved: (val) {},
                                                      validator: (val) {
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    right: 10),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: 100,
                                                                  //로그아웃 버튼
                                                                  // width: MediaQuery.of(context).size.width,
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: TextButton
                                                                        .styleFrom(
                                                                      primary:
                                                                          Colors
                                                                              .white, //글자색
                                                                      onSurface:
                                                                          Colors
                                                                              .white, //onpressed가 null일때 색상
                                                                      backgroundColor:
                                                                          HexColor(
                                                                              '#172543'),
                                                                      shadowColor:
                                                                          Colors
                                                                              .white, //그림자 색상
                                                                      elevation:
                                                                          1, // 버튼 입체감
                                                                      textStyle:
                                                                          TextStyle(
                                                                              fontSize: 14),
                                                                      //padding: EdgeInsets.all(16.0),
                                                                      minimumSize: Size(
                                                                          300,
                                                                          50), //최소 사이즈
                                                                      side: BorderSide(
                                                                          color: HexColor(
                                                                              '#172543'),
                                                                          width:
                                                                              1.0), //선
                                                                      shape:
                                                                          StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                    ), //글자위치 변경
                                                                    onPressed:
                                                                        () {
                                                                      changePoint(
                                                                          true,
                                                                          int.parse(controllerPoint
                                                                              .text
                                                                              .toString()
                                                                              .replaceAll(',', '')));
                                                                    },

                                                                    child:
                                                                        const Text(
                                                                            '적립'),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                        Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    right: 10),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: 100,
                                                                  //로그아웃 버튼
                                                                  // width: MediaQuery.of(context).size.width,
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: TextButton
                                                                        .styleFrom(
                                                                      primary:
                                                                          mainColor, //글자색
                                                                      onSurface:
                                                                          mainColor, //onpressed가 null일때 색상
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      shadowColor:
                                                                          mainColor, //그림자 색상
                                                                      elevation:
                                                                          1, // 버튼 입체감
                                                                      textStyle:
                                                                          TextStyle(
                                                                              fontSize: 14),
                                                                      //padding: EdgeInsets.all(16.0),
                                                                      minimumSize: Size(
                                                                          300,
                                                                          50), //최소 사이즈
                                                                      side: BorderSide(
                                                                          color: HexColor(
                                                                              '#172543'),
                                                                          width:
                                                                              1.0), //선
                                                                      shape:
                                                                          StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                    ), //글자위치 변경
                                                                    onPressed:
                                                                        () {
                                                                      changePoint(
                                                                          false,
                                                                          int.parse(controllerPoint
                                                                              .text
                                                                              .toString()
                                                                              .replaceAll(',', '')));
                                                                    },

                                                                    child:
                                                                        const Text(
                                                                            '사용'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                height: 1,
                                                color: Colors.black54,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20, bottom: 20),
                                                child: Text(
                                                  '채촌 정보',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  TabBar(
                                                    labelStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    indicatorColor:
                                                        HexColor('#172543'),
                                                    indicatorWeight: 3.0,
                                                    controller: _tabController,
                                                    tabs: const <Widget>[
                                                      Tab(
                                                        text: '자켓',
                                                      ),
                                                      Tab(
                                                        text: '조끼',
                                                      ),
                                                      Tab(
                                                        text: '바지',
                                                      ),
                                                      Tab(
                                                        text: '셔츠',
                                                      ),
                                                      Tab(
                                                        text: '코트',
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    height: 150,
                                                    child: TabBarView(
                                                        controller:
                                                            _tabController,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    top: 10),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '어깨'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '앞어깨'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '등어깨'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '진동'),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '소매'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '상동'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '암홀'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '각도'),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '앞길'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '중동'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '하동'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '상의장'),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '앞폼'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '뒷폼'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '총장'),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    top: 10),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '조끼장'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '앞길'),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '각도'),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '상동'),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '중동'),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    top: 10),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '허리'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '허벅'),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text('힙'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '둘레'),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '밑위길이'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '밑통'),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '바깥기장'),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    top: 10),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text('목'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '어깨'),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '소매'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '상동'),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '중동'),
                                                                      Spacer(),
                                                                      Text('힢'),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '팔통'),
                                                                      Spacer(),
                                                                      Text(
                                                                          '손목'),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                      Text(''),
                                                                      Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Column(),
                                                        ]),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              // Container(
                                              //   padding:
                                              //       EdgeInsets.only(top: 20),
                                              //   height: 1,
                                              //   color: Colors.black54,
                                              // ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       top: 20, bottom: 20),
                                              //   child: Text(
                                              //     '구매이력 및 포인트 적립이력',
                                              //     style: TextStyle(
                                              //         fontWeight:
                                              //             FontWeight.bold,
                                              //         fontSize: 18),
                                              //   ),
                                              // ),
                                              // Container(
                                              //   height: 250,
                                              //   child: pointHistory.length == 0
                                              //       ? Center(
                                              //           child: Text(
                                              //               '구매 이력 및 포인트 적립 이력이 없습니다.'))
                                              //       : Text('aaa'),
                                              // )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                            : Container(
                                height: Get.height,
                                child: Center(
                                  child: Text('고객 검색 후, 조회할 고객을 선택하세요.'),
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  void changePoint(bool savePoint, int point) {
    print(savePoint);
    print(point);
  }
}
