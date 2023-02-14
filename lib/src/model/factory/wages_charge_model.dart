import 'package:flutter/foundation.dart';

class wagesCharge {
  final String? factory; //공장
  final String? tailorShop; //테일러샵
  final String? chargeNo; //청구 시작일자
  final String? chargeStartDate; //청구 시작일자
  final String? chargeEndDate; // 청구 종료일자
  final String? chargeCost; //청구 총액
  final String? chargeGabongCost; //가봉 총액
  final String? chargeBongjeCost; //봉제 총액
  final String? chargeComplete; // 청구  완료 여부
  final List? orderNoList; // 청구  완료 여부
  final List? orderNoChargeType; // 청구  완료 여부

  wagesCharge({
    this.factory,
    this.tailorShop,
    this.chargeNo,
    this.chargeStartDate,
    this.chargeEndDate,
    this.chargeCost,
    this.chargeGabongCost,
    this.chargeBongjeCost,
    this.chargeComplete,
    this.orderNoList,
    this.orderNoChargeType,
  });

  wagesCharge.fromJson(Map<String, dynamic> json)
      : factory = json['factory'],
        tailorShop = json['tailorShop'],
        chargeNo = json['chargeNo'],
        chargeStartDate = json['chargeStartDate'],
        chargeEndDate = json['chargeEndDate'],
        chargeCost = json['chargeCost'],
        chargeGabongCost = json['chargeGabongCost'],
        chargeBongjeCost = json['chargeBongjeCost'],
        chargeComplete = json['chargeComplete'],
        orderNoList = json['orderNoList'],
        orderNoChargeType = json['orderNoChargeType'];

  Map<String, dynamic> toJson() => {
        'factory': factory,
        'tailorShop': tailorShop,
        'chargeNo': chargeNo,
        'chargeStartDate': chargeStartDate,
        'chargeEndDate': chargeEndDate,
        'chargeCost': chargeCost,
        'chargeGabongCost': chargeGabongCost,
        'chargeBongjeCost': chargeBongjeCost,
        'chargeComplete': chargeComplete,
        'orderNoList': orderNoList,
        'orderNoChargeType': orderNoChargeType,
      };
}
