import 'package:bykak/src/app.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/model/tailorShop/consult_options_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConsultStepChangeDetail extends StatefulWidget {
  ConsultStepChangeDetail({Key? key}) : super(key: key);

  @override
  State<ConsultStepChangeDetail> createState() =>
      _ConsultStepChangeDetailState();
}

class _ConsultStepChangeDetailState extends State<ConsultStepChangeDetail> {
  String option = Get.arguments['options'];
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  bool isSort = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: mainColor,
        icon: Icon(Icons.save),
        label: Text('Save'),
        onPressed: () {
          print(_items.toString());
          setState(() {
            saveOptions();
          });
        },
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black),
        ),
        elevation: 2,
        title: Center(
          child: Text(
            '상담 옵션 순서 변경 및 삭제',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(App());
            },
            icon: Icon(Icons.home_filled, size: 25.0, color: Colors.black),
          ),
          Container(
            width: 25,
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 400,
          child: ReorderableListView(
            shrinkWrap: true,
            header: Container(
              height: 50,
            ),
            footer: Container(
              height: 50,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40),
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final moveItem = _items.removeAt(oldIndex);
                _items.insert(newIndex, moveItem);
              });
            },
            children: _items
                .map((item) => Dismissible(
                      key: Key(item),
                      background: Container(
                          // margin: const EdgeInsets.all(8),
                          // padding: const EdgeInsets.symmetric(horizontal: 20),
                          // color: Colors.green,
                          // alignment: Alignment.centerLeft,
                          // child: const Icon(
                          //   Icons.save,
                          //   size: 36,
                          //   color: Colors.white,
                          // ),
                          ),
                      secondaryBackground: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.delete,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          return showDialog(
                              context: Get.context!,
                              builder: (context) => MessagePopup(
                                    title: '상담 옵션 삭제',
                                    message: '상담 목록에서 해당 옵션을 하시겠습니까?',
                                    okCallback: () {
                                      setState(() {
                                        _items.remove(item);
                                      });
                                      Get.back();
                                    },
                                    cancleCallback: Get.back,
                                  ));
                        } else {}
                        return Future.value(false);
                      },
                      child: Card(
                        child: Container(
                          width: 250,
                          height: 100,
                          child: Center(child: Text('$item')),
                          //subtitle: Text('Item : $item'),
                          //leading: Icon(Icons.drag_handle),
                        ),
                      ),
                    ))
                .toList(),
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
      getConsultData();
    } catch (e) {}
  }

  List _items = [];
  List optionsStep = [];
  getConsultData() async {
    print(option);
    var consultOptionsResult;

    try {
      consultOptionsResult =
          await firestore.collection('consultsOptions').doc('기본상담').get();
    } catch (e) {
      consultOptionsResult =
          await firestore.collection('consultsOptions').doc('기본상담').get();
    }

    setState(
      () {
        if (option == '자켓') {
          _items = consultOptionsResult['jacketStep'];
        } else if (option == '조끼') {
          _items = consultOptionsResult['vestStep'];
        } else if (option == '바지') {
          _items = consultOptionsResult['pantsStep'];
        } else if (option == '셔츠') {
          _items = consultOptionsResult['shirtStep'];
        } else {
          _items = consultOptionsResult['coatStep'];
        }
      },
    );
  }

  //Get.to(InputTopSize(), arguments: {'orderData': orderData});

  void saveOptions() async {
    final consultsOptions =
        FirebaseFirestore.instance.collection('consultsOptions').doc(storeName);
    // .collection(options)
    // .doc(_nameController.text.toString());
    // ConsultOptions _costOptions = ConsultOptions(
    //   storeName: storeName,
    //   jacketStep: _items,
    // );

    ConsultOptions _costOptions = ConsultOptions();
    if (option == '자켓') {
      _costOptions = ConsultOptions(
        storeName: storeName,
        jacketStep: _items,
      );
    } else if (option == '조끼') {
      _costOptions = ConsultOptions(
        storeName: storeName,
        vestStep: _items,
      );
    } else if (option == '바지') {
      _costOptions = ConsultOptions(
        storeName: storeName,
        jacketStep: _items,
      );
    } else if (option == '셔츠') {
      _costOptions = ConsultOptions(
        storeName: storeName,
        pantsStep: _items,
      );
    } else {
      _costOptions = ConsultOptions(
        storeName: storeName,
        coatStep: _items,
      );
    }

    Future<void> updateUserData() async {
      if (option == '자켓') {
        return await consultsOptions.update(
          {
            'jacketStep': _items,
          },
        );
      } else if (option == '조끼') {
        return await consultsOptions.update(
          {
            'vestStep': _items,
          },
        );
      } else if (option == '바지') {
        return await consultsOptions.update(
          {
            'pantsStep': _items,
          },
        );
      } else if (option == '셔츠') {
        return await consultsOptions.update(
          {
            'shirtStep': _items,
          },
        );
      } else {
        return await consultsOptions.update(
          {
            'coatStep': _items,
          },
        );
      }
    }

    var userResult =
        await firestore.collection('consultsOptions').doc(storeName).get();
    String existCheck = "";
    try {
      setState(() {
        existCheck = userResult['storeName'];
      });
      updateUserData();
    } catch (e) {
      print(e);
      consultsOptions.set(_costOptions.toJson());
    }
  }
}
