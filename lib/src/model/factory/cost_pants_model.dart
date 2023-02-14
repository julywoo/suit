class CostPants {
  final int? pants1;
  final int? pants2;
  final int? pants3;
  final int? pants4;
  final int? pants5;
  final int? pants6;

  CostPants({
    this.pants1,
    this.pants2,
    this.pants3,
    this.pants4,
    this.pants5,
    this.pants6,
  });

  CostPants.fromJson(Map<String, dynamic> json)
      : pants1 = json['pants1'],
        pants2 = json['pants2'],
        pants3 = json['pants3'],
        pants4 = json['pants4'],
        pants5 = json['pants5'],
        pants6 = json['pants6'];

  Map<String, dynamic> toJson() => {
        'pants1': pants1,
        'pants2': pants2,
        'pants3': pants3,
        'pants4': pants4,
        'pants5': pants5,
        'pants6': pants6,
      };
}
