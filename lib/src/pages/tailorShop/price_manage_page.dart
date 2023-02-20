import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:bykak/src/components/alert_fucntion.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/number_format.dart';
import 'package:bykak/src/components/responsive.dart';
import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/shirt_size_model.dart';
import 'package:bykak/src/model/tailorShop/payment_model.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/model/vest_size_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class PriceManage extends StatefulWidget {
  PriceManage({Key? key}) : super(key: key);

  @override
  State<PriceManage> createState() => _PriceManageState();
}

class _PriceManageState extends State<PriceManage>
    with TickerProviderStateMixin {
  final controller1 = ScrollController();
  //final controller2 = ScrollController();

  final textController = TextEditingController();
  String _searchText = "";
  TextEditingController controller = TextEditingController(); //포인트
  TextEditingController controllerDiscount = TextEditingController(); //포인트
  TextEditingController controllerDiscountSub = TextEditingController(); //포인트
  TextEditingController controllerPayment = TextEditingController(); //포인트
  List<TextEditingController> _controllers1 = [];
  // List<TextEditingController> _controllers2 = [];
  // List<TextEditingController> _controllers3 = [];
  // List<TextEditingController> _controllers4 = [];
  // List<TextEditingController> _controllers5 = [];
  List resultPrice = [];

  List typeList = ['수트', '자켓', '셔츠', '바지', '조끼', '코트'];

  var controller2;
  bool _isLoading = true;

  User? auth = FirebaseAuth.instance.currentUser;

  final firestore = FirebaseFirestore.instance;
  String userName = "";
  String storeName = "";
  getData() async {
    try {
      var userResult =
          await firestore.collection('users').doc(auth!.email.toString()).get();

      setState(() {
        userName = userResult['userName'];
        storeName = userResult['storeName'];
      });
    } catch (e) {}
  }

  String today = "";
  @override
  void initState() {
    var _toDay = DateTime.now();
    // TODO: implement initState

    textController.addListener(checkNameText);
    getData();
    setState(() {
      today = _toDay.toString().substring(0, 10);

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
              height: 25,
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
        if (d.data().toString().contains(_searchText)) {
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
  int prepayment = 0;
  int accruePrepayment = 0;
  int totalPrice = 0;

  late TopSize? topSize;

  late BottomSize? bottomSize;
  late VestSize? vestSize;
  late ShirtSize? shirtSize;
  String customerGradeRate = "";
  Widget _buildListItem(BuildContext context, data) {
    controller2 = PrimaryScrollController.of(context);
    if (storeName.contains('바이각')) {
      if (data['accruedPoint'] == 0 || data['accruedPoint'] < 1500000) {
        //첫방문
        customerGradeRate = "초";
      } else if (data['accruedPoint'] >= 1500000 &&
          data['accruedPoint'] < 5000000) {
        //의등급
        customerGradeRate = "의";
      } else if (data['accruedPoint'] >= 5000000 &&
          data['accruedPoint'] < 10000000) {
        //견등급
        customerGradeRate = "견";
      } else if (data['accruedPoint'] >= 10000000 &&
          data['accruedPoint'] < 20000000) {
        //학등급
        customerGradeRate = "학";
      } else {
        //각등급
        customerGradeRate = "각";
      }
    }

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
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      data['name'],
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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
                    Container(
                      width: 80,
                      child: Text(
                        numberFormat(data['point']) + ' P',
                        style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
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
            Row(
              children: [
                Row(
                  children: [
                    Text(
                      '누적 구매액',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 80,
                      child: Text(
                        numberFormat(data['purchaseAmount']) + ' 원',
                        style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '고객 등급',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      customerGradeRate + ' 등급',
                      style: TextStyle(
                          color: Colors.black,
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
          ],
        ),
      ),
      onTap: () {
        setState(
          () {
            detailView = true;
            _isLoading = true;
            priceInputView = true;

            Future.delayed(Duration(seconds: 1), () {
              setState(() {
                _isLoading = false;
              });
            });

            controller2?.animateTo(0,
                duration: Duration(milliseconds: 100), curve: Curves.ease);
            name = data['name'];
            phone = data['phone'];
            point = data['point'];
            //getOrderData(name, phone, startDate);
            controllerPayment = TextEditingController(text: '0');
            getOrderDateList(name, phone);
          },
        );
      },
    );
  }

  bool detailView = false;
  bool priceInputView = true;

  void checkNameText() {
    setState(() {
      _searchText = textController.text;
    });
  }

  List purchaseDateList = [];
  getOrderDateList(String name, String phone) async {
    final order = await firestore
        .collection('orders')
        .where('name', isEqualTo: name)
        .where('phone', isEqualTo: phone)
        .where('storeName', isEqualTo: storeName)
        .orderBy('consultDate', descending: true)
        .get();

    try {
      purchaseDateList = [];
      for (var item in order.docs) {
        if (!purchaseDateList
            .contains(item['consultDate'].toString().substring(0, 10))) {
          purchaseDateList.add(item['consultDate'].toString().substring(0, 10));
        }
      }

      totalPriceList = [];
      totalPrepaymentList = [];
      discount = [];
      discountSub = [];
      usePointList = [];
      givePoingList = [];

      for (var i = 0; i < purchaseDateList.length; i++) {
        getPriceList(name, phone, purchaseDateList[i]);
      }
    } catch (e) {
      purchaseDateList = [];
    }
  }

  List totalPriceList = [];
  List totalPrepaymentList = [];
  List discount = [];
  List discountSub = [];
  List usePointList = [];
  List givePoingList = [];

  getPriceList(String name, String phone, String date) async {
    final paymentData = await firestore
        .collection('payment')
        .where('name', isEqualTo: name)
        .where('phone', isEqualTo: phone)
        .where('tailorShop', isEqualTo: storeName)
        .where('consultDate', isEqualTo: date)
        // .orderBy('consultDate', descending: true)
        .get();

    try {
      for (var item in paymentData.docs) {
        totalPriceList.add(item['totalPrice']);
        totalPrepaymentList.add(item['totalPrepayment']);
        discount.add(item['discount']);
        discountSub.add(item['discountSub']);
        usePointList.add(item['usePoint']);
        givePoingList.add(item['givePoint']);
      }
    } catch (e) {}
  }

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
          '결제 금액 관리',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
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
                                              height: 25,
                                              width: 30,
                                              child: CircularProgressIndicator(
                                                color: HexColor('#172543'),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            //width: 800,
                                            height: Get.height,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: detailView
                                                  ? _isLoading
                                                      ? Center(
                                                          child: SizedBox(
                                                            height: 25,
                                                            width: 30,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: HexColor(
                                                                  '#172543'),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          height: Get.height,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                height: 50,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          20),
                                                                  child:
                                                                      IconButton(
                                                                    icon: Icon(Icons
                                                                        .arrow_back_sharp),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        detailView =
                                                                            false;
                                                                        priceInputView =
                                                                            true;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              priceInputView
                                                                  ? Expanded(
                                                                      child: ListView.separated(
                                                                          itemBuilder: (BuildContext context, int index) {
                                                                            return InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  _isLoading = true;

                                                                                  Future.delayed(Duration(seconds: 1), () {
                                                                                    setState(() {
                                                                                      _isLoading = false;
                                                                                    });
                                                                                  });

                                                                                  priceInputView = false;

                                                                                  getOrderData(name, phone, purchaseDateList[index]);
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                height: 85,
                                                                                child: Column(
                                                                                  children: [
                                                                                    // Text('bbb'),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(
                                                                                          width: 150,
                                                                                          child: Text(
                                                                                            '구매날짜 ',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          width: 100,
                                                                                          child: Text(
                                                                                            purchaseDateList[index],
                                                                                            style: TextStyle(fontSize: 12),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(
                                                                                          width: 150,
                                                                                          child: Text(
                                                                                            '구매총액 ',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          width: 100,
                                                                                          child: Text(
                                                                                            moneyFormatText(totalPriceList[index].toString()) + ' 원',
                                                                                            style: TextStyle(fontSize: 12),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(width: 150, child: Text('잔금 ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                                                                        Container(
                                                                                          width: 100,
                                                                                          child: Text(
                                                                                            moneyFormatText((totalPriceList[index] - totalPrepaymentList[index] - discount[index] - discountSub[index] - usePointList[index]).toString()) + ' 원',
                                                                                            style: TextStyle(color: (totalPriceList[index] - totalPrepaymentList[index] - discount[index] - discountSub[index] - usePointList[index]) == 0 ? Colors.black : Colors.redAccent, fontSize: 12),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(width: 150, child: Text('적립금 ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                                                                        Container(
                                                                                          width: 100,
                                                                                          child: Text(
                                                                                            (moneyFormatText(givePoingList[index].toString()) + ' P'),
                                                                                            style: TextStyle(fontSize: 12),
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                          //  Divider 로 구분자 추가.
                                                                          separatorBuilder: (BuildContext context, int index) => const Divider(),
                                                                          itemCount: purchaseDateList.length),
                                                                    )
                                                                  : _isLoading
                                                                      ? Center(
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                25,
                                                                            width:
                                                                                30,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              color: HexColor('#172543'),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Expanded(
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  child: Text(
                                                                                    name + '님의 ' + ' 구매목록',
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.only(top: 20),
                                                                                  height: orderList.length * 150,
                                                                                  child: ListView.separated(
                                                                                    itemCount: orderList.length,
                                                                                    separatorBuilder: (context, index) {
                                                                                      return Divider(
                                                                                        thickness: 2.0,
                                                                                      );
                                                                                    },
                                                                                    itemBuilder: ((context, index) {
                                                                                      // _controllers1.add(
                                                                                      //     new TextEditingController());

                                                                                      return Container(
                                                                                        height: 120,
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Row(
                                                                                              children: [
                                                                                                Container(
                                                                                                  height: 20,
                                                                                                  width: 100,
                                                                                                  child: Text(
                                                                                                    '주문번호',
                                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                ),
                                                                                                Container(
                                                                                                  height: 20,
                                                                                                  width: 200,
                                                                                                  child: Text(
                                                                                                    orderList[index].toString(),
                                                                                                    style: TextStyle(fontSize: 13),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                Container(
                                                                                                  height: 20,
                                                                                                  width: 100,
                                                                                                  child: Text(
                                                                                                    '제품종류',
                                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                ),
                                                                                                Container(
                                                                                                  height: 20,
                                                                                                  width: 200,
                                                                                                  child: Text(
                                                                                                    typeList[int.parse(orderTypeList[index])],
                                                                                                    style: TextStyle(fontSize: 13),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                Container(
                                                                                                  height: 20,
                                                                                                  width: 100,
                                                                                                  child: Text(
                                                                                                    '원단정보',
                                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                ),
                                                                                                Container(
                                                                                                  height: 20,
                                                                                                  width: 200,
                                                                                                  child: Text(
                                                                                                    orderPabricList[index].toString(),
                                                                                                    style: TextStyle(fontSize: 13),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 10,
                                                                                            ),
                                                                                            Container(
                                                                                              width: 150,
                                                                                              height: 50,
                                                                                              padding: EdgeInsets.only(right: 10, bottom: 10),
                                                                                              child: TextFormField(
                                                                                                readOnly: int.parse(priceList[index]) > 0 ? true : false,
                                                                                                inputFormatters: [
                                                                                                  ThousandsFormatter()
                                                                                                ],
                                                                                                controller: _controllers1[index],
                                                                                                decoration: InputDecoration(
                                                                                                  focusedBorder: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                                    borderSide: BorderSide(
                                                                                                      color: mainColor,
                                                                                                    ),
                                                                                                  ),
                                                                                                  contentPadding: const EdgeInsets.symmetric(
                                                                                                    horizontal: 20,
                                                                                                    vertical: 20,
                                                                                                  ),
                                                                                                  hintStyle: const TextStyle(fontSize: 14),
                                                                                                  border: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                                  ),
                                                                                                ),
                                                                                                onChanged: (val) {
                                                                                                  calcPayment(
                                                                                                      _controllers1[index].text.toString(),
                                                                                                      // _controllers2[index].text.toString(),
                                                                                                      index);
                                                                                                },
                                                                                                onSaved: (val) {},
                                                                                                validator: (val) {
                                                                                                  return null;
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    }),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(bottom: 10),
                                                                                  child: Text(
                                                                                    '할인',
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      width: 150,
                                                                                      height: 50,
                                                                                      padding: EdgeInsets.only(right: 10, bottom: 10),
                                                                                      child: TextFormField(
                                                                                        readOnly: givePointResult == 'Y' ? true : false,
                                                                                        // readOnly:
                                                                                        //     discountVal >
                                                                                        //             0
                                                                                        //         ? true
                                                                                        //         : false,
                                                                                        inputFormatters: [
                                                                                          ThousandsFormatter()
                                                                                        ],
                                                                                        controller: controllerDiscount,
                                                                                        decoration: InputDecoration(
                                                                                          focusedBorder: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                            borderSide: BorderSide(
                                                                                              color: mainColor,
                                                                                            ),
                                                                                          ),
                                                                                          contentPadding: const EdgeInsets.symmetric(
                                                                                            horizontal: 20,
                                                                                            vertical: 20,
                                                                                          ),
                                                                                          hintStyle: const TextStyle(fontSize: 14),
                                                                                          border: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                          ),
                                                                                        ),
                                                                                        onChanged: (val) {
                                                                                          setState(() {
                                                                                            discountVal = int.parse(val.toString().replaceAll(',', ''));
                                                                                          });
                                                                                        },
                                                                                        onSaved: (val) {},
                                                                                        validator: (val) {
                                                                                          return null;
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                    givePointResult != 'Y'
                                                                                        ? Container(
                                                                                            alignment: Alignment.centerLeft,
                                                                                            width: 350,
                                                                                            child: GroupButton(
                                                                                                options: GroupButtonOptions(
                                                                                                  buttonWidth: 80,
                                                                                                  selectedColor: mainColor,
                                                                                                  unselectedColor: Colors.grey[300],
                                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                                ),
                                                                                                isRadio: true,
                                                                                                // onSelected: (index,
                                                                                                //         isSelected) =>
                                                                                                //     print(
                                                                                                //         '$index button is selected'),
                                                                                                onSelected: (value, index, isSelected) {
                                                                                                  calcDisdount(
                                                                                                    index,
                                                                                                  );
                                                                                                },
                                                                                                buttons: ["자동 적용", "1 %", "2 %", "3 %", "4 %", "5 %"]),
                                                                                          )
                                                                                        : Container()
                                                                                  ],
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.only(top: 10),
                                                                                  child: Divider(
                                                                                    thickness: 2.0,
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                                                                                  child: Text(
                                                                                    '결제 금액 및 잔액',
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(
                                                                                          height: 25,
                                                                                          child: Text(
                                                                                            '제품총액',
                                                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          alignment: Alignment.centerRight,
                                                                                          height: 25,
                                                                                          width: 200,
                                                                                          child: Text(
                                                                                            numberFormat(totalPrice).toString() + ' 원',
                                                                                            style: TextStyle(fontSize: 14),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(
                                                                                          height: 25,
                                                                                          child: Text(
                                                                                            '할인금액',
                                                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          alignment: Alignment.centerRight,
                                                                                          height: 25,
                                                                                          width: 200,
                                                                                          child: Text(
                                                                                            numberFormat(discountVal + discountValSub).toString() + ' 원',
                                                                                            style: TextStyle(fontSize: 14),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(
                                                                                          height: 25,
                                                                                          child: Text(
                                                                                            '적립금 사용',
                                                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          alignment: Alignment.centerRight,
                                                                                          height: 25,
                                                                                          width: 200,
                                                                                          child: Text(
                                                                                            numberFormat(usePointVal).toString() + ' 원',
                                                                                            style: TextStyle(fontSize: 14),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(
                                                                                          height: 25,
                                                                                          child: Text(
                                                                                            '선입금액',
                                                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          alignment: Alignment.centerLeft,
                                                                                          height: 25,
                                                                                          width: 200,
                                                                                          child: Text(
                                                                                            numberFormat(accruePrepayment).toString() + ' 원',
                                                                                            style: TextStyle(fontSize: 14),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Container(
                                                                                          height: 25,
                                                                                          child: Text(
                                                                                            '잔액',
                                                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          alignment: Alignment.centerRight,
                                                                                          height: 25,
                                                                                          width: 200,
                                                                                          child: Text(
                                                                                            numberFormat((totalPrice - discountVal - discountValSub - usePointVal - accruePrepayment)).toString() + ' 원',
                                                                                            style: TextStyle(fontSize: 14),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.only(top: 10),
                                                                                  child: Divider(
                                                                                    thickness: 2.0,
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 10),
                                                                                  child: Text(
                                                                                    '적립금 사용',
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: 150,
                                                                                  height: 50,
                                                                                  padding: EdgeInsets.only(top: 5, right: 10),
                                                                                  child: TextFormField(
                                                                                    readOnly: point == 0 || usePointResult == 'Y' ? true : false,
                                                                                    inputFormatters: [
                                                                                      ThousandsFormatter()
                                                                                    ],
                                                                                    controller: controller,
                                                                                    decoration: InputDecoration(
                                                                                      focusedBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                        borderSide: BorderSide(
                                                                                          color: mainColor,
                                                                                        ),
                                                                                      ),
                                                                                      contentPadding: const EdgeInsets.symmetric(
                                                                                        horizontal: 20,
                                                                                        vertical: 20,
                                                                                      ),
                                                                                      hintStyle: const TextStyle(fontSize: 14),
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                      ),
                                                                                    ),
                                                                                    onChanged: (val) {
                                                                                      setState(() {
                                                                                        if (int.parse(val.toString().replaceAll(',', '')) > point) {
                                                                                          usePointVal = 0;
                                                                                          failAlert('');
                                                                                        } else {
                                                                                          if (val.length == 0) {
                                                                                            usePointVal = 0;
                                                                                          } else {
                                                                                            usePointVal = int.parse(val.toString().replaceAll(',', ''));
                                                                                          }
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    onSaved: (val) {},
                                                                                    validator: (val) {
                                                                                      return null;
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(
                                                                                    top: 10,
                                                                                  ),
                                                                                  child: Text(
                                                                                    '추가 할인 금액',
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: 150,
                                                                                  height: 50,
                                                                                  padding: EdgeInsets.only(top: 5, right: 10),
                                                                                  child: TextFormField(
                                                                                    readOnly: givePointResult == 'Y' ? true : false,
                                                                                    inputFormatters: [
                                                                                      ThousandsFormatter()
                                                                                    ],
                                                                                    controller: controllerDiscountSub,
                                                                                    decoration: InputDecoration(
                                                                                      focusedBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                        borderSide: BorderSide(
                                                                                          color: mainColor,
                                                                                        ),
                                                                                      ),
                                                                                      contentPadding: const EdgeInsets.symmetric(
                                                                                        horizontal: 20,
                                                                                        vertical: 20,
                                                                                      ),
                                                                                      hintStyle: const TextStyle(fontSize: 14),
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                      ),
                                                                                    ),
                                                                                    onChanged: (val) {
                                                                                      setState(() {
                                                                                        if (val.length == 0) {
                                                                                          discountValSub = 0;
                                                                                        } else {
                                                                                          discountValSub = int.parse(val.toString().replaceAll(',', ''));
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    onSaved: (val) {},
                                                                                    validator: (val) {
                                                                                      return null;
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                                  child: Text(
                                                                                    '결제방법',
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      width: 350,
                                                                                      child: GroupButton(
                                                                                          options: GroupButtonOptions(
                                                                                            mainGroupAlignment: MainGroupAlignment.start,
                                                                                            buttonWidth: 80,
                                                                                            selectedColor: mainColor,
                                                                                            unselectedColor: Colors.grey[300],
                                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                                          ),
                                                                                          isRadio: true,
                                                                                          // onSelected: (index,
                                                                                          //         isSelected) =>
                                                                                          //     print(
                                                                                          //         '$index button is selected'),
                                                                                          onSelected: (value, index, isSelected) {
                                                                                            setState(() {
                                                                                              paymentOption = value.toString();
                                                                                            });
                                                                                          },
                                                                                          buttons: [
                                                                                            "카드",
                                                                                            "현금",
                                                                                            "상품권",
                                                                                            "포인트전액",
                                                                                            "기타",
                                                                                          ]),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(
                                                                                    top: 10,
                                                                                  ),
                                                                                  child: Text(
                                                                                    '입금액',
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: 150,
                                                                                  height: 50,
                                                                                  padding: EdgeInsets.only(top: 5, right: 10),
                                                                                  child: TextFormField(
                                                                                    inputFormatters: [
                                                                                      ThousandsFormatter()
                                                                                    ],
                                                                                    controller: controllerPayment,
                                                                                    decoration: InputDecoration(
                                                                                      focusedBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                        borderSide: BorderSide(
                                                                                          color: mainColor,
                                                                                        ),
                                                                                      ),
                                                                                      contentPadding: const EdgeInsets.symmetric(
                                                                                        horizontal: 20,
                                                                                        vertical: 20,
                                                                                      ),
                                                                                      hintStyle: const TextStyle(fontSize: 14),
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                      ),
                                                                                    ),
                                                                                    onSaved: (val) {},
                                                                                    validator: (val) {
                                                                                      return null;
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                    padding: EdgeInsets.only(top: 50, bottom: 20),
                                                                                    alignment: Alignment.center,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Container(
                                                                                          width: 360,
                                                                                          //로그아웃 버튼
                                                                                          // width: MediaQuery.of(context).size.width,
                                                                                          child: ElevatedButton(
                                                                                            style: TextButton.styleFrom(
                                                                                              primary: Colors.white, //글자색
                                                                                              onSurface: Colors.white, //onpressed가 null일때 색상
                                                                                              backgroundColor: HexColor('#172543'),
                                                                                              shadowColor: Colors.white, //그림자 색상
                                                                                              elevation: 1, // 버튼 입체감
                                                                                              textStyle: TextStyle(fontSize: 16),
                                                                                              //padding: EdgeInsets.all(16.0),
                                                                                              minimumSize: Size(300, 50), //최소 사이즈
                                                                                              side: BorderSide(color: HexColor('#172543'), width: 1.0), //선
                                                                                              shape: StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                                                                              alignment: Alignment.center,
                                                                                            ), //글자위치 변경
                                                                                            onPressed: () {
                                                                                              savePayment();
                                                                                            },

                                                                                            child: const Text('결제 금액 정보 저장'),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ))
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                            ],
                                                          ),
                                                        )
                                                  : Container(
                                                      height: Get.height,
                                                      child: Center(
                                                        child: Text(
                                                            '고객 검색 후, 조회할 고객을 선택하세요.'),
                                                      ),
                                                    ),
                                            ),
                                          )
                                    // SingleChildScrollView(
                                    //     controller: controller2,
                                    //     child: Column(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.center,
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.stretch,
                                    //       children: <Widget>[
                                    //         Container(
                                    //           padding: EdgeInsets.all(20),
                                    //           child: Column(
                                    //             crossAxisAlignment:
                                    //                 CrossAxisAlignment
                                    //                     .start,
                                    //             children: [
                                    //               Align(
                                    //                 alignment: Alignment
                                    //                     .centerRight,
                                    //                 child: Padding(
                                    //                   padding:
                                    //                       const EdgeInsets
                                    //                               .only(
                                    //                           bottom: 10),
                                    //                   child: IconButton(
                                    //                     icon: Icon(
                                    //                         Icons.close),
                                    //                     onPressed: () {
                                    //                       setState(() {
                                    //                         detailView =
                                    //                             false;
                                    //                       });
                                    //                     },
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         )
                                    //       ],
                                    //     ),
                                    //   )
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
                                        padding: const EdgeInsets.only(
                                            top: 10.0, right: 10, left: 10),

                                        /// In AnimSearchBar widget, the width, textController, onSuffixTap are required properties.
                                        /// You have also control over the suffixIcon, prefixIcon, helpText and animationDurationInMilli
                                        child: AnimSearchBar(
                                          helpText: '이름 또는 연락처를 입력하세요.',
                                          //autoFocus: true,
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
                                //autoFocus: true,
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
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       top: 10.0, right: 10, left: 20),
                          //   child: Row(
                          //     children: [
                          //       Text('구매일자'),
                          //       TextButton(
                          //         onPressed: () {
                          //           showDatePickerPopStart();
                          //         },
                          //         child: Container(
                          //           width: 100,
                          //           height: 50,
                          //           // decoration: BoxDecoration(
                          //           //     border: Border.all(
                          //           //   width: 0.5,
                          //           //   color: HexColor('#172543'),
                          //           // )),
                          //           alignment: Alignment.center,
                          //           child: Text(
                          //             startDate,
                          //             style:
                          //                 TextStyle(color: HexColor('#172543')),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
                        padding: const EdgeInsets.all(10.0),
                        child: detailView
                            ? _isLoading
                                ? Center(
                                    child: SizedBox(
                                      height: 25,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: HexColor('#172543'),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: Get.height,
                                    padding: EdgeInsets.all(30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: IconButton(
                                              icon:
                                                  Icon(Icons.arrow_back_sharp),
                                              onPressed: () {
                                                setState(() {
                                                  detailView = false;
                                                  priceInputView = true;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        priceInputView
                                            ? Expanded(
                                                child: ListView.separated(
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _isLoading = true;

                                                            Future.delayed(
                                                                Duration(
                                                                    seconds: 1),
                                                                () {
                                                              setState(() {
                                                                _isLoading =
                                                                    false;
                                                              });
                                                            });

                                                            priceInputView =
                                                                false;

                                                            getOrderData(
                                                                name,
                                                                phone,
                                                                purchaseDateList[
                                                                    index]);
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 25,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    '구매날짜 ',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 30,
                                                                  ),
                                                                  Text(purchaseDateList[
                                                                      index]),
                                                                ],
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          '구매총액 ',
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Text(moneyFormatText(totalPriceList[index].toString()) + ' 원'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            '잔금 ',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold)),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Text(
                                                                            moneyFormatText((totalPriceList[index] - totalPrepaymentList[index] - discount[index] - discountSub[index] - usePointList[index]).toString()) +
                                                                                ' 원',
                                                                            style:
                                                                                TextStyle(color: (totalPriceList[index] - totalPrepaymentList[index] - discount[index] - discountSub[index] - usePointList[index]) == 0 ? Colors.black : Colors.redAccent),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            '적립금 ',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold)),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              80,
                                                                          child:
                                                                              Text(
                                                                            (moneyFormatText(givePoingList[index].toString()) +
                                                                                ' 원'),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    //  Divider 로 구분자 추가.
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            const Divider(),
                                                    itemCount: purchaseDateList
                                                        .length),
                                              )
                                            : _isLoading
                                                ? Center(
                                                    child: SizedBox(
                                                      height: 25,
                                                      width: 30,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color:
                                                            HexColor('#172543'),
                                                      ),
                                                    ),
                                                  )
                                                : Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              name +
                                                                  '님의 ' +
                                                                  ' 구매목록',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 20),
                                                            height: orderList
                                                                    .length *
                                                                100,
                                                            child: ListView
                                                                .builder(
                                                              itemCount:
                                                                  orderList
                                                                      .length,
                                                              itemBuilder:
                                                                  ((context,
                                                                      index) {
                                                                // _controllers1.add(
                                                                //     new TextEditingController());

                                                                return Container(
                                                                  height: 80,
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                height: 20,
                                                                                width: 100,
                                                                                child: Text(
                                                                                  '주문번호',
                                                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 20,
                                                                                width: 200,
                                                                                child: Text(
                                                                                  orderList[index].toString(),
                                                                                  style: TextStyle(fontSize: 13),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                height: 20,
                                                                                width: 100,
                                                                                child: Text(
                                                                                  '제품종류',
                                                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 20,
                                                                                width: 200,
                                                                                child: Text(
                                                                                  typeList[int.parse(orderTypeList[index])],
                                                                                  style: TextStyle(fontSize: 13),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                height: 20,
                                                                                width: 100,
                                                                                child: Text(
                                                                                  '원단정보',
                                                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 20,
                                                                                width: 200,
                                                                                child: Text(
                                                                                  orderPabricList[index].toString(),
                                                                                  style: TextStyle(fontSize: 13),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            150,
                                                                        height:
                                                                            50,
                                                                        padding: EdgeInsets.only(
                                                                            right:
                                                                                10,
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            TextFormField(
                                                                          readOnly: int.parse(priceList[index]) > 0
                                                                              ? true
                                                                              : false,
                                                                          inputFormatters: [
                                                                            ThousandsFormatter()
                                                                          ],
                                                                          controller:
                                                                              _controllers1[index],
                                                                          decoration:
                                                                              InputDecoration(
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              borderSide: BorderSide(
                                                                                color: mainColor,
                                                                              ),
                                                                            ),
                                                                            contentPadding:
                                                                                const EdgeInsets.symmetric(
                                                                              horizontal: 20,
                                                                              vertical: 20,
                                                                            ),
                                                                            hintStyle:
                                                                                const TextStyle(fontSize: 14),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            ),
                                                                          ),
                                                                          onChanged:
                                                                              (val) {
                                                                            calcPayment(
                                                                                _controllers1[index].text.toString(),
                                                                                // _controllers2[index].text.toString(),
                                                                                index);
                                                                          },
                                                                          onSaved:
                                                                              (val) {},
                                                                          validator:
                                                                              (val) {
                                                                            return null;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 10),
                                                            child: Text(
                                                              '할인',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                            ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: 150,
                                                                height: 50,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            10),
                                                                child:
                                                                    TextFormField(
                                                                  readOnly:
                                                                      givePointResult ==
                                                                              'Y'
                                                                          ? true
                                                                          : false,
                                                                  // readOnly:
                                                                  //     discountVal >
                                                                  //             0
                                                                  //         ? true
                                                                  //         : false,
                                                                  inputFormatters: [
                                                                    ThousandsFormatter()
                                                                  ],
                                                                  controller:
                                                                      controllerDiscount,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color:
                                                                            mainColor,
                                                                      ),
                                                                    ),
                                                                    contentPadding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          20,
                                                                    ),
                                                                    hintStyle: const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                    ),
                                                                  ),
                                                                  onChanged:
                                                                      (val) {
                                                                    setState(
                                                                        () {
                                                                      discountVal = int.parse(val
                                                                          .toString()
                                                                          .replaceAll(
                                                                              ',',
                                                                              ''));
                                                                    });
                                                                  },
                                                                  onSaved:
                                                                      (val) {},
                                                                  validator:
                                                                      (val) {
                                                                    return null;
                                                                  },
                                                                ),
                                                              ),
                                                              givePointResult !=
                                                                      'Y'
                                                                  ? GroupButton(
                                                                      options:
                                                                          GroupButtonOptions(
                                                                        selectedColor:
                                                                            mainColor,
                                                                        unselectedColor:
                                                                            Colors.grey[300],
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      isRadio: true,
                                                                      // onSelected: (index,
                                                                      //         isSelected) =>
                                                                      //     print(
                                                                      //         '$index button is selected'),
                                                                      onSelected: (value, index, isSelected) {
                                                                        calcDisdount(
                                                                          index,
                                                                        );
                                                                      },
                                                                      buttons: [
                                                                          "자동 적용",
                                                                          "1 %",
                                                                          "2 %",
                                                                          "3 %",
                                                                          "4 %",
                                                                          "5 %"
                                                                        ])
                                                                  : Container()
                                                            ],
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: Divider(
                                                              thickness: 2.0,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 20,
                                                                    bottom: 10),
                                                            child: Text(
                                                              '결제 금액 및 잔액',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                            ),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    height: 25,
                                                                    width: 100,
                                                                    child: Text(
                                                                      '제품총액',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    height: 25,
                                                                    width: 200,
                                                                    child: Text(
                                                                      numberFormat(totalPrice)
                                                                              .toString() +
                                                                          ' 원',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    height: 25,
                                                                    width: 100,
                                                                    child: Text(
                                                                      '할인금액',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    height: 25,
                                                                    width: 200,
                                                                    child: Text(
                                                                      numberFormat(discountVal + discountValSub)
                                                                              .toString() +
                                                                          ' 원',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    height: 25,
                                                                    width: 100,
                                                                    child: Text(
                                                                      '적립금 사용 금액',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    height: 25,
                                                                    width: 200,
                                                                    child: Text(
                                                                      numberFormat(usePointVal)
                                                                              .toString() +
                                                                          ' 원',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    height: 25,
                                                                    width: 100,
                                                                    child: Text(
                                                                      '선입금액',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    height: 25,
                                                                    width: 200,
                                                                    child: Text(
                                                                      numberFormat(accruePrepayment)
                                                                              .toString() +
                                                                          ' 원',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    height: 25,
                                                                    width: 100,
                                                                    child: Text(
                                                                      '잔액',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    height: 25,
                                                                    width: 200,
                                                                    child: Text(
                                                                      numberFormat((totalPrice - discountVal - discountValSub - usePointVal - accruePrepayment))
                                                                              .toString() +
                                                                          ' 원',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: Divider(
                                                              thickness: 2.0,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10),
                                                            child: Text(
                                                              '적립금 사용',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            height: 50,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    right: 10),
                                                            child:
                                                                TextFormField(
                                                              readOnly: point ==
                                                                          0 ||
                                                                      usePointResult ==
                                                                          'Y'
                                                                  ? true
                                                                  : false,
                                                              inputFormatters: [
                                                                ThousandsFormatter()
                                                              ],
                                                              controller:
                                                                  controller,
                                                              decoration:
                                                                  InputDecoration(
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color:
                                                                        mainColor,
                                                                  ),
                                                                ),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 20,
                                                                ),
                                                                hintStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                              ),
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  if (int.parse(val
                                                                          .toString()
                                                                          .replaceAll(
                                                                              ',',
                                                                              '')) >
                                                                      point) {
                                                                    usePointVal =
                                                                        0;
                                                                    failAlert(
                                                                        '');
                                                                  } else {
                                                                    if (val.length ==
                                                                        0) {
                                                                      usePointVal =
                                                                          0;
                                                                    } else {
                                                                      usePointVal = int.parse(val
                                                                          .toString()
                                                                          .replaceAll(
                                                                              ',',
                                                                              ''));
                                                                    }
                                                                  }
                                                                });
                                                              },
                                                              onSaved: (val) {},
                                                              validator: (val) {
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 10,
                                                            ),
                                                            child: Text(
                                                              '추가 할인 금액',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            height: 50,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    right: 10),
                                                            child:
                                                                TextFormField(
                                                              readOnly:
                                                                  givePointResult ==
                                                                          'Y'
                                                                      ? true
                                                                      : false,
                                                              inputFormatters: [
                                                                ThousandsFormatter()
                                                              ],
                                                              controller:
                                                                  controllerDiscountSub,
                                                              decoration:
                                                                  InputDecoration(
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color:
                                                                        mainColor,
                                                                  ),
                                                                ),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 20,
                                                                ),
                                                                hintStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                              ),
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  if (val.length ==
                                                                      0) {
                                                                    discountValSub =
                                                                        0;
                                                                  } else {
                                                                    discountValSub = int.parse(val
                                                                        .toString()
                                                                        .replaceAll(
                                                                            ',',
                                                                            ''));
                                                                  }
                                                                });
                                                              },
                                                              onSaved: (val) {},
                                                              validator: (val) {
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10,
                                                                    bottom: 10),
                                                            child: Text(
                                                              '결제방법',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13),
                                                            ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              GroupButton(
                                                                  options:
                                                                      GroupButtonOptions(
                                                                    selectedColor:
                                                                        mainColor,
                                                                    unselectedColor:
                                                                        Colors.grey[
                                                                            300],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  isRadio: true,
                                                                  // onSelected: (index,
                                                                  //         isSelected) =>
                                                                  //     print(
                                                                  //         '$index button is selected'),
                                                                  onSelected:
                                                                      (value,
                                                                          index,
                                                                          isSelected) {
                                                                    setState(
                                                                        () {
                                                                      paymentOption =
                                                                          value
                                                                              .toString();
                                                                    });
                                                                  },
                                                                  buttons: [
                                                                    "카드",
                                                                    "현금",
                                                                    "상품권",
                                                                    "포인트전액",
                                                                    "기타",
                                                                  ])
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 10,
                                                            ),
                                                            child: Text(
                                                              '입금액',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            height: 50,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    right: 10),
                                                            child:
                                                                TextFormField(
                                                              inputFormatters: [
                                                                ThousandsFormatter()
                                                              ],
                                                              controller:
                                                                  controllerPayment,
                                                              decoration:
                                                                  InputDecoration(
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color:
                                                                        mainColor,
                                                                  ),
                                                                ),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 20,
                                                                ),
                                                                hintStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                              ),
                                                              onSaved: (val) {},
                                                              validator: (val) {
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                          Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 50,
                                                                      bottom:
                                                                          20),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: 360,
                                                                    //로그아웃 버튼
                                                                    // width: MediaQuery.of(context).size.width,
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        primary:
                                                                            Colors.white, //글자색
                                                                        onSurface:
                                                                            Colors.white, //onpressed가 null일때 색상
                                                                        backgroundColor:
                                                                            HexColor('#172543'),
                                                                        shadowColor:
                                                                            Colors.white, //그림자 색상
                                                                        elevation:
                                                                            1, // 버튼 입체감
                                                                        textStyle:
                                                                            TextStyle(fontSize: 16),
                                                                        //padding: EdgeInsets.all(16.0),
                                                                        minimumSize: Size(
                                                                            300,
                                                                            50), //최소 사이즈
                                                                        side: BorderSide(
                                                                            color:
                                                                                HexColor('#172543'),
                                                                            width: 1.0), //선
                                                                        shape:
                                                                            StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                                                                        alignment:
                                                                            Alignment.center,
                                                                      ), //글자위치 변경
                                                                      onPressed:
                                                                          () {
                                                                        savePayment();
                                                                      },

                                                                      child: const Text(
                                                                          '결제 금액 정보 저장'),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
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

  List orderList = [];
  List orderTypeList = [];
  List orderPabricList = [];
  List priceList = []; // 제품 자체의 금액

  List paymentHistory = []; // 제품금액 - 할인금액
  List paymentChangeHistory = []; // 제품금액 - 할인금액
  bool existOrder = true;

  void calcPrepayment(String paymentVal, String prepaymentVal, int index) {
    if (prepaymentVal == "") {
      prepaymentVal = "0";
    }

    prepayment = 0;

    if ((totalPrice -
            discountVal -
            usePointVal -
            prepayment -
            accruePrepayment) ==
        0) {
      failAlert('모든 제품이 결제 완료되었습니다.');
    }

    if (int.parse(paymentVal.replaceAll(',', '')) <
        int.parse(prepaymentVal.replaceAll(',', ''))) {
      failAlert('결제금액이 제품금액보다 클 수는 없습니다.');
    }
  }

  void calcPayment(String price, int index) {
    if (price == "") {
      price = "0";
    }

    price = price.toString().replaceAll(',', '');

    bool aaa = false;
    for (var i = 0; i < priceList.length; i++) {
      if (_controllers1[i].text.toString() == "") {
        setState(() {
          aaa = false;
        });
      } else {
        setState(() {
          aaa = true;
        });
      }
      if (!aaa) {
        break;
      }
    }
    totalPrice = 0;
    prepayment = 0;
    accruePrepayment = 0;
    if (aaa) {
      if (storeName.contains('바이각')) {
        if (customerGrade == "초") {
          gradeSaveRate = 3;
        } else if (customerGrade == "의") {
          //의등급

          gradeSaveRate = 3;
        } else if (customerGrade == "견") {
          //견등급

          gradeSaveRate = 4;
          gradeDiscountRate = 3;
        } else if (customerGrade == "학") {
          //학등급

          gradeSaveRate = 5;
          gradeDiscountRate = 4;
        } else {
          //각등급

          gradeSaveRate = 5;
          gradeDiscountRate = 5;
        }
      }
      for (var i = 0; i < priceList.length; i++) {
        totalPrice +=
            int.parse(_controllers1[i].text.toString().replaceAll(',', ''));
      }
    }
  }

  List prepaymentHistory = [];
  List orderNoList = [];
  String searchPhone = "";
  String customerGrade = "";
  int prepaymentTotal = 0;
  int accuredPrice = 0;
  int gradeDiscountRate = 0;
  int gradeSaveRate = 0;
  int discountVal = 0;
  int discountValSub = 0;
  int usePointVal = 0;
  String givePointResult = "";
  String usePointResult = "";

  String paymentDate = "";
  void getOrderData(String name, String phone, String orderDate) async {
    setState(() {
      controllerPayment = TextEditingController(text: '0');
      paymentDate = orderDate.substring(0, 10).replaceAll('-', '');
      orderList = [];
      priceList = [];
      paymentHistory = [];
      paymentChangeHistory = [];
      _controllers1 = [];

      existOrder = true;
      discountVal = 0;
      discountValSub = 0;
      usePointVal = 0;
      prepaymentTotal = 0;
      accuredPrice = 0;
      gradeDiscountRate = 0;
      gradeSaveRate = 0;
      discountVal = 0;
      discountValSub = 0;
    });
    if (phone.length == 11) {
      searchPhone = phone.substring(7, 11);
    } else if (phone.length == 10) {
      searchPhone = phone.substring(6, 10);
    }

    //기존 이력이 존재할 때
    try {
      final paymentDataResult = await firestore
          .collection('payment')
          .doc(name + '_' + searchPhone + '_' + paymentDate)
          .get();

      setState(() {
        orderList = paymentDataResult['orderList'];
        orderTypeList = paymentDataResult['orderTypeList'];
        orderPabricList = paymentDataResult['orderPabricList'];
        priceList = paymentDataResult['priceList'];
        paymentHistory = paymentDataResult['paymentHistory'];
        paymentChangeHistory = paymentDataResult['paymentChangeHistory'];
        prepaymentTotal +=
            int.parse(paymentDataResult['totalPrepayment'].toString());
        existOrder = true;

        discountVal = paymentDataResult['discount'];
        controllerDiscount = TextEditingController(
          text: numberFormat(discountVal).toString(),
        );
        discountValSub = paymentDataResult['discountSub'];
        controllerDiscountSub = TextEditingController(
          text: numberFormat(discountValSub).toString(),
        );

        usePointVal = paymentDataResult['usePoint'];
        controller = TextEditingController(
          text: numberFormat(usePointVal).toString(),
        );
        accruePrepayment = paymentDataResult['totalPrepayment'];
        totalPrice = paymentDataResult['totalPrice'];
        givePointResult = paymentDataResult['givePointResult'];
        usePointResult = paymentDataResult['usePointResult'];
      });

      for (var i = 0; i < priceList.length; i++) {
        _controllers1.add(
          TextEditingController(
            text: numberFormat(int.parse(priceList[i])).toString(),
          ),
        );
      }

      //=====================================================================================================================
      final order = await firestore
          .collection('orders')
          .where('name', isEqualTo: name.toString().trim())
          .where('phone', isEqualTo: phone.toString().trim())
          .get();

      for (var doc in order.docs) {
        if (storeName.contains('바이각')) {
          //고객전달이 완료된 제품
          if (doc['productionProcess'].toString() == '16') {
            accuredPrice += int.parse(doc['price'].toString());
          }

          if (accuredPrice == 0 || accuredPrice < 1500000) {
            //첫방문
            customerGrade = "초";
            gradeSaveRate = 3;
          } else if (accuredPrice >= 1500000 && accuredPrice < 5000000) {
            //의등급
            customerGrade = "의";
            gradeSaveRate = 3;
          } else if (accuredPrice >= 5000000 && accuredPrice < 10000000) {
            //견등급
            customerGrade = "견";
            gradeSaveRate = 4;
            gradeDiscountRate = 3;
          } else if (accuredPrice >= 10000000 && accuredPrice < 20000000) {
            //학등급
            customerGrade = "학";
            gradeSaveRate = 5;
            gradeDiscountRate = 4;
          } else {
            //각등급
            customerGrade = "각";
            gradeSaveRate = 5;
            gradeDiscountRate = 5;
          }
        }
      }

      //=====================================================================================================================
    } catch (e) {
      setState(() {
        discountVal = 0;
        usePointVal = 0;
        prepaymentTotal = 0;
        accuredPrice = 0;
        gradeDiscountRate = 0;
        gradeSaveRate = 0;
        discountVal = 0;
        discountValSub = 0;
        usePointVal = 0;

        orderList = [];
        orderNoList = [];
        priceList = [];

        _controllers1 = [];

        existOrder = false;
      });
      try {
        final order = await firestore
            .collection('orders')
            .where('name', isEqualTo: name.toString().trim())
            .where('phone', isEqualTo: phone.toString().trim())
            .get();

        for (var doc in order.docs) {
          if (doc['consultDate'].toString().substring(0, 10) == orderDate) {
            orderList.add(doc);
            orderNoList.add(doc['orderNo']);
          }

          if (storeName.contains('바이각')) {
            //고객전달이 완료된 제품
            if (doc['productionProcess'].toString() == '16') {
              accuredPrice += int.parse(doc['price'].toString());
            }

            if (accuredPrice == 0 || accuredPrice < 1500000) {
              //첫방문
              customerGrade = "초";
              gradeSaveRate = 3;
            } else if (accuredPrice >= 1500000 && accuredPrice < 5000000) {
              //의등급
              customerGrade = "의";
              gradeSaveRate = 3;
            } else if (accuredPrice >= 5000000 && accuredPrice < 10000000) {
              //견등급
              customerGrade = "견";
              gradeSaveRate = 4;
              gradeDiscountRate = 3;
            } else if (accuredPrice >= 10000000 && accuredPrice < 20000000) {
              //학등급
              customerGrade = "학";
              gradeSaveRate = 5;
              gradeDiscountRate = 4;
            } else {
              //각등급
              customerGrade = "각";
              gradeSaveRate = 5;
              gradeDiscountRate = 5;
            }
          }
        }
        //=====================================================================================================================

        for (var i = 0; i < orderList.length; i++) {
          _controllers1.add(TextEditingController(text: '0'));
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void calcDisdount(int selected) {
    discountVal = 0;
    controllerDiscount = TextEditingController(text: '0');

    setState(() {
      discountVal = (totalPrice * (selected / 100)).floor();
      controllerDiscount = TextEditingController(
          text: ((totalPrice * (selected / 100))).toString());
    });
  }

  //Get.to(InputTopSize(), arguments: {'orderData': orderData});
  String paymentOption = "";
  Future<void> updatePaymentData() async {
    if (phone.length == 11) {
      phone = phone.substring(7, 11);
    } else if (phone.length == 10) {
      phone = phone.substring(6, 10);
    }

    final payments = FirebaseFirestore.instance
        .collection('payment')
        .doc(name + '_' + phone + '_' + paymentDate);

    for (var i = 0; i < orderList.length; i++) {
      if (_controllers1[i].text.toString().replaceAll(',', '') == "" ||
          _controllers1[i].text.toString().replaceAll(',', '') == null) {
        _controllers1[i] = TextEditingController(text: '0');
      }
      priceList[i] = (_controllers1[i].text.toString().replaceAll(',', ''));
      updatePrice(orderList[i], priceList[i]);
    }

    String inputPrice = controllerPayment.text.toString().replaceAll(',', '');
    if (inputPrice == "0") {
    } else {
      paymentHistory.add(today +
          ' ' +
          moneyFormatText(
              controllerPayment.text.toString().replaceAll(',', '')) +
          ' 원 ' +
          paymentOption +
          '  결제 완료');
    }

    int givePoint = (totalPrice * (gradeSaveRate / 100)).floor();

    if (usePointResult == "N" && usePointVal != 0) {
      usePointProcess(phone, usePointVal);
      paymentHistory.add(today +
          ' ' +
          moneyFormat(usePointVal) +
          ' P ' +
          paymentOption +
          ' 사용 완료');
      return await payments.update({
        'usePoint': usePointVal,
        'usePointResult': 'Y',
        // 'totalPrepayment': prepaymentTotal + usePointVal,
        'paymentHistory': paymentHistory,
      });
    }

    if (givePointResult == "N") {
      givePointProcess(phone, givePoint, totalPrice);
      return await payments.update({
        'priceList': priceList,
        'totalPrice': totalPrice,
        'totalPrepayment': prepaymentTotal + int.parse(inputPrice),
        //'usePoint': usePointVal,
        'discount': discountVal,
        'discountSub': discountValSub,
        'givePointResult': 'Y',
        'givePoint': givePoint,
        'paymentHistory': paymentHistory,
        'paymentChangeHistory': paymentChangeHistory,
      });
    } else {
      return await payments.update({
        'totalPrepayment': prepaymentTotal + int.parse(inputPrice),
      });
    }
  }

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> updatePrice(
    String orderNo,
    String price,
  ) {
    return orders
        .doc(orderNo)
        .update({'price': price})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  List pointHistory = [];
  usePointProcess(String phone, int usePoint) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('customers')
        .doc('${name}_${phone}_${storeName}');
    pointHistory = [];
    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(doc);
          if (!snapshot.exists) {
            throw Exception('Does not exists');
          }
          //샤용포인트를 뺀다
          int updatePoint = snapshot.get("point") - usePoint;

          pointHistory = snapshot.get("pointHistory");

          pointHistory.add(today +
              ' ' +
              moneyFormat(usePoint) +
              ' P ' +
              paymentOption +
              ' 사용');

          //int purchaseAmount = snapshot.get("purchaseAmount") + totalPrice;
          //직접 값을 더하지 말고 transaction을 통해서 더하자!
          transaction.update(doc, {
            'point': updatePoint,
            'pointHistory': pointHistory,
            //'purchaseAmount': purchaseAmount
          });
          return usePoint;
        })
        .then((value) => print("Follower count updated to $value"))
        .catchError(
            (error) => print("Failed to update user followers: $error"));
  }

  givePointProcess(String phone, int givePoint, int totalPrice) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('customers')
        .doc('${name}_${phone}_${storeName}');
    pointHistory = [];
    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(doc);
          if (!snapshot.exists) {
            throw Exception('Does not exists');
          }

          //기존 갑을 가져와 1을 더해준다.
          int updatePoint = snapshot.get("point") + givePoint;
          int accruedPoint = snapshot.get("accruedPoint") + givePoint;
          int purchaseAmount = snapshot.get("purchaseAmount") + totalPrice;
          pointHistory = snapshot.get("pointHistory");
          pointHistory.add(today +
              ' ' +
              moneyFormat(givePoint) +
              ' P ' +
              paymentOption +
              ' 적립');

          //직접 값을 더하지 말고 transaction을 통해서 더하자!
          transaction.update(doc, {
            'point': updatePoint,
            'accruedPoint': accruedPoint,
            'purchaseAmount': purchaseAmount,
            'pointHistory': pointHistory,
          });
          return givePoint;
        })
        .then((value) => print("Follower count updated to $value"))
        .catchError(
            (error) => print("Failed to update user followers: $error"));
  }

  void savePayment() {
    try {
      updatePaymentData();

      setState(() {
        _isLoading = true;
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _isLoading = false;
          });
        });
        priceInputView = false;
        getOrderData(name, phone, dateFormat(paymentDate));
      });
    } catch (e) {
      print(e);
    }
  }
}
