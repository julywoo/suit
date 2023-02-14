import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/model/tailorShop/consult_options_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class CostSetting extends StatefulWidget {
  CostSetting({Key? key}) : super(key: key);

  @override
  State<CostSetting> createState() => _CostSettingState();
}

class _CostSettingState extends State<CostSetting> {
  @override
  String? selectedValue;
  String? selectedRate;
  String options = Get.arguments['options'];
  String factoryNameVal = Get.arguments['factoryName'];
  // factoryName

  final _formKey = GlobalKey<FormState>();
  final factoryName = TextEditingController();
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState

    getData();
    getConsultData();
    super.initState();
  }

  var brandListResult;
  List<String> brandList = [""];
  String brandListInit = "";

  late List<String> storeList;
  var storeInitVal = '공통공임';

  getTailorShopBrand(String storeName) async {
    brandList = [];
    var doc;
    var brandListResult =
        await firestore.collection('tailorShop').doc(storeName).get();

    setState(() {
      // if (storeInitVal == "공통공임") {
      //   brandListInit = "";
      //   brandList.add("");
      // } else {
      //   brandListInit = brandListResult['brandRate1'];
      //   //brandList.add("");
      if (brandListResult['brandRate1'] == "") {
        brandList.add('제작공임(등급별 공임비가 같은 경우)');
      } else {
        if (brandListResult['brandRate1'] != "") {
          brandList.add(brandListResult['brandRate1']);
        }
        if (brandListResult['brandRate2'] != "") {
          brandList.add(brandListResult['brandRate2']);
        }
        if (brandListResult['brandRate3'] != "") {
          brandList.add(brandListResult['brandRate3']);
        }
        if (brandListResult['brandRate4'] != "") {
          brandList.add(brandListResult['brandRate4']);
        }
        if (brandListResult['brandRate5'] != "") {
          brandList.add(brandListResult['brandRate5']);
        }
      }

      // }
    });
  }

  List<TextEditingController> _controllers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black),
          ),
        ),
        elevation: 2,
        title: Text(
          '공임비 가격 설정',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
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
          : SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Container(
                    width: 400,
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '공장명',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              //initialValue: factoryNameVal,
                              controller: factoryName,
                              style: TextStyle(fontSize: 14),
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
                                hintText: '제작 공장명을 입력하세요.',
                                hintStyle: const TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '제품등급',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField2(
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: mainColor,
                                  ),
                                ),
                                //Add isDense true and zero Padding.
                                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                //Add more decoration as you want here
                                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                              ),
                              isExpanded: true,
                              hint: const Text(
                                '제품 등급을 선택하세요.',
                                style: TextStyle(fontSize: 14),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 30,
                              buttonHeight: 60,
                              buttonPadding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              items: brandList
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select gender.';
                                }
                              },
                              onChanged: (value) {
                                //Do something when changing the item if you want.

                                setState(() {
                                  selectedRate = value.toString();
                                });
                              },
                              onSaved: (value) {
                                selectedRate = value.toString();
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '제작옵션',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField2(
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: mainColor,
                                  ),
                                ),
                                //Add isDense true and zero Padding.
                                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                //Add more decoration as you want here
                                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                              ),
                              isExpanded: true,
                              hint: const Text(
                                '공임 항목을 선택하세요.',
                                style: TextStyle(fontSize: 14),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 30,
                              buttonHeight: 60,
                              buttonPadding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              items: costSettingStep
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select gender.';
                                }
                              },
                              onChanged: (value) {
                                //Do something when changing the item if you want.

                                setState(() {
                                  inputForm = true;
                                  selectedVal = value.toString();
                                  selectedValOption =
                                      costSettingStep.indexOf(value);
                                });
                              },
                              onSaved: (value) {
                                selectedValue = value.toString();
                              },
                            ),
                            const SizedBox(height: 30),
                            inputForm
                                ? Container(
                                    height: costSettingVal[selectedValOption]
                                            .length *
                                        100,
                                    child: ListView.builder(
                                      itemCount:
                                          costSettingVal[selectedValOption]
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        _controllers
                                            .add(new TextEditingController());
                                        return Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                costSettingVal[
                                                            selectedValOption]
                                                        [index]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                inputFormatters: [
                                                  ThousandsFormatter()
                                                ],
                                                controller: _controllers[index],
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide: BorderSide(
                                                      color: mainColor,
                                                    ),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 20,
                                                    vertical: 20,
                                                  ),
                                                  hintStyle: const TextStyle(
                                                      fontSize: 14),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                onSaved: (val) {
                                                  String valTemp = val
                                                      .toString()
                                                      .replaceAll(',', '');
                                                  if (valTemp.toString() ==
                                                          '' ||
                                                      valTemp.toString() ==
                                                          null) {
                                                    optionsCost.add(0);
                                                  } else {
                                                    optionsCost.add(int.parse(
                                                        valTemp.toString()));

                                                    // setState(() {
                                                    //   optionsCost[index] =
                                                    //       _controllers[index]
                                                    //           .text
                                                    //           .toString();
                                                    //   // val.toString();
                                                    // });
                                                  }
                                                  optionsList.add(costSettingVal[
                                                              selectedValOption]
                                                          [index]
                                                      .toString());
                                                },
                                                validator: (val) {
                                                  return null;
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(),
                            Container(
                              padding: EdgeInsets.only(bottom: 50),
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
                                        onSurface:
                                            Colors.white, //onpressed가 null일때 색상
                                        backgroundColor: HexColor('#172543'),
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
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                        }
                                        showDialog(
                                            context: Get.context!,
                                            builder: (context) => MessagePopup(
                                                  title: '가격 저장',
                                                  message:
                                                      '입력된 정보로 공임비를 저장하시겠습니까?',
                                                  okCallback: () {
                                                    saveOptions();
                                                    //controller.ChangeInitPage();
                                                    Get.back();
                                                  },
                                                  cancleCallback: Get.back,
                                                ));
                                      },

                                      child: const Text('공임비 저장'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

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
      getTailorShopBrand(storeName);
    } catch (e) {}
  }

  late int selectedValOption;
  String selectedVal = '';
  List costSettingStep = [];
  List costSettingVal = [];

  bool inputForm = false;

  getConsultData() async {
    try {
      var consultOptionsResult;
      try {
        consultOptionsResult =
            await firestore.collection('consultsOptions').doc(storeName).get();
      } catch (e) {
        consultOptionsResult =
            await firestore.collection('consultsOptions').doc('기본상담').get();
      }

      setState(() {
        if (options == '자켓') {
          costSettingStep = consultOptionsResult['jacketStep'];
        } else if (options == '조끼') {
          costSettingStep = consultOptionsResult['vestStep'];
        } else if (options == '바지') {
          costSettingStep = consultOptionsResult['pantsStep'];
        } else if (options == '셔츠') {
          costSettingStep = consultOptionsResult['shirtStep'];
        } else {
          costSettingStep = consultOptionsResult['coatStep'];
        }

        // vestStep = consultOptionsResult['vestStep'];
        // pantsStep = consultOptionsResult['pantsStep'];
        // shirtStep = consultOptionsResult['shirtStep'];
        // coatStep = consultOptionsResult['coatStep'];
      });
      for (var i in costSettingStep) {
        var result = await firestore
            .collection('consultsOptions')
            .doc('기본상담')
            .collection(options)
            .doc(i)
            .get();

        if ((result['optionsList'].length == 1 &&
            result['optionsList'][0].replaceAll(' ', '') == '')) {
          costSettingVal.add('');
        } else {
          costSettingVal.add(result['optionsList']);
        }
      }
      costSettingStep.insert(0, '기본공임');
      // costSettingStep.add();
      costSettingVal.insert(0, ['기본공임', '가봉공임', '중가봉공임']);
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {}
  }

  List<int> optionsCost = [];
  List<String> optionsList = [];
  void saveOptions() {
    final consultsOptions = FirebaseFirestore.instance
        .collection('produceCost')
        .doc(
            storeName + '_' + factoryName.text + '_' + selectedRate.toString());
    // .collection(options)
    // .doc(_nameController.text.toString());
    ConsultOptions _costOptions = ConsultOptions(
      factoryName: factoryName.text.toString(),
      storeName: storeName,
      brandRate: selectedRate,
    );

    ConsultOptions _costOptionsDetail = ConsultOptions(
        factoryName: factoryName.text.toString(),
        storeName: storeName,
        brandRate: selectedRate,
        options: options,
        optionsTitle: selectedVal,
        optionsList: optionsList,
        optionsProduceCost: optionsCost);

    try {
      consultsOptions.set(_costOptions.toJson());
      consultsOptions
          .collection('costDetail')
          .doc(options + '_' + selectedVal)
          .set(_costOptionsDetail.toJson());
    } catch (e) {
      print(e);
    }
    setState(() {
      optionsCost = [];
      optionsList = [];
      _controllers = [];
    });
  }
}
