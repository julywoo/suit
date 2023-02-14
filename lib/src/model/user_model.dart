import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final String? userName;
  final String? userPhone;
  final String? userId;
  final String? userAuthority;
  final String? storeName;
  final String? userType;
  final String? factoryName;
  final String?
      userGrade; // 1. 관리자 and 테일러 or 관리자 and 제품 제작자, 2. 테일러 , 3. 제품 제작자
  final String? userTailorPart; //  1. 상담
  final String? userFactoryPart; //  1. 자켓, 2. 바지, 3. 조끼, 4. 셔츠, 5. 코트
  final String? registDate; //  1. 자켓, 2. 바지, 3. 조끼, 4. 셔츠, 5. 코트

  UserData({
    this.userName,
    this.userPhone,
    this.userId,
    this.userAuthority,
    this.storeName,
    this.userType,
    this.factoryName,
    this.userGrade,
    this.userTailorPart,
    this.userFactoryPart,
    this.registDate,
  });

  UserData.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        userAuthority = json['userAuthority'],
        userPhone = json['userPhone'],
        storeName = json['storeName'],
        userType = json['userType'],
        factoryName = json['factoryName'],
        userGrade = json['userGrade'],
        userTailorPart = json['userTailorPart'],
        userFactoryPart = json['userFactoryPart'],
        registDate = json['registDate'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'userPhone': userPhone,
        'userAuthority': userAuthority,
        'userId': userId,
        'userType': userType,
        'storeName': storeName,
        'factoryName': factoryName,
        'userGrade': userGrade,
        'userTailorPart': userTailorPart,
        'userFactoryPart': userFactoryPart,
        'registDate': registDate,
      };
}
