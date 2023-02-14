class CostVest {
  final int? vest1;
  final int? vest2;
  final int? vest3;
  final int? vest4;
  final int? vest5;
  final int? vest6;

  CostVest({
    this.vest1,
    this.vest2,
    this.vest3,
    this.vest4,
    this.vest5,
    this.vest6,
  });

  CostVest.fromJson(Map<String, dynamic> json)
      : vest1 = json['vest1'],
        vest2 = json['vest2'],
        vest3 = json['vest3'],
        vest4 = json['vest4'],
        vest5 = json['vest5'],
        vest6 = json['vest6'];

  Map<String, dynamic> toJson() => {
        'vest1': vest1,
        'vest2': vest2,
        'vest3': vest3,
        'vest4': vest4,
        'vest5': vest5,
        'vest6': vest6,
      };
}
