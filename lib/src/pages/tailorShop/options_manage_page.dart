import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/model/tailorShop/consult_options_model.dart';
import 'package:bykak/src/pages/tailorShop/options_select_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionsManage extends StatefulWidget {
  @override
  _OptionsManageState createState() => _OptionsManageState();
}

class _OptionsManageState extends State<OptionsManage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _typingOption;
  static List<String> optionsList = [''];
  static List<String> optionsSubList = [''];
  String options = Get.arguments['options'];

  @override
  void initState() {
    optionsList = [''];
    optionsSubList = [''];
    _nameController = TextEditingController();
    _typingOption = TextEditingController();
    print(options.toString());
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typingOption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('상담 옵션 입력'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 400,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name textfield
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(hintText: '옵션명을 입력하세요.'),
                        validator: (v) {
                          if (v!.trim().isEmpty)
                            return 'Please enter something';
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        '옵션값 추가',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),

                    ..._getFriends(),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        '서브 옵션값 추가',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),

                    ..._getFriend1(),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        '직접 입력옵션 추가',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: _typingOption,
                        decoration: InputDecoration(hintText: '옵션명을 입력하세요.'),
                        validator: (v) {
                          // if (v!.trim().isEmpty) return 'Please enter something';
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

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
                          side: BorderSide(
                              color: HexColor('#172543'), width: 1.0), //선
                          shape:
                              StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
                          alignment: Alignment.center,
                        ), //글자위치 변경
                        onPressed: () {
                          aaa();
                          saveOptions();
                          Get.to(OptionsSelect());
                        },

                        child: const Text('상담 옵션 순서 변경'),
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     if (_formKey.currentState!.validate()) {
                    //       //_formKey.currentState?.save();
                    //     }
                    //     // print(optionsList);
                    //     // print(optionsSubList);
                    //     saveOptions();
                    //     Get.to(OptionsSelect());
                    //   },
                    //   child: Text('Submit'),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// get firends text-fields
  List<Widget> _getFriends() {
    List<Widget> optionsTextFields = [];
    for (int i = 0; i < optionsList.length; i++) {
      optionsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: OptionsTextFields(i)),
                    SizedBox(
                      width: 16,
                    ),
                    // we need add button at last friends row
                    _addRemoveButton(i == optionsList.length - 1, i),
                  ],
                ),
                // Row(
                //   children: [
                //     Expanded(child: OptionsValTextFields(i)),
                //     SizedBox(
                //       width: 46,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ));
    }
    return optionsTextFields;
  }

  /// get firends text-fields
  List<Widget> _getFriend1() {
    List<Widget> optionsTextFields1 = [];
    for (int i = 0; i < optionsSubList.length; i++) {
      optionsTextFields1.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: OptionsValTextFields(i)),
                    SizedBox(
                      width: 16,
                    ),
                    // we need add button at last friends row
                    _addRemoveButton1(i == optionsSubList.length - 1, i),
                  ],
                ),
                // Row(
                //   children: [
                //     Expanded(child: OptionsValTextFields(i)),
                //     SizedBox(
                //       width: 46,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ));
    }
    return optionsTextFields1;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          optionsList.add('');
          //  optionsSubList.add('');
          // optionsList.insert(optionsList.length, '');
          // optionsSubList.insert(optionsList.length, '');
        } else {
          optionsList.removeAt(index);
          // optionsSubList.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  /// add / remove button
  Widget _addRemoveButton1(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          // optionsList.add('');
          optionsSubList.add('');
          // optionsList.insert(optionsList.length, '');
          // optionsSubList.insert(optionsList.length, '');
        } else {
          // optionsList.removeAt(index);
          optionsSubList.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  List tempList = [];
  final firestore = FirebaseFirestore.instance;
  void aaa() async {
    var consultOptionsResult =
        await firestore.collection('consultsOptions').doc('기본상담').get();
    var fieldName;

    if (options == '자켓') {
      setState(() {
        tempList = consultOptionsResult['jacketStep'];
      });
    } else if (options == '조끼') {
      setState(() {
        tempList = consultOptionsResult['vestStep'];
      });
    } else if (options == '바지') {
      setState(() {
        tempList = consultOptionsResult['pantsStep'];
      });
    } else if (options == '셔츠') {
      setState(() {
        tempList = consultOptionsResult['shirtStep'];
        fieldName = 'shirtStep';
      });
    } else {}

    tempList.add(_nameController.text.toString());
    final consultsOptions =
        FirebaseFirestore.instance.collection('consultsOptions').doc('기본상담');

    Future<void> updateUserData() async {
      return await consultsOptions.update({fieldName: tempList});
    }

    try {
      updateUserData();
    } catch (e) {
      print(e);
    }
  }

  void saveOptions() {
    final consultsOptions =
        FirebaseFirestore.instance.collection('consultsOptions').doc('기본상담');
    // .collection(options)
    // .doc(_nameController.text.toString());

    ConsultOptions _consultOptions = ConsultOptions(
        optionsTitle: _nameController.text.toString(),
        typingOption: _typingOption.text.toString(),
        optionsList: optionsList,
        optionsSubList: optionsSubList);

    try {
      consultsOptions
          .collection(options)
          .doc(_nameController.text.toString())
          .set(_consultOptions.toJson());
    } catch (e) {
      print(e);
    }
  }
}

class OptionsTextFields extends StatefulWidget {
  final int index;
  OptionsTextFields(this.index);
  @override
  _OptionsTextFieldsState createState() => _OptionsTextFieldsState();
}

class _OptionsTextFieldsState extends State<OptionsTextFields> {
  late TextEditingController _optionsController;

  @override
  void initState() {
    super.initState();
    _optionsController = TextEditingController();
  }

  @override
  void dispose() {
    _optionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _optionsController.text = _OptionsManageState.optionsList[widget.index];
    });

    return TextFormField(
      controller: _optionsController,
      onChanged: (v) => _OptionsManageState.optionsList[widget.index] = v,
      decoration: InputDecoration(hintText: '옵션 선택 값을 입력하세요'),
      validator: (v) {
        // if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}

class OptionsValTextFields extends StatefulWidget {
  final int index;
  OptionsValTextFields(this.index);
  @override
  _OptionsValTextFieldsState createState() => _OptionsValTextFieldsState();
}

class _OptionsValTextFieldsState extends State<OptionsValTextFields> {
  late TextEditingController _optionsValController;

  @override
  void initState() {
    super.initState();
    _optionsValController = TextEditingController();
  }

  @override
  void dispose() {
    _optionsValController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _optionsValController.text =
          _OptionsManageState.optionsSubList[widget.index];
    });

    return TextFormField(
      controller: _optionsValController,
      onChanged: (v) => _OptionsManageState.optionsSubList[widget.index] = v,
      decoration: InputDecoration(hintText: '작업지시서에 표현될 값을 입력하세요.'),
      validator: (v) {
        // if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
