import 'package:bykak/src/model/factory/cost_etc_model.dart';
import 'package:bykak/src/model/factory/cost_gabong_model.dart';
import 'package:bykak/src/model/factory/cost_gabong_sub_model.dart';

import 'package:bykak/src/model/factory/cost_jacket_model.dart';
import 'package:bykak/src/model/factory/cost_normal_model.dart';
import 'package:bykak/src/model/factory/cost_pants_model.dart';
import 'package:bykak/src/model/factory/cost_shirt_model.dart';
import 'package:bykak/src/model/factory/cost_vest_model.dart';

class Cost {
  //주문번호
  final String? costListNo;
  final String? storeName;
  final String? factoryName;
  final String? registDate;
  final String? udpateDate;
  final String? registUser;
  final String? updateUser;
  final String? selectBrandRate;
  final String? brandRate1;
  final String? brandRate2;
  final String? brandRate3;
  final String? brandRate4;
  final String? brandRate5;

  //수트 모델
  late CostEtc? costEtc;
  late CostGabongSub? costGabongSub;
  late CostGabong? costGabong;
  late CostJacket? costJacket;
  // //셔츠 모델
  late CostNormal? costNormal;
  late CostPants? costPants;
  late CostShirt? costShirt;
  late CostVest? costVest;

  Cost({
    this.costListNo,
    this.storeName,
    this.factoryName,
    this.registDate,
    this.udpateDate,
    this.registUser,
    this.updateUser,
    this.costEtc,
    this.costGabongSub,
    this.costGabong,
    this.costJacket,
    this.costNormal,
    this.costPants,
    this.costShirt,
    this.costVest,
    this.brandRate1,
    this.selectBrandRate,
    this.brandRate2,
    this.brandRate3,
    this.brandRate4,
    this.brandRate5,
  });

  Cost.fromJson(Map<String, dynamic> json)
      : costListNo = json['costListNo'],
        storeName = json['storeName'],
        factoryName = json['factoryName'],
        registDate = json['registDate'],
        udpateDate = json['udpateDate'],
        registUser = json['registUser'],
        updateUser = json['updateUser'],
        costEtc = json['costEtc'],
        costGabongSub = json['costGabongSub'],
        costGabong = json['costGabong'],
        costJacket = json['costJacket'],
        costNormal = json['costNormal'],
        costPants = json['costPants'],
        costShirt = json['costShirt'],
        costVest = json['costVest'],
        selectBrandRate = json['selectBrandRate'],
        brandRate1 = json['brandRate1'],
        brandRate2 = json['brandRate2'],
        brandRate3 = json['brandRate3'],
        brandRate4 = json['brandRate4'],
        brandRate5 = json['brandRate5'];

  Map<String, dynamic> toJson() => {
        'costListNo': costListNo,
        'storeName': storeName,
        'factoryName': factoryName,
        'registDate': registDate,
        'udpateDate': udpateDate,
        'registUser': registUser,
        'updateUser': updateUser,
        'brandRate1': brandRate1,
        'selectBrandRate': selectBrandRate,
        'brandRate2': brandRate2,
        'brandRate3': brandRate3,
        'brandRate4': brandRate4,
        'brandRate5': brandRate5,
        'costEtc': costEtc!.toJson(),
        'costGabongSub': costGabongSub!.toJson(),
        'costGabong': costGabong!.toJson(),
        'costJacket': costJacket!.toJson(),
        'costNormal': costNormal!.toJson(),
        'costPants': costPants!.toJson(),
        'costShirt': costShirt!.toJson(),
        'costVest': costVest!.toJson(),
      };
}
