import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/shirt_size_model.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/model/vest_size_model.dart';

class Customer {
  final String? name;
  final String? phone;
  final String? gender;
  final String? birthDate;
  final String? firstVisitDate;
  final String? lastVisitDate;
  final String? grade;
  final int? point;
  final int? usedPoint;
  final int? accruedPoint;
  final int? purchaseAmount;
  final int? purchaseCount;
  final int? activityPoint;
  final int? activityUsedPoint;
  final int? activityAccruedPoint;
  final String? etc;
  final String? storeName;

  final String? height;
  final String? weight;
  final String? shoulderShape;
  final String? legShape;
  final String? posture;
  final String? eventAgree;
  final List? pointHistory;

  late TopSize? topSize;
  late BottomSize? bottomSize;
  late VestSize? vestSize;
  late ShirtSize? shirtSize;

  Customer({
    this.name,
    this.phone,
    this.gender,
    this.birthDate,
    this.firstVisitDate,
    this.lastVisitDate,
    this.storeName,
    this.grade,
    this.point,
    this.usedPoint,
    this.accruedPoint,
    this.purchaseAmount,
    this.activityPoint,
    this.activityUsedPoint,
    this.activityAccruedPoint,
    this.purchaseCount,
    this.etc,
    this.height,
    this.weight,
    this.shoulderShape,
    this.legShape,
    this.posture,
    this.eventAgree,
    this.pointHistory,
    //수트
    this.topSize,
    this.bottomSize,
    this.vestSize,
    //셔츠
    this.shirtSize,
  });

  Customer.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phone = json['phone'],
        gender = json['gender'],
        birthDate = json['birthDate'],
        firstVisitDate = json['firstVisitDate'],
        lastVisitDate = json['lastVisitDate'],
        storeName = json['storeName'],
        grade = json['grade'],
        point = json['point'],
        usedPoint = json['usedPoint'],
        accruedPoint = json['accruedPoint'],
        activityPoint = json['activityPoint'],
        activityUsedPoint = json['activityUsedPoint'],
        activityAccruedPoint = json['activityAccruedPoint'],
        purchaseAmount = json['purchaseAmount'],
        purchaseCount = json['pabric'],
        etc = json['etc'],
        height = json['height'],
        weight = json['weight'],
        shoulderShape = json['shoulderShape'],
        legShape = json['legShape'],
        posture = json['posture'],
        eventAgree = json['eventAgree'],
        pointHistory = json['pointHistory'],
        topSize = json['topSize'],
        bottomSize = json['bottomSize'],
        vestSize = json['vestSize'],
        shirtSize = json['shirtSize'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'gender': gender,
        'birthDate': birthDate,
        'firstVisitDate': firstVisitDate,
        'lastVisitDate': lastVisitDate,
        'storeName': storeName,
        'grade': grade,
        'point': point,
        'usedPoint': usedPoint,
        'accruedPoint': accruedPoint,
        'activityPoint': activityPoint,
        'activityUsedPoint': activityUsedPoint,
        'activityAccruedPoint': activityAccruedPoint,
        'purchaseAmount': purchaseAmount,
        'purchaseCount': purchaseCount,
        'etc': etc,
        'height': height,
        'weight': weight,
        'shoulderShape': shoulderShape,
        'legShape': legShape,
        'posture': posture,
        'eventAgree': eventAgree,
        'pointHistory': pointHistory,
        'topSize': topSize!.toJson(),
        'bottomSize': bottomSize!.toJson(),
        'vestSize': vestSize!.toJson(),
        'shirtSize': shirtSize!.toJson(),
      };
}
