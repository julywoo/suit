class Payment {
  final String? tailorShop;
  final String? name; // 고객명
  final String? consultDate; //구매 날짜
  final String? manager;
  final String? phone;

  final int? discount;
  final int? discountSub;
  final int? usePoint;
  final String? usePointResult;
  final int? totalPrice;
  final int? totalPrepayment;
  final String? givePointResult;
  final int? givePoint;

  final List? orderList;
  final List? orderTypeList;

  final List? orderPabricList;
  final List? priceList;

  //final List? prepaymentTotalList;
  //final List? paymentList;
  final List? paymentHistory;
  final List? paymentChangeHistory;

  Payment({
    this.tailorShop,
    this.name,
    this.consultDate,
    this.manager,
    this.phone,
    this.usePoint,
    this.usePointResult,
    this.totalPrice,
    this.totalPrepayment,
    this.orderList,
    this.orderTypeList,
    this.orderPabricList,
    this.priceList,
    this.discount,
    this.discountSub,
    this.paymentHistory,
    this.givePointResult,
    this.givePoint,
    this.paymentChangeHistory,
  });

  Payment.fromJson(Map<String, dynamic> json)
      : tailorShop = json['tailorShop'],
        name = json['name'],
        consultDate = json['consultDate'],
        manager = json['manager'],
        phone = json['phone'],
        usePoint = json['usePoint'],
        usePointResult = json['usePointResult'],
        totalPrice = json['totalPrice'],
        totalPrepayment = json['totalPrepayment'],
        orderList = json['orderList'],
        orderTypeList = json['orderTypeList'],
        orderPabricList = json['orderPabricList'],
        priceList = json['priceList'],
        discount = json['discount'],
        discountSub = json['discountSub'],
        paymentHistory = json['paymentHistory'],
        givePointResult = json['givePointResult'],
        givePoint = json['givePoint'],
        paymentChangeHistory = json['paymentChangeHistory'];

  Map<String, dynamic> toJson() => {
        'tailorShop': tailorShop,
        'name': name,
        'consultDate': consultDate,
        'phone': phone,
        'manager': manager,
        'usePoint': usePoint,
        'usePointResult': usePointResult,
        'totalPrice': totalPrice,
        'totalPrepayment': totalPrepayment,
        'orderList': orderList,
        'orderTypeList': orderTypeList,
        'orderPabricList': orderPabricList,
        'priceList': priceList,
        'discount': discount,
        'discountSub': discountSub,
        'paymentHistory': paymentHistory,
        'givePointResult': givePointResult,
        'givePoint': givePoint,
        'paymentChangeHistory': paymentChangeHistory,
      };
}
