class TopSize {
  String? shoulder;
  String? shoulderFront;
  String? shoulderBack;
  String? jindong;
  String? sleeve;
  String? sangdong;
  String? armhole;
  String? angle;
  String? apgil;
  String? jungdong;
  String? hadong;
  String? topHeight;
  String? frontForm;
  String? backForm;
  String? totalHeight;

  TopSize({
    this.shoulder,
    this.shoulderFront,
    this.shoulderBack,
    this.jindong,
    this.sleeve,
    this.sangdong,
    this.armhole,
    this.angle,
    this.apgil,
    this.jungdong,
    this.hadong,
    this.topHeight,
    this.frontForm,
    this.backForm,
    this.totalHeight,
  });

  TopSize.fromJson(Map<String, dynamic> json)
      : shoulder = json['shoulder'],
        shoulderFront = json['shoulderFront'],
        shoulderBack = json['shoulderBack'],
        jindong = json['jindong'],
        sleeve = json['sleeve'],
        sangdong = json['sangdong'],
        armhole = json['armhole'],
        angle = json['angle'],
        apgil = json['apgil'],
        jungdong = json['jungdong'],
        hadong = json['hadong'],
        topHeight = json['topHeight'],
        frontForm = json['frontForm'],
        backForm = json['backForm'],
        totalHeight = json['totalHeight'];

  Map<String, dynamic> toJson() => {
        'shoulder': shoulder,
        'shoulderFront': shoulderFront,
        'shoulderBack': shoulderBack,
        'jindong': jindong,
        'sleeve': sleeve,
        'sangdong': sangdong,
        'armhole': armhole,
        'angle': angle,
        'apgil': apgil,
        'jungdong': jungdong,
        'hadong': hadong,
        'topHeight': topHeight,
        'frontForm': frontForm,
        'backForm': backForm,
        'totalHeight': totalHeight,
      };
}
