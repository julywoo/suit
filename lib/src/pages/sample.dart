import 'dart:io';

import 'package:bykak/src/app.dart';
import 'package:bykak/src/components/hex_color.dart';
import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/order_model.dart';
import 'package:bykak/src/model/shirt_design.dart';
import 'package:bykak/src/model/shirt_design_val.dart';
import 'package:bykak/src/model/shirt_size_model.dart';
import 'package:bykak/src/model/suit_design_model.dart';
import 'package:bykak/src/model/suit_design_val.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/pages/search_page.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import '../model/suit_option.dart';

class Sample extends StatefulWidget {
  const Sample({Key? key}) : super(key: key);

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  @override
  void initState() {
    checkPlatform();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  void dispose() {
    // 세로 화면 고정

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  bool kisweb = true;
  void checkPlatform() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        kisweb = false;
      } else {
        kisweb = true;
      }
    } catch (e) {
      kisweb = true;
    }
  }

  final checkOption = List<String>.filled(14, "");
  final checkOptionVal = List<String>.filled(14, "");
  String? jacketButton;
  String? jacketLapel;
  String? chestPocket;
  String? jacketShoulder;
  String? jacketSidePocket;
  String? jacketVent;
  String? vestButton;
  String? vestLapel;
  String? pantsPleats;
  String? pantsDetailOne;
  String? pantsDetailTwo;
  String? pantsDetailThree;
  String? pantsBreak;
  String? pantsPermanentPleats;

  SuitDesign? suitDesign;
  SuitDesignVal? suitDesignVal;
  SwiperController _controller = SwiperController();

  final double runSpacing = 4;
  final double spacing = 4;

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
    final ScrollController _horizontal = ScrollController(),
        _vertical = ScrollController();
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Scrollbar(
          controller: _vertical,
          thumbVisibility: true,
          trackVisibility: false,
          child: Scrollbar(
            controller: _horizontal,
            thumbVisibility: true,
            trackVisibility: false,
            notificationPredicate: (notif) => notif.depth == 1,
            child: SingleChildScrollView(
              controller: _vertical,
              child: SingleChildScrollView(
                controller: _horizontal,
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
