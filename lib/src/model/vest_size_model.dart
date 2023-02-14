class VestSize {
  String? sangdong;
  String? angle;
  String? apgil;
  String? jungdong;
  String? vestHeight;

  VestSize({
    this.angle,
    this.apgil,
    this.jungdong,
    this.sangdong,
    this.vestHeight,
  });

  VestSize.fromJson(Map<String, dynamic> json)
      : sangdong = json['sangdong'],
        angle = json['angle'],
        apgil = json['apgil'],
        jungdong = json['jungdong'],
        vestHeight = json['vestHeight'];

  Map<String, dynamic> toJson() => {
        'sangdong': sangdong,
        'angle': angle,
        'apgil': apgil,
        'jungdong': jungdong,
        'vestHeight': vestHeight,
      };
}
