
class VoiceSentence {
  // VoiceSentence(
  //   this.sentences,
  //   this.numberOfSentence,
  // );

  List<String> sentences=['안녕하세요','동해물과 백두산이','그대만이 내 사랑','배가 고픕니다','이렇게 하는건 어때?'];
  int numberOfSentence=5;

  List<String> getSentences(){
    return sentences;
  }

  String getOneSentence(int idx){
    return sentences.elementAt(idx);
  }
}
