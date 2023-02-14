class SuitDesign {
  final String? jacketButton;
  final String? jacketLapel;
  final String? jacketChestPocket;
  final String? jacketShoulder;
  final String? jacketSidePocket;
  final String? jacketVent;
  final String? vestButton;
  final String? vestLapel;
  final String? pantsPleats;
  final String? pantsDetailOne;
  final String? pantsDetailTwo;
  final String? pantsDetailThree;
  final String? pantsBreak;
  final String? pantsPermanentPleats;

  SuitDesign({
    this.jacketButton,
    this.jacketLapel,
    this.jacketShoulder,
    this.jacketChestPocket,
    this.jacketSidePocket,
    this.jacketVent,
    this.vestButton,
    this.vestLapel,
    this.pantsPleats,
    this.pantsBreak,
    this.pantsDetailOne,
    this.pantsDetailTwo,
    this.pantsDetailThree,
    this.pantsPermanentPleats,
  });

  SuitDesign.fromJson(Map<String, dynamic> json)
      : jacketButton = json['jacketButton'],
        jacketLapel = json['jacketLapel'],
        jacketShoulder = json['jacketShoulder'],
        jacketChestPocket = json['jacketChestPocket'],
        jacketSidePocket = json['jacketSidePocket'],
        jacketVent = json['jacketVent'],
        vestButton = json['vestButton'],
        vestLapel = json['vestLapel'],
        pantsPleats = json['pantsPleats'],
        pantsBreak = json['pantsBreak'],
        pantsDetailOne = json['pantsDetailOne'],
        pantsDetailTwo = json['pantsDetailTwo'],
        pantsDetailThree = json['pantsDetailThree'],
        pantsPermanentPleats = json['pantsPermanentPleats'];

  Map<String, dynamic> toJson() => {
        'jacketButton': jacketButton,
        'jacketLapel': jacketLapel,
        'jacketShoulder': jacketShoulder,
        'jacketChestPocket': jacketChestPocket,
        'jacketSidePocket': jacketSidePocket,
        'jacketVent': jacketVent,
        'vestButton': vestButton,
        'vestLapel': vestLapel,
        'pantsPleats': pantsPleats,
        'pantsBreak': pantsBreak,
        'pantsDetailOne': pantsDetailOne,
        'pantsDetailTwo': pantsDetailTwo,
        'pantsDetailThree': pantsDetailThree,
        'pantsPermanentPleats': pantsPermanentPleats,
      };
}
