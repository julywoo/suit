import 'dart:io';

import 'package:bykak/src/components/alert_fucntion.dart';
import 'package:bykak/src/components/consult_typing_popup.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/order_model.dart';
import 'package:bykak/src/model/shirt_design.dart';
import 'package:bykak/src/model/shirt_design_val.dart';
import 'package:bykak/src/model/shirt_size_model.dart';
import 'package:bykak/src/model/suit_design_model.dart';
import 'package:bykak/src/model/suit_design_val.dart';
import 'package:bykak/src/model/suit_option.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/model/vest_size_model.dart';
import 'package:bykak/src/pages/custom_clothes_step2.dart';
import 'package:bykak/src/pages/tailorShop/pants_design_choice.dart';
import 'package:bykak/src/widget/custom_text_form_field.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:photo_view/photo_view.dart';

class VestDesignChoice extends StatefulWidget {
  const VestDesignChoice({Key? key}) : super(key: key);

  @override
  State<VestDesignChoice> createState() => _VestDesignChoiceState();
}

class _VestDesignChoiceState extends State<VestDesignChoice> {
  int orderType = Get.arguments['orderType'];
  String orderNo = Get.arguments['orderNo'];

  //List<String> orderNoList = Get.arguments['orderNoList'];
  var orderNoList = Get.arguments['orderNoList'];
  Map selectedOption = {};
  Order orderData = Get.arguments['orderData'];

  int itemCnt = 0;
  late int startIndex;
  late List suitSet;
  final formKey = GlobalKey<FormState>();
  CarouselController cs = CarouselController();

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
      getConsultData();
    } catch (e) {}
  }

  List vestStep = [];
  List vestOptions = [];
  List vestOptionsSub = [];
  List vestOptionsTyping = [];

  List shirtStep = [];
  List coatStep = [];

  String typingText = "";

  List selectResult = [];

  int currentStep = -0;
  GroupButtonController controller1 = GroupButtonController();

  getConsultData() async {
    try {
      var consultOptionsResult;

      try {
        consultOptionsResult =
            await firestore.collection('consultsOptions').doc(storeName).get();
        if (consultOptionsResult['vestStep'] == null) {
          consultOptionsResult =
              await firestore.collection('consultsOptions').doc('기본상담').get();
        }
      } catch (e) {
        consultOptionsResult =
            await firestore.collection('consultsOptions').doc('기본상담').get();
      }

      setState(() {
        vestStep = consultOptionsResult['vestStep'];
        // vestStep = consultOptionsResult['vestStep'];
        // pantsStep = consultOptionsResult['pantsStep'];
        // shirtStep = consultOptionsResult['shirtStep'];
        // coatStep = consultOptionsResult['coatStep'];
      });

      for (var i in vestStep) {
        try {
          var result = await firestore
              .collection('consultsOptions')
              .doc('기본상담')
              .collection('조끼')
              .doc(i.toString().trim())
              .get();

          if (result['optionsList'].length == 1 &&
              result['optionsList'][0].replaceAll(' ', '') == '') {
            vestOptions.add(['직접입력']);
          } else {
            vestOptions.add(result['optionsList']);
          }
          vestOptionsSub.add(result['optionsSubList']);
          vestOptionsTyping.add(result['typingOption']);
        } catch (e) {
          continue;
        }
      }

      for (var i = 0; i < vestStep.length; i++) {
        selectResult.add(-1);
      }
    } catch (e) {}
  }

  @override
  void initState() {
    getData();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  int step = 0;
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    var widVal = MediaQuery.of(context).size.width;
    var heightVal = MediaQuery.of(context).size.height;
    heightVal < 850
        ? SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ])
        : SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);

    return Scaffold(
      floatingActionButton: _isLoading
          ? null
          : Wrap(
              //will break to another line on overflow
              direction: Axis.vertical, //use vertical to show  on vertical axis
              children: <Widget>[
                Container(
                    width: 150,
                    margin: EdgeInsets.all(10),
                    child: FloatingActionButton.extended(
                      label: Text(
                        '조끼 비구매',
                        style: TextStyle(fontSize: 14),
                      ),
                      onPressed: () {
                        //orders.update(orderData.toJson());
                        Get.to(PantsDesignChoice(), arguments: {
                          'orderData': orderData,
                          'orderNo': orderNo,
                          'orderType': orderType
                        });
                      },
                      backgroundColor: mainColor,
                      // child: Icon(Icons.add),
                    )), // button third

                // Add more buttons here
                Container(
                  width: 150,
                  margin: EdgeInsets.all(10),
                  child: FloatingActionButton.extended(
                    backgroundColor: subColor,
                    icon: Icon(Icons.search_sharp),
                    label: Text(
                      '옵션 보기',
                      style: TextStyle(fontSize: 14),
                    ),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: 400,
                          maxHeight: Get.height * 0.8,
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(height: 10),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: vestStep.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              cs.animateToPage(index);
                                              Get.back();
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 200,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color:
                                                      selectResult[index] == -1
                                                          ? Colors.white
                                                          : mainColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                      color: mainColor,
                                                      style: BorderStyle.solid,
                                                      width: 1)),
                                              child: Text(
                                                vestStep[index].toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      selectResult[index] == -1
                                                          ? mainColor
                                                          : Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ), // becond

                Container(
                    width: 150,
                    margin: EdgeInsets.all(10),
                    child: FloatingActionButton.extended(
                      label: Text(
                        '디자인 저장',
                        style: TextStyle(fontSize: 14),
                      ),
                      onPressed: () {
                        if (selectResult.contains(-1)) {
                          resultAlert('제품 옵션 값이 모두 선택되었는지 확인하세요.');
                        } else {
                          saveDesign();
                        }
                      },
                      backgroundColor: mainColor,
                      // child: Icon(Icons.add),
                    )), // button third

                // Add more buttons here
              ],
            ),
      appBar: AppBar(),
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
          : Center(
              child: Container(
                width: 400,
                child: CarouselSlider.builder(
                  carouselController: cs,
                  options: CarouselOptions(
                    scrollDirection: Axis.vertical,
                    height: Get.height,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                  ),
                  itemCount: vestStep.length,
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                vestStep[itemIndex],
                                style: TextStyle(
                                    color: mainColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: GroupButton(
                            controller: controller1 = GroupButtonController(
                              selectedIndex: selectResult[itemIndex],
                            ),
                            onSelected: (dynamic, index, isSelected) {
                              if (vestOptionsTyping[itemIndex] != "") {
                                showDialog(
                                    context: Get.context!,
                                    builder: (context) => ConsultTypingPopup(
                                          title: vestOptionsTyping[itemIndex]
                                              .toString(),
                                          message: vestOptionsTyping[itemIndex]
                                                  .toString() +
                                              '값 입력',
                                          okCallback: (String val) {
                                            setState(() {
                                              selectResult[itemIndex] = index;
                                              typingText =
                                                  '[ ' + val.toString() + ' ]';

                                              selectedOption[
                                                      vestStep[itemIndex]] =
                                                  vestOptions[itemIndex]
                                                          [index] +
                                                      typingText.toString();
                                              cs.nextPage(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.linear);

                                              if (vestStep.length ==
                                                  pageViewIndex + 1) {
                                                saveDesign();
                                              } else {
                                                //  itemIndex += 1;
                                              }
                                              typingText = '';
                                            });

                                            Get.back();
                                          },
                                          cancleCallback: Get.back,
                                        ));
                              } else {
                                setState(
                                  () {
                                    selectedOption[vestStep[itemIndex]] =
                                        vestOptions[itemIndex][index];

                                    selectResult[itemIndex] = index;

                                    if (vestStep.length == pageViewIndex + 1) {
                                      // shirtDesign;
                                      saveDesign();
                                    } else {
                                      if ((vestOptionsSub[itemIndex].length >
                                              0 &&
                                          vestOptionsSub[itemIndex][0] != '')) {
                                      } else {
                                        cs.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear);
                                      }
                                    }
                                  },
                                );
                              }
                            },
                            options: GroupButtonOptions(
                              mainGroupAlignment: MainGroupAlignment.start,
                              crossGroupAlignment: CrossGroupAlignment.start,
                              groupRunAlignment: GroupRunAlignment.start,
                              buttonWidth: 170,
                              buttonHeight: 40,
                              spacing: 10,
                              direction: Axis.horizontal,
                              selectedTextStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: mainColor,
                              ),
                              unselectedTextStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              selectedColor: Colors.white,
                              unselectedColor: Colors.grey[300],
                              selectedBorderColor: mainColor,
                              unselectedBorderColor: Colors.grey[500],
                              borderRadius: BorderRadius.circular(25.0),
                              selectedShadow: <BoxShadow>[
                                BoxShadow(color: Colors.transparent)
                              ],
                              unselectedShadow: <BoxShadow>[
                                BoxShadow(color: Colors.transparent)
                              ],
                            ),
                            isRadio: true,
                            buttons: vestOptions[itemIndex],
                          ),
                        ),
                        (vestOptionsSub[itemIndex].length > 0 &&
                                vestOptionsSub[itemIndex][0] != '')
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '상세 옵션',
                                          style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: GroupButton(
                                      onSelected: (value, index, isSelected) {
                                        if ((vestOptionsSub[itemIndex].length >
                                                0 &&
                                            vestOptionsSub[itemIndex][0] !=
                                                '')) {
                                          cs.nextPage(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.linear);
                                        }
                                      },
                                      options: GroupButtonOptions(
                                        mainGroupAlignment:
                                            MainGroupAlignment.start,
                                        crossGroupAlignment:
                                            CrossGroupAlignment.start,
                                        groupRunAlignment:
                                            GroupRunAlignment.start,
                                        buttonWidth: 170,
                                        buttonHeight: 40,
                                        spacing: 10,
                                        direction: Axis.horizontal,
                                        selectedTextStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: mainColor,
                                        ),
                                        unselectedTextStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                        selectedColor: Colors.white,
                                        unselectedColor: Colors.grey[300],
                                        selectedBorderColor: mainColor,
                                        unselectedBorderColor: Colors.grey[500],
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        selectedShadow: <BoxShadow>[
                                          BoxShadow(color: Colors.transparent)
                                        ],
                                        unselectedShadow: <BoxShadow>[
                                          BoxShadow(color: Colors.transparent)
                                        ],
                                      ),
                                      isRadio: true,
                                      buttons: vestOptionsSub[itemIndex],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  TopSize? _inputTopSize;
  BottomSize? _inputBottomSize;
  VestSize? _inputVestSize;
  ShirtSize? _inputShirtSize;
  ShirtDesign? _inputShirtDesign;
  ShirtDesignVal? _inputShirtDesignVal;
  SuitDesign? _inputSuitDesign;
  SuitDesignVal? _inputSuitDesignVal;
  void saveDesign() {
    final orders = FirebaseFirestore.instance.collection('orders').doc(orderNo);

    _inputSuitDesign = SuitDesign();
    _inputSuitDesignVal = SuitDesignVal();

    _inputShirtSize = ShirtSize();
    _inputTopSize = TopSize();
    _inputBottomSize = BottomSize();
    _inputVestSize = VestSize();
    _inputShirtDesign = ShirtDesign();
    _inputShirtDesignVal = ShirtDesignVal();

    //새로운 디자인 입력 방식 2022.12.27
    orderData.vestOption = selectedOption;

    ///
    orderData.topSize = _inputTopSize;
    orderData.bottomSize = _inputBottomSize;
    orderData.vestSize = _inputVestSize;
    orderData.shirtSize = _inputShirtSize;
    orderData.suitDesign = _inputSuitDesign;
    orderData.suitDesignVal = _inputSuitDesignVal;
    orderData.shirtDesign = _inputShirtDesign;
    orderData.shirtDesignVal = _inputShirtDesignVal;

    //orders.add(orderData.toJson());

    //Get.to(InputTopSize(), arguments: {'orderData': orderData});
    Future<void> updateUserData() async {
      return await orders.update({
        'vestOption': selectedOption,
      });
    }

    try {
      if (orderType == 4) {
        orders.set(orderData.toJson());
        Get.offAll(CustomClothesStep2(), arguments: {
          'orderData': orderData,
          'orderNo': orderNo,
          //'orderNoList': orderNoList
        });
      } else {
        updateUserData();
        //orders.update(orderData.toJson());
        Get.to(PantsDesignChoice(), arguments: {
          'orderData': orderData,
          'orderNo': orderNo,
          'orderType': orderType
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
