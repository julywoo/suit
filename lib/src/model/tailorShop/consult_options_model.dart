class ConsultOptions {
  final String? storeName;
  final String? factoryName;
  final String? options;
  final String? optionsTitle;
  final String? typingOption;
  final String? brandRate;
  final List? optionsList;
  final List? optionsSubList;
  final List? optionsProduceCost;

  //상담 순서 변경 시 리스트
  final List? jacketStep;
  final List? vestStep;
  final List? pantsStep;
  final List? shirtStep;
  final List? coatStep;

  ConsultOptions({
    this.storeName,
    this.factoryName,
    this.options,
    this.optionsTitle,
    this.typingOption,
    this.brandRate,
    this.optionsList,
    this.optionsSubList,
    this.optionsProduceCost,
    this.jacketStep,
    this.vestStep,
    this.pantsStep,
    this.shirtStep,
    this.coatStep,
  });

  ConsultOptions.fromJson(Map<String, dynamic> json)
      : storeName = json['storeName'],
        factoryName = json['factoryName'],
        options = json['options'],
        optionsTitle = json['optionsTitle'],
        typingOption = json['typingOption'],
        brandRate = json['brandRate'],
        optionsList = json['optionsList'],
        optionsSubList = json['optionsSubList'],
        optionsProduceCost = json['optionsProduceCost'],
        jacketStep = json['jacketStep'],
        vestStep = json['vestStep'],
        pantsStep = json['pantsStep'],
        shirtStep = json['shirtStep'],
        coatStep = json['coatStep'];

  Map<String, dynamic> toJson() => {
        'storeName': storeName,
        'factoryName': factoryName,
        'options': options,
        'optionsTitle': optionsTitle,
        'typingOption': typingOption,
        'brandRate': brandRate,
        'optionsList': optionsList,
        'optionsSubList': optionsSubList,
        'optionsProduceCost': optionsProduceCost,
        'jacketStep': jacketStep,
        'vestStep': vestStep,
        'pantsStep': pantsStep,
        'shirtStep': shirtStep,
        'coatStep': coatStep,
      };
}
