class CostShirt {
  final int? shirt1;
  final int? shirt2;
  final int? shirt3;
  final int? shirt4;
  final int? shirt5;
  final int? shirt6;
  final int? shirt7;
  final int? shirt8;
  final int? shirt9;
  final int? shirt10;
  final int? shirt11;
  final int? shirt12;
  final int? shirt13;
  final int? shirt14;

  CostShirt({
    this.shirt1,
    this.shirt2,
    this.shirt3,
    this.shirt4,
    this.shirt5,
    this.shirt6,
    this.shirt7,
    this.shirt8,
    this.shirt9,
    this.shirt10,
    this.shirt11,
    this.shirt12,
    this.shirt13,
    this.shirt14,
  });

  CostShirt.fromJson(Map<String, dynamic> json)
      : shirt1 = json['shirt1'],
        shirt2 = json['shirt2'],
        shirt3 = json['shirt3'],
        shirt4 = json['shirt4'],
        shirt5 = json['shirt5'],
        shirt6 = json['shirt6'],
        shirt7 = json['shirt7'],
        shirt8 = json['shirt8'],
        shirt9 = json['shirt9'],
        shirt10 = json['shirt10'],
        shirt11 = json['shirt11'],
        shirt12 = json['shirt12'],
        shirt13 = json['shirt13'],
        shirt14 = json['shirt14'];

  Map<String, dynamic> toJson() => {
        'shirt1': shirt1,
        'shirt2': shirt2,
        'shirt3': shirt3,
        'shirt4': shirt4,
        'shirt5': shirt5,
        'shirt6': shirt6,
        'shirt7': shirt7,
        'shirt8': shirt8,
        'shirt9': shirt9,
        'shirt10': shirt10,
        'shirt11': shirt11,
        'shirt12': shirt12,
        'shirt13': shirt13,
        'shirt14': shirt14,
      };
}
