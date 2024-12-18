import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Ensure you have the Lottie package in your pubspec.yaml
import 'kheladi_service.dart';
import 'leaderboard_model.dart';
import 'snake_game.dart'; // Import the SnakeGame widget

class KheladiScreen extends StatefulWidget {
  final String gameId;
  final String phonenumber;

  KheladiScreen({required this.gameId, required this.phonenumber});

  @override
  _KheladiScreenState createState() => _KheladiScreenState();
}

class _KheladiScreenState extends State<KheladiScreen> {
  int _points = 0;
  bool _isPlaying = false;
  List<LeaderboardEntry> _leaderboard = [];
  late Widget _currentGame;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
    _initializeGame();
  }

  void _initializeGame() {
    setState(() {
      if (widget.gameId == '1') {
        _currentGame = SnakeGame(
          onScoreUpdate: (score) {
            setState(() => _points = score);
          },
          isPlaying: _isPlaying,
        );
      } else {
        _currentGame = _buildTappingGame();
      }
    });
  }

  Widget _buildTappingGame() {
    return ElevatedButton(
      onPressed: _isPlaying ? () => setState(() => _points++) : null,
      child: Text('Tap to Score'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        backgroundColor: Colors.green,
        textStyle: TextStyle(fontSize: 20),
      ),
    );
  }

  void _startPlaying() {
    setState(() {
      _isPlaying = true;
      _points = 0;
      _initializeGame();
    });
  }

  void _stopPlaying() {
    setState(() {
      _isPlaying = false;
      _initializeGame();
    });
    _updateLeaderboard();
  }

  void _updateLeaderboard() async {
    final kheladiService = KheladiService();
    await kheladiService.updateLeaderboard(
        widget.gameId, widget.phonenumber, _points);
    _fetchLeaderboard();
  }

  void _fetchLeaderboard() async {
    final kheladiService = KheladiService();
    List<LeaderboardEntry> leaderboard =
        await kheladiService.fetchLeaderboard(widget.gameId);
    setState(() {
      _leaderboard = leaderboard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kheladi Game'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/138dd486-5fe7-4e4f-be2a-619d7f1d0303/FtF3NZEawv.json',
              width: 150,
              height: 150,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Points: $_points',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            if (_isPlaying)
              Expanded(child: _currentGame)
            else
              ElevatedButton(
                onPressed: _startPlaying,
                child: Text('Start Playing'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
            if (_isPlaying)
              ElevatedButton(
                onPressed: _stopPlaying,
                child: Text('Stop Playing'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.red,
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
            const SizedBox(height: 20.0),
            Text(
              'Leaderboard:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _leaderboard.length,
                itemBuilder: (context, index) {
                  final entry = _leaderboard[index];
                  return ListTile(
                    title: Text('Player: ${entry.phonenumber}'),
                    subtitle: Text('Points: ${entry.points}'),
                    leading: CircleAvatar(
                      child: Text(
                          entry.phonenumber.substring(0, 1).toUpperCase()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
