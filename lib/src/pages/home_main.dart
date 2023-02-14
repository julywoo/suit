import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/pages/factory/charge_list_page.dart';
import 'package:bykak/src/pages/home.dart';
import 'package:bykak/src/pages/input_suit_data.dart';
import 'package:bykak/src/pages/progress_calendar.dart';
import 'package:bykak/src/pages/progress_page.dart';
import 'package:bykak/src/pages/qr_scanner_page.dart';
import 'package:bykak/src/pages/search_page.dart';
import 'package:bykak/src/pages/user_manage_page.dart';
import 'package:bykak/src/pages/user_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

class HomeMain extends StatelessWidget {
  const HomeMain({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return Home();

          case 2:
            try {
              return SearchPage();
            } catch (e) {
              print(e);
              return Text('일시적인 오류입니다.');
            }
          case 3:
            try {
              return ProgressPage();
            } catch (e) {
              print(e);
              return Text('일시적인 오류입니다.');
            }
          case 4:
            return ChargeListPage();
          case 5:
            return QrScannerPage();
          case 6:
            return UserManagePage();
          case 7:
            return UserPage();

          default:
            return Text('일시적인 오류입니다.');
        }
      },
    );
  }
}
