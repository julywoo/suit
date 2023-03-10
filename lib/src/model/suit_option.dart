const List processOption = [
  '상담중',
  '상담완료',
  '요척',
  '원부자재입고',
  '재단',
  '가봉중', //공장
  '가봉완료', // 공장
  '가봉출고', // 공장 > 테일러샵
  '가봉입고/수정', // 테일러샵  (수정 후 제작 Or 중가봉)
  '중가봉중', //공장
  '중가봉완료', // 공장
  '중가봉출고', // 공장 > 테일러샵
  '중가봉입고/수정', // 테일러샵  (수정 후 제작 Or 중가봉)
  '봉제/작업자확인',
  '작업중',
  '제작완료',
  '고객전달완료'
];

const List processColor = [
  '#e9473a',
  '#eb958e',
  '#465af1',
  '#8ecbeb',
  '#efba3c',
  '#1f1972',
  '#703ae9',
  '#bc8eeb',
  '#d5bfeb',
  '#1f1972',
  '#703ae9',
  '#bc8eeb',
  '#d5bfeb',
  '#e6501c',
  '#e8764e',
  '#f0b19b',
  '#a3a3a3',
];

const List productType = [
  '수트',
  '자켓',
  '셔츠',
  '바지',
  '조끼',
  '코트',
];

const List suitOption = [
  {
    'id': 1,
    'optionImg': 'assets/option/sam1.png',
    'option': 'jacketButton',
    '`selectList`': [
      '싱글 브레스티드 1버튼',
      '싱글 브레스티드 2버튼',
      '더블 브레스티드 6버튼',
    ],
    'selectListVal': ['1보당', '2보당', '더블'],
  },
  {
    'id': 2,
    'optionImg': 'assets/option/sam2.png',
    'option': 'jacketLapel',
    'selectList': ['노치드 라펠', '피크드 라펠', '숄 라펠', '제네바 스타일 라펠'],
    'selectListVal': ['하찌애리', '갱애리', '숄카라', '제네바 애리'],
  },
  {
    'id': 3,
    'optionImg': 'assets/option/sam3.png',
    'option': ' jacketChestPocket',
    'selectList': [
      '브레스트 포켓',
      '켓아웃 포',
      '포슈바또 포켓',
      '라 바르카 포켓',
    ],
    'selectListVal': ['학꼬 일자', '학꼬 아웃트', '학꼬 사선', '학꼬 굴림'],
  },
  {
    'id': 4,
    'optionImg': 'assets/option/sam4.png',
    'option': 'jacketShoulder',
    'selectList': [
      '내츄럴 숄더',
      '로프트 숄더',
      '마니카 카마치아 숄더',
    ],
    'selectListVal': ['후레시 소매', '소꼬스키 소매', '보카시 소매'],
  },
  {
    'id': 5,
    'optionImg': 'assets/option/sam5.png',
    'option': 'jacketSidePocket',
    'selectList': [
      '플랩 포켓',
      '파이프 포켓',
      '슬랜트 포켓',
      '아웃 포켓',
      '플랩 포켓 + 티켓 포켓',
      '파이프 포켓 + 티켓 포켓',
      '슬랜트 포켓 + 티켓 포켓',
      '아웃 포켓 + 티켓 포켓',
    ],
    'selectListVal': [
      '후다 주머니',
      '료다마 주머니',
      '사선 주머니',
      '아웃 주머니',
      '후다+콩주머니까지',
      '료다마+콩주머니까지',
      '사선주머니+콩주머니까지',
      '아웃포켓+콩주머니까지',
    ],
  },
  {
    'id': 6,
    'optionImg': 'assets/option/sam6.png',
    'option': 'jacketVent',
    'selectList': ['트임 없이', '중앙 트임', '옆 트임'],
    'selectListVal': ['통 마이 박스', '후개', '양개'],
  },
  {
    'id': 7,
    'optionImg': 'assets/option/sam7.png',
    'option': 'vestButton',
    'selectList': ['싱글 베스트', '더블 베스트(6x3)', '더블 베스트(4x2 2x2)', '없음'],
    'selectListVal': ['싱글베스트', '더블베스트(6x3)', '더블베스트 (4x2 2x2)', ''],
  },
  {
    'id': 8,
    'optionImg': 'assets/option/sam8.png',
    'option': 'vestLapel',
    'selectList': ['라펠 없이', '노치드 라펠', '피크드 라펠', '없음'],
    'selectListVal': ['라펠없이', '하찌애리', '갱애리', ''],
  },
  {
    'id': 9,
    'optionImg': 'assets/option/sam9.png',
    'option': 'pantsPleats',
    'selectList': ['주름 없이', '주름 1개', '주름 2개'],
    'selectListVal': ['주름 없이', '주름 1개', '주름 2개'],
  },
  {
    'id': 10,
    'optionImg': 'assets/option/sam10.png',
    'option': 'pantsDetailOne',
    'selectList': [
      '사이드 어드저스터',
      '벨트링',
    ],
    'selectListVal': ['옆비죠깡', '벨트고리'],
  },
  {
    'id': 11,
    'optionImg': 'assets/option/sam11.png',
    'option': 'pantsDetailTwo',
    'selectList': ['모닝컷', '접어 올린 단(턴업)'],
    'selectListVal': ['모닝컷', '카부라'],
  },
  {
    'id': 12,
    'optionImg': 'assets/option/sam12.png',
    'option': 'pantsDetailThree',
    'selectList': [
      '구르카',
      '구르카 없이',
    ],
    'selectListVal': ['구르카 팬츠', ''],
  },
  {
    'id': 13,
    'optionImg': 'assets/option/sam13.png',
    'option': 'pantsBreak',
    'selectList': ['풀 브레이크', '하프 브레이크', '노 브레이크'],
    'selectListVal': ['풀 브레이크', '하프 브레이크', ''],
  },
  {
    'id': 14,
    'optionImg': 'assets/option/sam14.png',
    'option': 'pantsPermanentPleats',
    'selectList': ['영구주름', '영구주름 없이'],
    'selectListVal': ['영구주름', ''],
  },
];

const List suitOption2 = [
  {
    'id': 1,
    'optionImg': 'assets/option/sam1.png',
    'option': 'jacketButton',
    'selectList': [
      '싱글 브레스티드 1버튼',
      '싱글 브레스티드 2버튼',
      '더블 브레스티드 6버튼',
    ],
    'selectListVal': ['1보당', '2보당', '더블'],
  },
  {
    'id': 2,
    'optionImg': 'assets/option/sam2.png',
    'option': 'jacketLapel',
    'selectList': ['노치드 라펠', '피크드 라펠', '숄 라펠', '제네바 스타일 라펠'],
    'selectListVal': ['하찌애리', '갱애리', '숄카라', '제네바 애리'],
  },
  {
    'id': 3,
    'optionImg': 'assets/option/sam3.png',
    'option': ' chestPocket',
    'selectList': [
      '브레스트 포켓',
      '아웃 포켓',
      '포슈바또 포켓',
      '라 바르카 포켓',
    ],
    'selectListVal': ['학꼬 일자', '학꼬 아웃트', '학꼬 사선', '학꼬 굴림'],
  },
  {
    'id': 4,
    'optionImg': 'assets/option/sam4.png',
    'option': 'jacketShoulder',
    'selectList': [
      '내츄럴 숄더',
      '로프트 숄더',
      '마니카 카마치아 숄더',
    ],
    'selectListVal': ['후레시 소매', '소꼬스키 소매', '보카시 소매'],
  },
  {
    'id': 5,
    'optionImg': 'assets/option/sam5.png',
    'option': 'jacketSidePocket',
    'selectList': [
      '플랩 포켓',
      '파이프 포켓',
      '슬랜트 포켓',
      '아웃 포켓',
      '플랩 포켓 + 티켓 포켓',
      '파이프 포켓 + 티켓 포켓',
      '슬랜트 포켓 + 티켓 포켓',
      '아웃 포켓 + 티켓 포켓',
    ],
    'selectListVal': [
      '후다 주머니',
      '료다마 주머니',
      '사선 주머니',
      '아웃 주머니',
      '후다+콩주머니까지',
      '료다마+콩주머니까지',
      '사선주머니+콩주머니까지',
      '아웃포켓+콩주머니까지',
    ],
  },
  {
    'id': 6,
    'optionImg': 'assets/option/sam6.png',
    'option': 'jacketVent',
    'selectList': ['트임 없이', '중앙 트임', '옆 트임'],
    'selectListVal': ['통 마이 박스', '후개', '양개'],
  },
  {
    'id': 7,
    'optionImg': 'assets/option/sam7.png',
    'option': 'vestButton',
    'selectList': ['싱글 베스트', '더블 베스트(6x3)', '더블 베스트(4x2 2x2)', '없음'],
    'selectListVal': ['싱글베스트', '더블베스트(6x3)', '더블베스트 (4x2 2x2)', ''],
  },
  {
    'id': 8,
    'optionImg': 'assets/option/sam8.png',
    'option': 'vestLapel',
    'selectList': ['라펠 없이', '노치드 라펠', '피크드 라펠', '없음'],
    'selectListVal': ['라펠없이', '하찌애리', '갱애리', ''],
  },
  {
    'id': 9,
    'optionImg': 'assets/option/sam9.png',
    'option': 'pantsPleats',
    'selectList': ['주름 없이', '주름 1개', '주름 2개'],
    'selectListVal': ['주름 없이', '주름 1개', '주름 2개'],
  },
  {
    'id': 10,
    'optionImg': 'assets/option/sam10.png',
    'option': 'pantsDetailOne',
    'selectList': [
      '사이드 어드저스터',
      '벨트링',
    ],
    'selectListVal': ['옆비죠깡', '벨트고리'],
  },
  {
    'id': 11,
    'optionImg': 'assets/option/sam11.png',
    'option': 'pantsDetailTwo',
    'selectList': ['모닝컷', '접어 올린 단(턴업)'],
    'selectListVal': ['모닝컷', '카부라'],
  },
  {
    'id': 12,
    'optionImg': 'assets/option/sam12.png',
    'option': 'pantsDetailThree',
    'selectList': [
      '구르카',
      '구르카 없이',
    ],
    'selectListVal': ['구르카 팬츠', ''],
  },
  {
    'id': 13,
    'optionImg': 'assets/option/sam13.png',
    'option': 'pantsBreak',
    'selectList': ['풀 브레이크', '하프 브레이크', '노 브레이크'],
    'selectListVal': ['풀 브레이크', '하프 브레이크', ''],
  },
  {
    'id': 14,
    'optionImg': 'assets/option/sam14.png',
    'option': 'pantsPermanentPleats',
    'selectList': ['영구주름', '영구주름 없이'],
    'selectListVal': ['영구주름', ''],
  },
  {
    'id': 15,
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
    'id': 16,
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
    'id': 17,
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
    'id': 18,
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
    'id': 19,
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
