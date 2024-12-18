import 'package:flutter/material.dart';
import 'package:kheladi_app/kheladi/profile_screen.dart';
import 'package:lottie/lottie.dart';
import 'kheladi_service.dart';
import 'game_model.dart';
import 'kheladi_screen.dart';

class GameSelectionScreen extends StatefulWidget {
  final String phonenumber;

  GameSelectionScreen({required this.phonenumber});

  @override
  _GameSelectionScreenState createState() => _GameSelectionScreenState();
}

class _GameSelectionScreenState extends State<GameSelectionScreen> {
  List<Game> _games = [];
  bool _isLoading = true;

  // Lottie animations corresponding to games
  final List<String> lottieUrls = [
    'https://lottie.host/6c355b1b-17c3-4b6c-8983-df344efbd310/TjnY9dDoEa.json',
    'https://lottie.host/3df0e69a-7c19-47eb-b3a8-50b10414d0e8/d9qfiOP9HM.json',
    'https://lottie.host/be0f5e4e-99f3-4a15-b90a-38c779bdcbfc/N5k9toD6c3.json',

    // Add more URLs as needed for your games
  ];

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  void _fetchGames() async {
    final kheladiService = KheladiService();
    List<Game> games = await kheladiService.fetchGames();
    setState(() {
      _games = games;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select a Game',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfileScreen(phonenumber: widget.phonenumber),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              // Lottie loading animation from network
              child: Lottie.network(
                'https://assets3.lottiefiles.com/packages/lf20_ktwnwv5m.json',
                width: 150,
                height: 150,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two items per row
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.6, // Adjust the ratio for a better fit
                ),
                itemCount: _games.length,
                itemBuilder: (context, index) {
                  final game = _games[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KheladiScreen(
                            gameId: game.id,
                            phonenumber: widget.phonenumber,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Lottie animation for each game from the corresponding URL
                          Container(
                            height: 100,
                            width: 100,
                            child: Lottie.network(
                              lottieUrls[index %
                                  lottieUrls
                                      .length], // Cycle through lottie URLs
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          // Game Name
                          Text(
                            game.name,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6.0),
                          // Game Description
                          Expanded(
                            child: Text(
                              game.description,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow
                                  .ellipsis, // Prevent text overflow
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
