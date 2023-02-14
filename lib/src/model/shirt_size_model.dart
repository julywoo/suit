class ShirtSize {
  final String? neck;
  final String? shoulder;
  final String? sleeve;
  final String? sangdong;
  final String? jungdong;
  final String? hip;
  final String? topHeight;
  final String? armhole;
  final String? armSize; // 팔통
  final String? wrist;

  ShirtSize({
    this.neck,
    this.shoulder,
    this.sleeve,
    this.sangdong,
    this.jungdong,
    this.hip,
    this.topHeight,
    this.armhole,
    this.armSize,
    this.wrist,
  });

  ShirtSize.fromJson(Map<String, dynamic> json)
      : neck = json['neck'],
        shoulder = json['shoulder'],
        sleeve = json['sleeve'],
        sangdong = json['sangdong'],
        jungdong = json['jungdong'],
        hip = json['hip'],
        topHeight = json['topHeight'],
        armhole = json['armhole'],
        armSize = json['armSize'],
        wrist = json['wrist'];

  Map<String, dynamic> toJson() => {
        'neck': neck,
        'shoulder': shoulder,
        'sleeve': sleeve,
        'sangdong': sangdong,
        'jungdong': jungdong,
        'hip': hip,
        'topHeight': topHeight,
        'armhole': armhole,
        'armSize': armSize,
        'wrist': wrist,
      };
}
