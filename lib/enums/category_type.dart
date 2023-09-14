enum CategoryType {
  AGE_4_PLUS,       // 4세 이상
  AGE_6_PLUS,       // 6세 이상
  AGE_8_PLUS,       // 8세 이상
  UPTO_4_AGE,       // 4세 까지
  UPTO_6_AGE,       // 6세 까지
  FAIRY_TALE,      // 동화
  CREATIVE,       // 창작
  LIFE_STYLE,      // 생활
  HABITS,         // 습관
  LEARNING,       // 학습
  SOPHISTICATION, // 교양
  CULTURE,        // 문화
  ART,            // 예술
  SOCIETY,        // 사회
  HISTORY,        // 역사
  NATURAL,        // 자연
  SCIENCE,        // 과학
  NONE,           // unknown
}

Map<CategoryType, String> categoryDescriptionsAge = {
  CategoryType.AGE_4_PLUS: "4세 이상",
  CategoryType.AGE_6_PLUS: "6세 이상",
  CategoryType.AGE_8_PLUS: "8세 이상",
  CategoryType.UPTO_4_AGE: "4세 까지",
  CategoryType.UPTO_6_AGE: "6세 까지",
};

Map<CategoryType, String> categoryDescriptions = {
  CategoryType.AGE_4_PLUS: "4+",
  CategoryType.AGE_6_PLUS: "6+",
  CategoryType.AGE_8_PLUS: "8+",
  CategoryType.UPTO_4_AGE: "~4",
  CategoryType.UPTO_6_AGE: "~6",
  CategoryType.FAIRY_TALE: "동화",
  CategoryType.CREATIVE: "창작",
  CategoryType.LIFE_STYLE: "생활",
  CategoryType.HABITS: "습관",
  CategoryType.LEARNING: "학습",
  CategoryType.SOPHISTICATION: "교양",
  CategoryType.CULTURE: "문화",
  CategoryType.ART: "예술",
  CategoryType.SOCIETY: "사회",
  CategoryType.HISTORY: "역사",
  CategoryType.NATURAL: "자연",
  CategoryType.SCIENCE: "과학",
  CategoryType.NONE: "NONE",
};
