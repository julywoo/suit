class ShirtDesign {
  final String? shirtPattern;
  final String? shirtCollar;
  final String? shirtCuffs;
  final String? shirtPlacket;
  final String? shirtOption;

  ShirtDesign({
    this.shirtPattern,
    this.shirtCollar,
    this.shirtPlacket,
    this.shirtCuffs,
    this.shirtOption,
  });

  ShirtDesign.fromJson(Map<String, dynamic> json)
      : shirtPattern = json['shirtPattern'],
        shirtCollar = json['shirtCollar'],
        shirtPlacket = json['shirtPlacket'],
        shirtCuffs = json['shirtCuffs'],
        shirtOption = json['shirtOption'];

  Map<String, dynamic> toJson() => {
        'shirtPattern': shirtPattern,
        'shirtCollar': shirtCollar,
        'shirtPlacket': shirtPlacket,
        'shirtCuffs': shirtCuffs,
        'shirtOption': shirtOption,
      };
}
