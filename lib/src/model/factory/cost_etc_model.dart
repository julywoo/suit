class CostEtc {
  final int? etc1;
  final int? etc2;
  final int? etc3;
  final int? etc4;
  final int? etc5;
  final int? etc6;
  final int? etc7;
  final int? etc8;
  final int? etc9;
  final int? etc10;

  CostEtc({
    this.etc1,
    this.etc2,
    this.etc3,
    this.etc4,
    this.etc5,
    this.etc6,
    this.etc7,
    this.etc8,
    this.etc9,
    this.etc10,
  });

  CostEtc.fromJson(Map<String, dynamic> json)
      : etc1 = json['etc1'],
        etc2 = json['etc2'],
        etc3 = json['etc3'],
        etc4 = json['etc4'],
        etc5 = json['etc5'],
        etc6 = json['etc6'],
        etc7 = json['etc7'],
        etc8 = json['etc8'],
        etc9 = json['etc9'],
        etc10 = json['etc9'];

  Map<String, dynamic> toJson() => {
        'etc1': etc1,
        'etc2': etc2,
        'etc3': etc3,
        'etc4': etc4,
        'etc5': etc5,
        'etc6': etc6,
        'etc7': etc7,
        'etc8': etc8,
        'etc9': etc9,
        'etc10': etc10,
      };
}
