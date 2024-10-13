import 'dart:async';
import 'package:flutter/material.dart';
import 'card_model.dart';

class GameProvider with ChangeNotifier {
  List<CardModel> cards = [];
  List<CardModel> faceUpCards = [];
  int score = 0;
  int time = 0;
  Timer? _timer;
  bool timerStarted = false;

  GameProvider() {
    _initializeGame();
  }

  void _initializeGame() {
    List<String> cardDesigns = [
      'K♥',
      'Q♠',
      'J♦',
      'A♣',
      'K♥',
      'Q♠',
      'J♦',
      'A♣'
    ]; // Ensure there are matching pairs

    cards = List.generate(
        cardDesigns.length,
        (index) => CardModel(
              frontDesign: cardDesigns[index],
              backDesign: '?',
            ));
    cards.shuffle(); // Shuffle the cards for randomness
  }

  void flipCard(int index) {
    if (!timerStarted) {
      startTimer();
      timerStarted = true;
    }
    if (cards[index].isFaceUp || faceUpCards.length == 2) return;

    cards[index].isFaceUp = true;
    faceUpCards.add(cards[index]);

    if (faceUpCards.length == 2) {
      _checkMatch();
    }

    notifyListeners();
  }

  void _checkMatch() {
    if (faceUpCards[0].frontDesign == faceUpCards[1].frontDesign) {
      faceUpCards.clear();
      score += 10;
    } else {
      score -= 5;
      Timer(Duration(seconds: 1), () {
        faceUpCards.forEach((card) => card.isFaceUp = false);
        faceUpCards.clear();
        notifyListeners();
      });
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      time++;
      notifyListeners();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  bool checkWinCondition() {
    if (cards.every((card) => card.isFaceUp)) {
      stopTimer();
      return true;
    }
    return false;
  }

  void resetGame() {
    cards.forEach((card) => card.isFaceUp = false);
    cards.shuffle();
    faceUpCards.clear();
    score = 0;
    time = 0;
    timerStarted = false;
    notifyListeners();
  }
}
