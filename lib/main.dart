import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_provider.dart';
import 'card_model.dart';

void main() {
  runApp(const AaronKonnehCardGame());
}

class AaronKonnehCardGame extends StatelessWidget {
  const AaronKonnehCardGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        home: GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aaron Konneh's Card Matching Game"),
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: provider.cards.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => provider.flipCard(index),
                      child: CardWidget(card: provider.cards[index]),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Score: ${provider.score}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Time: ${provider.time}s",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.checkWinCondition())
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "You Won!",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<GameProvider>().resetGame(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final CardModel card;

  const CardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: card.isFaceUp ? Colors.white : Colors.blue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          card.isFaceUp ? card.frontDesign : '?',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: card.isFaceUp ? Colors.red : Colors.white,
          ),
        ),
      ),
    );
  }
}
