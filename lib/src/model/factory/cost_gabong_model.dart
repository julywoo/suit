class CostGabong {
  final int? gabong1;
  final int? gabong2;
  final int? gabong3;
  final int? gabong4;
  final int? gabong5;
  final int? gabong6;

  CostGabong({
    this.gabong1,
    this.gabong2,
    this.gabong3,
    this.gabong4,
    this.gabong5,
    this.gabong6,
  });

  CostGabong.fromJson(Map<String, dynamic> json)
      : gabong1 = json['gabong1'],
        gabong2 = json['gabong2'],
        gabong3 = json['gabong3'],
        gabong4 = json['gabong4'],
        gabong5 = json['gabong5'],
        gabong6 = json['gabong6'];

  Map<String, dynamic> toJson() => {
        'gabong1': gabong1,
        'gabong2': gabong2,
        'gabong3': gabong3,
        'gabong4': gabong4,
        'gabong5': gabong5,
        'gabong6': gabong6,
      };
}
