class CardModel {
  final String frontDesign;
  final String backDesign;
  bool isFaceUp;

  CardModel({
    required this.frontDesign,
    required this.backDesign,
    this.isFaceUp = false,
  });
}
