class CostGabongSub {
  final int? gabongSub1;
  final int? gabongSub2;
  final int? gabongSub3;
  final int? gabongSub4;
  final int? gabongSub5;
  final int? gabongSub6;

  CostGabongSub({
    this.gabongSub1,
    this.gabongSub2,
    this.gabongSub3,
    this.gabongSub4,
    this.gabongSub5,
    this.gabongSub6,
  });

  CostGabongSub.fromJson(Map<String, dynamic> json)
      : gabongSub1 = json['gabongSub1'],
        gabongSub2 = json['gabongSub2'],
        gabongSub3 = json['gabongSub3'],
        gabongSub4 = json['gabongSub4'],
        gabongSub5 = json['gabongSub5'],
        gabongSub6 = json['gabongSub6'];

  Map<String, dynamic> toJson() => {
        'gabongSub1': gabongSub1,
        'gabongSub2': gabongSub2,
        'gabongSub3': gabongSub3,
        'gabongSub4': gabongSub4,
        'gabongSub5': gabongSub5,
        'gabongSub6': gabongSub6,
      };
}
