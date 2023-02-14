class CostNormal {
  final int? normal1;
  final int? normal2;
  final int? normal3;
  final int? normal4;
  final int? normal5;
  final int? normal6;

  CostNormal({
    this.normal1,
    this.normal2,
    this.normal3,
    this.normal4,
    this.normal5,
    this.normal6,
  });

  CostNormal.fromJson(Map<String, dynamic> json)
      : normal1 = json['normal1'],
        normal2 = json['normal2'],
        normal3 = json['normal3'],
        normal4 = json['normal4'],
        normal5 = json['normal5'],
        normal6 = json['normal6'];

  Map<String, dynamic> toJson() => {
        'normal1': normal1,
        'normal2': normal2,
        'normal3': normal3,
        'normal4': normal4,
        'normal5': normal5,
        'normal6': normal6,
      };
}
