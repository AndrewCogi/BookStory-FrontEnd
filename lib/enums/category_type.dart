enum CategoryType {
  age4plus,       // 4세 이상
  age6plus,       // 6세 이상
  age8plus,       // 8세 이상
  upto4age,       // 4세 까지
  upto6age,       // 6세 까지
  fairyTale,      // 동화
  creative,       // 창작
  lifeStyle,      // 생활
  habits,         // 습관
  learning,       // 학습
  sophistication, // 교양
  culture,        // 문화
  art,            // 예술
  society,        // 사회
  history,        // 역사
  natural,        // 자연
  science,        // 과학
  none,           // unknown
}

Map<CategoryType, String> categoryDescriptionsAge = {
  CategoryType.age4plus: "4세 이상",
  CategoryType.age6plus: "6세 이상",
  CategoryType.age8plus: "8세 이상",
  CategoryType.upto4age: "4세 까지",
  CategoryType.upto6age: "6세 까지",
};

Map<CategoryType, String> categoryDescriptions = {
  CategoryType.age4plus: "4+",
  CategoryType.age6plus: "6+",
  CategoryType.age8plus: "8+",
  CategoryType.upto4age: "~4",
  CategoryType.upto6age: "~6",
  CategoryType.fairyTale: "동화",
  CategoryType.creative: "창작",
  CategoryType.lifeStyle: "생활",
  CategoryType.habits: "습관",
  CategoryType.learning: "학습",
  CategoryType.sophistication: "교양",
  CategoryType.culture: "문화",
  CategoryType.art: "예술",
  CategoryType.society: "사회",
  CategoryType.history: "역사",
  CategoryType.natural: "자연",
  CategoryType.science: "과학",
  CategoryType.none: "NONE",
};
