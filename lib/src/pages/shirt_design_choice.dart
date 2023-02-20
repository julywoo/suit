import 'package:bykak/src/app.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/order_model.dart';
import 'package:bykak/src/model/shirt_design.dart';
import 'package:bykak/src/model/shirt_design_val.dart';
import 'package:bykak/src/model/shirt_option.dart';
import 'package:bykak/src/model/shirt_size_model.dart';
import 'package:bykak/src/model/suit_design_model.dart';
import 'package:bykak/src/model/suit_design_val.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/pages/home.dart';
import 'package:bykak/src/pages/input_top_size.dart';
import 'package:bykak/src/pages/search_page.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ShirtDesignChoice extends StatefulWidget {
  const ShirtDesignChoice({Key? key}) : super(key: key);

  @override
  State<ShirtDesignChoice> createState() => _ShirtDesignChoiceState();
}

class _ShirtDesignChoiceState extends State<ShirtDesignChoice> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  // List<String> checkOption = [];
  // List<String> checkOptionVal = [];

  final checkOption = List<String>.filled(5, "");
  final checkOptionVal = List<String>.filled(5, "");
  String? jacketButton;
  String? jacketLapel;
  String? chestPocket;
  String? jacketShoulder;
  String? jacketSidePocket;

  ShirtDesign? shirtDesign;
  ShirtDesignVal? shirtDesignVal;
  SwiperController _controller = SwiperController();

  final double runSpacing = 4;
  final double spacing = 4;

  @override
  Widget build(BuildContext context) {
    var heightVal = MediaQuery.of(context).size.height;
    var widthVal = MediaQuery.of(context).size.width;
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Swiper(
            //physics: NeverScrollableScrollPhysics(),
            itemCount: shirtOption.length,
            loop: false,
            control: const SwiperControl(
                color: Colors.transparent,
                disableColor: Colors.transparent,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
            controller: _controller,
            itemBuilder: (BuildContext context, int index1) {
              List<String> selectList =
                  List.from(shirtOption[index1]['selectList']);
              List<String> selectListVal =
                  List.from(shirtOption[index1]['selectListVal']);

              return GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    Container(
                      decoration: BoxDecoration(
                        color: HexColor('#172543'),
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0),
                        ),
                      ),
                      height: selectListVal.length > 8
                          ? heightVal < 480
                              ? 180
                              : 220
                          : heightVal < 480
                              ? 140
                              : 170,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Wrap(
                          // crossAxisCount: 4, //1 개의 행에 보여줄 item 개수
                          // childAspectRatio: 4 / 1, //item 의 가로 1, 세로 2 의 비율
                          // mainAxisSpacing: 10, //수평 Padding
                          // crossAxisSpacing: 10, //수직 Padding
                          runSpacing: runSpacing,
                          spacing: spacing,
                          alignment: WrapAlignment.center,
                          children: List.generate(selectList.length, (index) {
                            //item 의 반목문 항목 형성
                            return Container(
                              width: heightVal < 480
                                  ? widthVal * 0.23
                                  : widthVal * 0.23,
                              height: heightVal < 480 ? 40 : 55,
                              // padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              color: HexColor('#172543'),
                              child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  primary: HexColor('#172543'), //글자색
                                  onSurface:
                                      Colors.white, //onpressed가 null일때 색상
                                  backgroundColor: Colors.white,
                                  shape:
                                      StadiumBorder(), // : 각진버튼, CircleBorder :
                                  side: BorderSide(
                                      color: HexColor('#172543'),
                                      width: 1.0), //선
                                ),
                                onPressed: () {
                                  var list;
                                  var listVal;
                                  // if (selectList[index].toString() == "") {
                                  //   selectList = " ";
                                  // } else {
                                  list = selectList[index].toString();
                                  listVal = selectListVal[index].toString();
                                  //}
                                  // checkOption.add(list);
                                  // checkOptionVal.add(listVal);
                                  setState(() {
                                    checkOption[index1] = list;
                                    checkOptionVal[index1] = listVal;
                                    Get.back();
                                    if (index1 == 4) {
                                      saveDesign();
                                      //Get.to(InputTopSize());
                                    } else {
                                      _controller.next();
                                    }
                                  });
                                },
                                child: Text(selectList[index].toString()),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                    alignment: Alignment.center,
                    child: PhotoView(
                      imageProvider:
                          AssetImage(shirtOption[index1]['optionImg']),
                    )),
              );
            }),
      ),
    );
  }

  ShirtSize? _inputShirtSize;

  TopSize? _inputTopSize;
  BottomSize? _inputBottomSize;
  SuitDesign? _inputSuitDesign;
  SuitDesignVal? _inputSuitDesignVal;
  void saveDesign() {
    String orderNo = Get.arguments['orderNo'];
    final orders = FirebaseFirestore.instance.collection('orders').doc(orderNo);

    shirtDesign = ShirtDesign(
      shirtPattern: checkOption[0],
      shirtCollar: checkOption[1],
      shirtCuffs: checkOption[2],
      shirtPlacket: checkOption[3],
      shirtOption: checkOption[4],
    );
    shirtDesignVal = ShirtDesignVal(
      shirtPattern: checkOptionVal[0],
      shirtCollar: checkOptionVal[1],
      shirtCuffs: checkOptionVal[2],
      shirtPlacket: checkOptionVal[3],
      shirtOption: checkOptionVal[4],
    );
    _inputShirtSize = ShirtSize();
    _inputTopSize = TopSize();
    _inputBottomSize = BottomSize();
    _inputSuitDesign = SuitDesign();
    _inputSuitDesignVal = SuitDesignVal();

    var orderData = Get.arguments['orderData'];
    orderData.shirtDesign = shirtDesign as ShirtDesign;
    orderData.shirtDesignVal = shirtDesignVal as ShirtDesignVal;
    orderData.topSize = _inputTopSize;
    orderData.bottomSize = _inputBottomSize;
    orderData.shirtSize = _inputShirtSize;
    orderData.suitDesign = _inputSuitDesign;
    orderData.suitDesignVal = _inputSuitDesignVal;

    //orders.add(orderData.toJson());
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //Get.to(InputTopSize(), arguments: {'orderData': orderData});

    try {
      orders.set(orderData.toJson());
      Get.offAll(App());
    } catch (e) {
      printError();
    }
  }
}
