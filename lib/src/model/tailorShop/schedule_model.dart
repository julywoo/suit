class Schedule {
  final String? orderNo; //주문번호
  final String? tailorShop; //테일러샵
  final String? customerName; //테일러샵
  final String? productUse; //제품 사용 목적
  final String? orderType; //제품 종ㄹ류
  final String? expectDate; //방문 예상일자
  final String? fixDate; //방문 확정일자
  final String? updateUser; // 청구  완료 여부
  final String? visitType; // 청구  완료 여부
  final String? visitTime; // 청구  완료 여부
  final String? fixYn; // 청구  완료 여부
  final List? scheduleHistory; // 청구  완료 여부
  final List? scheduleHistoryDate; // 청구  완료 여부

  Schedule(
    this.orderNo,
    this.tailorShop,
    this.customerName,
    this.productUse,
    this.orderType,
    this.expectDate,
    this.fixDate,
    this.updateUser,
    this.visitType,
    this.visitTime,
    this.fixYn,
    this.scheduleHistory,
    this.scheduleHistoryDate,
  );

  Schedule.fromJson(Map<String, dynamic> json)
      : orderNo = json['orderNo'],
        tailorShop = json['tailorShop'],
        customerName = json['customerName'],
        productUse = json['productUse'],
        orderType = json['orderType'],
        expectDate = json['expectDate'],
        fixDate = json['fixDate'],
        updateUser = json['updateUser'],
        visitType = json['visitType'],
        visitTime = json['visitTime'],
        fixYn = json['fixYn'],
        scheduleHistory = json['scheduleHistory'],
        scheduleHistoryDate = json['scheduleHistoryDate'];

  Map<String, dynamic> toJson() => {
        'orderNo': orderNo,
        'tailorShop': tailorShop,
        'customerName': customerName,
        'productUse': productUse,
        'orderType': orderType,
        'expectDate': expectDate,
        'fixDate': fixDate,
        'updateUser': updateUser,
        'visitType': visitType,
        'visitTime': visitTime,
        'fixYn': fixYn,
        'scheduleHistory': scheduleHistory,
        'scheduleHistoryDate': scheduleHistoryDate,
      };
}
