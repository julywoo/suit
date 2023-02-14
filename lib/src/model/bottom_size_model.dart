class BottomSize {
  final String? waist;
  final String? hips;
  final String? crotch;
  final String? outHeight;
  // final String? vestHeight;
  final String? thigh;
  final String? circumference;
  final String? pantsBottom;

  BottomSize({
    this.waist,
    this.hips,
    this.crotch,
    this.outHeight,
    // this.vestHeight,
    this.thigh,
    this.circumference,
    this.pantsBottom,
  });

  BottomSize.fromJson(Map<String, dynamic> json)
      : waist = json['waist'],
        hips = json['hips'],
        crotch = json['crotch'],
        outHeight = json['outHeight'],
        // vestHeight = json['vestHeight'],
        thigh = json['thigh'],
        circumference = json['circumference'],
        pantsBottom = json['pantsBottom'];

  Map<String, dynamic> toJson() => {
        'waist': waist,
        'hips': hips,
        'crotch': crotch,
        'outHeight': outHeight,
        // 'vestHeight': vestHeight,
        'thigh': thigh,
        'circumference': circumference,
        'pantsBottom': pantsBottom,
      };
}
