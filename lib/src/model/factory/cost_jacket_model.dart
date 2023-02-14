class CostJacket {
  final int? jacket1;
  final int? jacket2;
  final int? jacket3;
  final int? jacket4;
  final int? jacket5;
  final int? jacket6;
  final int? jacket7;
  final int? jacket8;
  final int? jacket9;
  final int? jacket10;
  final int? jacket11;
  final int? jacket12;
  final int? jacket13;

  CostJacket({
    this.jacket1,
    this.jacket2,
    this.jacket3,
    this.jacket4,
    this.jacket5,
    this.jacket6,
    this.jacket7,
    this.jacket8,
    this.jacket9,
    this.jacket10,
    this.jacket11,
    this.jacket12,
    this.jacket13,
  });

  CostJacket.fromJson(Map<String, dynamic> json)
      : jacket1 = json['jacket1'],
        jacket2 = json['jacket2'],
        jacket3 = json['jacket3'],
        jacket4 = json['jacket4'],
        jacket5 = json['jacket5'],
        jacket6 = json['jacket6'],
        jacket7 = json['jacket7'],
        jacket8 = json['jacket8'],
        jacket9 = json['jacket9'],
        jacket10 = json['jacket10'],
        jacket11 = json['jacket11'],
        jacket12 = json['jacket12'],
        jacket13 = json['jacket13'];

  Map<String, dynamic> toJson() => {
        'jacket1': jacket1,
        'jacket2': jacket2,
        'jacket3': jacket3,
        'jacket4': jacket4,
        'jacket5': jacket5,
        'jacket6': jacket6,
        'jacket7': jacket7,
        'jacket8': jacket8,
        'jacket9': jacket9,
        'jacket10': jacket10,
        'jacket11': jacket11,
        'jacket12': jacket12,
        'jacket13': jacket13,
      };
}
