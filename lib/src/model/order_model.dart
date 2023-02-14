import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/shirt_design.dart';
import 'package:bykak/src/model/shirt_design_val.dart';
import 'package:bykak/src/model/shirt_size_model.dart';
import 'package:bykak/src/model/suit_design_model.dart';
import 'package:bykak/src/model/suit_design_val.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/model/vest_size_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  //주문번호
  final String? orderNo;

  final String? consult;
  final String? consult1;
  final String? consultDate;
  final String? storeName;
  //기본정보
  final String? name;
  final String? gender;
  final String? phone;
  final String? age;
  final String? visitRoute;

  //주문 정보
  //수트 or 셔츠 값
  final String? orderType;
  final String? pabric;
  final String? pabricSub1;
  final String? pabricSub2;
  final String? buttons;
  final String? lining; //제품 안감

  final String? height;
  final String? weight;
  final String? bodyType;
  final String? finishDate;
  final String? productUse; // 사용 용도

  final String? gabong; //가봉일자
  final String? midgabong; //중가봉일자
  final String? initial;
  final String? price;
  final String? prepayment;
  final int? productionProcess;
  final String? customImgFront;
  final String? customImgSide;
  final String? customImgBack;

  final String? gabongFactory; //가봉작업공장
  final String? gabongManager; //재단 및 가봉 담당자
  final String? factory; //제작공장
  final String? factoryManager; //봉제 담당자

  final String? normalPrice; // 기본공임
  final String? gabongPrice; // 가봉공임
  final String? factoryPrice; // 제품별공임
  final String? factoryPriceDetail; // 제품별공임 상세
  final String? pabricPrice;
  final String? pabricUsage;
  final String? pabricUsage1;
  final String? pabricUsage2;
  final String? etcPrice;
  final String? makerName;
  final String? brandRate;
  final String? produceAccept;
  final String? chargeNo;

  //가봉 및 완성 날짜 확정 여부
  final String? gabongTime; //가봉 피팅 시간
  final String? finishTime; //완성본 피팅 시간

  //가봉완성일자
  final String? gabongFinishDate;
  //가봉 정산 완료 여부
  final String? gabongChargeComplete;
  //봉제완성일자
  final String? bongjeFinishDate;
  //봉제 정산 완료 여부
  final String? bongjeChargeComplete;

  //수트 모델
  late SuitDesign? suitDesign;
  late SuitDesignVal? suitDesignVal;
  late TopSize? topSize;
  late BottomSize? bottomSize;
  late VestSize? vestSize;
  // //셔츠 모델
  late ShirtDesign? shirtDesign;
  late ShirtDesignVal? shirtDesignVal;
  late ShirtSize? shirtSize;

  Map? jacketOption;
  Map? vestOption;
  Map? pantsOption;
  Map? shirtOption;
  Map? coatOption;

  Order({
    this.orderNo,
    this.name,
    this.gender,
    this.phone,
    this.pabric,
    this.age,
    this.consult,
    this.consult1,
    this.consultDate,
    this.orderType,
    this.storeName,
    this.height,
    this.weight,
    this.bodyType,
    this.finishDate,
    this.productUse,
    this.visitRoute,
    this.gabong,
    this.midgabong,
    this.initial,
    this.price,
    this.prepayment,
    this.productionProcess,
    this.pabricSub1,
    this.pabricSub2,
    this.buttons,
    this.lining,
    this.customImgFront,
    this.customImgSide,
    this.customImgBack,
    this.gabongFactory,
    this.gabongManager,
    this.factory,
    this.factoryManager,
    this.factoryPrice,
    this.factoryPriceDetail,
    this.normalPrice,
    this.gabongPrice,
    this.pabricPrice,
    this.pabricUsage,
    this.pabricUsage1,
    this.pabricUsage2,
    this.etcPrice,
    this.makerName,
    this.brandRate,
    this.produceAccept,
    this.gabongChargeComplete,
    this.bongjeChargeComplete,
    this.chargeNo,
    this.gabongFinishDate,
    this.bongjeFinishDate,
    this.gabongTime,
    this.finishTime,

    //수트
    this.suitDesign,
    this.suitDesignVal,
    this.topSize,
    this.bottomSize,
    this.vestSize,
    //셔츠
    this.shirtDesign,
    this.shirtDesignVal,
    this.shirtSize,
    this.jacketOption,
    this.pantsOption,
    this.vestOption,
    this.shirtOption,
    this.coatOption,
  });

  Order.fromJson(Map<String, dynamic> json)
      : orderNo = json['orderNo'],
        name = json['name'],
        gender = json['gender'],
        phone = json['phone'],
        pabric = json['pabric'],
        orderType = json['orderType'],
        height = json['height'],
        weight = json['weight'],
        bodyType = json['bodyType'],
        finishDate = json['finishDate'],
        productUse = json['productUse'],
        visitRoute = json['visitRoute'],
        gabong = json['gabong'],
        midgabong = json['midgabong'],
        age = json['age'],
        suitDesign = json['suitDesign'],
        suitDesignVal = json['suitDesignVal'],
        topSize = json['topSize'],
        bottomSize = json['bottomSize'],
        vestSize = json['vestSize'],
        shirtDesign = json['shirtDesign'],
        shirtDesignVal = json['shirtDesignVal'],
        shirtSize = json['shirtSize'],
        storeName = json['storeName'],
        consultDate = json['consultDate'],
        consult = json['consult'],
        consult1 = json['consult1'],
        initial = json['initial'],
        price = json['price'],
        prepayment = json['prepayment'],
        pabricSub1 = json['pabricSub1'],
        pabricSub2 = json['pabricSub2'],
        buttons = json['buttons'],
        lining = json['lining'],
        factory = json['factory'],
        factoryManager = json['factoryManager'],
        gabongFactory = json['gabongFactory'],
        gabongManager = json['gabongManager'],
        factoryPrice = json['factoryPrice'],
        factoryPriceDetail = json['factoryPriceDetail'],
        gabongPrice = json['gabongPrice'],
        normalPrice = json['normalPrice'],
        pabricPrice = json['pabricPrice'],
        pabricUsage = json['pabricUsage'],
        pabricUsage1 = json['pabricUsage1'],
        pabricUsage2 = json['pabricUsage2'],
        etcPrice = json['etcPrice'],
        makerName = json['makerName'],
        chargeNo = json['chargeNo'],
        gabongFinishDate = json['gabongFinishDate'],
        bongjeFinishDate = json['bongjeFinishDate'],
        gabongTime = json['gabongTime'],
        finishTime = json['finishTime'],
        bongjeChargeComplete = json['bongjeChargeComplete'],
        gabongChargeComplete = json['gabongChargeComplete'],
        brandRate = json['brandRate'] ?? "",
        produceAccept = json['produceAccept'] ?? "",
        customImgFront = json['customImgFront'],
        customImgSide = json['customImgSide'],
        customImgBack = json['customImgBack'],
        productionProcess = json['productionProcess'],
        jacketOption = json['jacketOption'],
        vestOption = json['vestOption'],
        pantsOption = json['pantsOption'],
        shirtOption = json['shirtOption'],
        coatOption = json['coatOption'];

  Map<String, dynamic> toJson() => {
        'orderNo': orderNo,
        'name': name,
        'gender': gender,
        'phone': phone,
        'pabric': pabric,
        'age': age,
        'orderType': orderType,
        'height': height,
        'weight': weight,
        'bodyType': bodyType,
        'finishDate': finishDate,
        'productUse': productUse,
        'visitRoute': visitRoute,
        'gabong': gabong,
        'midgabong': midgabong,
        'consult': consult,
        'consult1': consult1,
        'consultDate': consultDate,
        'initial': initial,
        'price': price,
        'prepayment': prepayment,
        'productionProcess': productionProcess,
        'pabricSub1': pabricSub1,
        'pabricSub2': pabricSub2,
        'buttons': buttons,
        'lining': lining,
        'factory': factory,
        'gabongFactory': gabongFactory,
        'factoryManager': factoryManager,
        'factoryPrice': factoryPrice,
        'factoryPriceDetail': factoryPriceDetail,
        'pabricPrice': pabricPrice,
        'normalPrice': normalPrice,
        'gabongPrice': gabongPrice,
        'pabricUsage': pabricUsage,
        'pabricUsage1': pabricUsage1,
        'pabricUsage2': pabricUsage2,
        'etcPrice': etcPrice,
        'makerName': makerName,
        'brandRate': brandRate,
        'customImgFront': customImgFront,
        'customImgSide': customImgSide,
        'customImgBack': customImgBack,
        'storeName': storeName,
        'produceAccept': produceAccept,
        'chargeNo': chargeNo,
        'bongjeChargeComplete': bongjeChargeComplete,
        'gabongChargeComplete': gabongChargeComplete,
        'gabongTime': gabongTime,
        'finishTime': finishTime,
        'gabongFinishDate': gabongFinishDate,
        'bongjeFinishDate': bongjeFinishDate,
        'suitDesign': suitDesign!.toJson(),
        'suitDesignVal': suitDesignVal!.toJson(),
        'topSize': topSize!.toJson(),
        'bottomSize': bottomSize!.toJson(),
        'vestSize': vestSize!.toJson(),
        'shirtDesign': shirtDesign!.toJson(),
        'shirtDesignVal': shirtDesignVal!.toJson(),
        'shirtSize': shirtSize!.toJson(),
        'jacketOption': jacketOption,
        'vestOption': vestOption,
        'pantsOption': pantsOption,
        'coatOption': coatOption,
        'shirtOption': shirtOption,
      };
}
