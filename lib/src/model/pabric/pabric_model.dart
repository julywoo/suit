class Pabric {
  final String? pabricName;
  final List? pabricList;

  Pabric(
    this.pabricName,
    this.pabricList,
  );

  Pabric.fromJson(Map<String, dynamic> json)
      : pabricName = json['pabricName'],
        pabricList = json['pabricList'];

  Map<String, dynamic> toJson() => {
        'pabricName': pabricName,
        'pabricList': pabricList,
      };
}
