class Shirt {
  int? id;
  String? option;
  String? optionImg;
  List<String>? selectList;
  List<String>? selectListVal;

  Shirt({this.id, this.option, this.selectList, this.optionImg});
}

const List shirtOption = [
  {
    'id': 1,
    'optionImg': 'assets/shirt/shirt1.png',
    'option': 'shirtPattern',
    'selectList': [
      '솔리드',
      '스트라이프',
      '체크',
      '클레릭',
    ],
    'selectListVal': ['솔리드', '스트라이프', '체크', '클레릭'],
  },
  {
    'id': 2,
    'optionImg': 'assets/shirt/shirt2.png',
    'option': 'shirtCollar',
    'selectList': [
      '레귤러 칼라',
      '와이드 칼라',
      '세미와이드 칼라',
      '일자 칼라',
      '브이 칼라',
      '라운드 칼라',
      '윙 칼라',
      '차이나 칼라',
      '탭 칼라',
      '속고리단추 칼라',
      '핀 칼라',
      '버튼다운 칼라',
    ],
    'selectListVal': [
      '레귤러(기본) 칼라',
      '와이드 칼라',
      '세미와이드 칼라',
      '일자 칼라',
      '브이 칼라',
      '라운드 칼라',
      '윙 칼라',
      '차이나 칼라',
      '탭 칼라',
      '속고리단추 칼라',
      '핀 칼라',
      '버튼다운 칼라',
    ],
  },
  {
    'id': 3,
    'optionImg': 'assets/shirt/shirt3.png',
    'option': 'shirtCuffs',
    'selectList': [
      '굴림',
      '육각',
      '사각',
      '굴림더블',
      '하프언더더블',
      '독일식',
      '하프굴림',
      '하프육각',
      '육각도메',
      '사각더블',
      '언더더블',
      '사각투버튼',
    ],
    'selectListVal': [
      '굴림',
      '육각',
      '사각',
      '굴림더블',
      '하프언더더블',
      '독일식',
      '하프굴림',
      '하프육각',
      '육각도메',
      '사각더블',
      '언더더블',
      '사각투버튼',
    ],
  },
  {
    'id': 4,
    'optionImg': 'assets/shirt/shirt4.png',
    'option': 'shirtPlacket',
    'selectList': [
      '비저블 플라켓\n(아메리칸 플라켓)',
      '노 플라켓\n(프렌치 플라켓)',
      '커버드 플라켓\n(플라이 플라켓)',
    ],
    'selectListVal': [
      '비저블 플라켓,(아메리칸 플라켓)',
      '노 플라켓,(프렌치 플라켓)',
      '커버드 플라켓,(플라이 플라켓)',
    ],
  },
  {
    'id': 5,
    'optionImg': 'assets/shirt/shirt5.png',
    'option': 'shirtOption',
    'selectList': [
      '카라',
      '소매',
      '기타',
      '없음',
    ],
    'selectListVal': [
      '카라',
      '소매',
      '기타',
      '',
    ],
  }
];
