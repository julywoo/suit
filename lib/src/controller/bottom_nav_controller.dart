import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:bykak/src/components/message_popup.dart';
import 'package:bykak/src/pages/search_page.dart';

enum PageName { FAVORITE, SEARCH, HISTORY, MYPAGE, HOME }

class BottomNavController extends GetxController {
  RxInt pageIndex = 4.obs;
  List<int> bottomHistory = [4];

  void changeBottonNav(int value, {bool hasGesture = true}) {
    var page = PageName.values[value];
    switch (page) {
      case PageName.FAVORITE:
      case PageName.SEARCH:

      case PageName.HISTORY:
      case PageName.MYPAGE:
      case PageName.HOME:
        _changePage(value, hasGesture: hasGesture);
        break;
      default:
    }
  }

  void ChangeInitPage() {
    pageIndex = 4.obs;
    bottomHistory = [4];
  }

  void _changePage(int value, {bool hasGesture = true}) {
    pageIndex(value);
    if (!hasGesture) return;
    //history가 계속 누적되지않고 페이지 수만큼만 저장하도록
    if (bottomHistory.contains(value)) {
      bottomHistory.remove(value);
    }
    bottomHistory.add(value);

    // history가 계속 누적되도록 설정
    // if (bottomHistory.last != value) {
    //   bottomHistory.add(value);
    // }
  }

  Future<bool> willPopAction() async {
    if (bottomHistory.length == 1) {
      showDialog(
          context: Get.context!,
          builder: (context) => MessagePopup(
                title: '시스템',
                message: '종료',
                okCallback: () {
                  exit(0);
                },
                cancleCallback: Get.back,
              ));
      return true;
    } else {
      bottomHistory.removeLast();
      var index = bottomHistory.last;
      changeBottonNav(index, hasGesture: false);
      return false;
    }
  }
}
