#!/bin/bash

# Define project name and feature name
PROJECT_NAME=kheladi_app
FEATURE_NAME=kheladi

# Base directory for the feature
BASE_DIR="lib/$FEATURE_NAME"

# Create directories
mkdir -p "$BASE_DIR"

# Create and populate User model
cat > "$BASE_DIR/user_model.dart" <<EOF
class User {
  final String phonenumber;
  final String username;
  final String email;

  User({
    required this.phonenumber,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phonenumber: json['phonenumber'],
      username: json['username'],
      email: json['email'],
    );
  }
}
EOF

# Create and populate Leaderboard model
cat > "$BASE_DIR/leaderboard_model.dart" <<EOF
class LeaderboardEntry {
  final String phonenumber;
  final int points;

  LeaderboardEntry({
    required this.phonenumber,
    required this.points,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      phonenumber: json['phonenumber'],
      points: json['points'],
    );
  }
}
EOF

# Create and populate Game model
cat > "$BASE_DIR/game_model.dart" <<EOF
class Game {
  final String id;
  final String name;
  final String description;

  Game({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
EOF

# Create and populate API service
cat > "$BASE_DIR/kheladi_service.dart" <<EOF
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';
import 'leaderboard_model.dart';
import 'game_model.dart';

class KheladiService {
  final String baseUrl = 'http://localhost:3000';

  Future<User> loginUser(String phonenumber) async {
    final response = await http.get(Uri.parse('\$baseUrl/user/\$phonenumber'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<Game>> fetchGames() async {
    final response = await http.get(Uri.parse('\$baseUrl/games'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((game) => Game.fromJson(game)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  Future<void> updateLeaderboard(String gameId, String phonenumber, int points) async {
    final response = await http.put(
      Uri.parse('\$baseUrl/leaderboard/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'gameId': gameId, 'phoneNumber': phonenumber, 'points': points}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update leaderboard');
    }
  }

  Future<List<LeaderboardEntry>> fetchLeaderboard(String gameId) async {
    final response = await http.get(Uri.parse('\$baseUrl/leaderboard/\$gameId'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((entry) => LeaderboardEntry.fromJson(entry)).toList();
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }
}
EOF

# Create and populate Login screen
cat > "$BASE_DIR/login_screen.dart" <<EOF
import 'package:flutter/material.dart';
import 'kheladi_service.dart';
import 'user_model.dart';
import 'game_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phonenumberController = TextEditingController();

  void _login() async {
    final phonenumber = _phonenumberController.text;
    if (phonenumber.isNotEmpty) {
      try {
        final kheladiService = KheladiService();
        User user = await kheladiService.loginUser(phonenumber);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameSelectionScreen(phonenumber: user.phonenumber),
          ),
        );
      } catch (e) {
        print('Failed to login: \$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phonenumberController,
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

# Create and populate Game Selection screen
cat > "$BASE_DIR/game_selection_screen.dart" <<EOF
import 'package:flutter/material.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Game'),
      ),
      body: ListView.builder(
        itemCount: _games.length,
        itemBuilder: (context, index) {
          final game = _games[index];
          return ListTile(
            title: Text(game.name),
            subtitle: Text(game.description),
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
          );
        },
      ),
    );
  }
}
EOF

# Create and populate Kheladi screen (game play and leaderboard)
cat > "$BASE_DIR/kheladi_screen.dart" <<EOF
import 'package:flutter/material.dart';
import 'kheladi_service.dart';
import 'leaderboard_model.dart';

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

  void _startPlaying() {
    setState(() {
      _isPlaying = true;
      _points = 0;
    });
  }

  void _stopPlaying() {
    setState(() {
      _isPlaying = false;
    });
    _updateLeaderboard();
  }

  void _updateLeaderboard() async {
    final kheladiService = KheladiService();
    await kheladiService.updateLeaderboard(widget.gameId, widget.phonenumber, _points);
    _fetchLeaderboard();
  }

  void _fetchLeaderboard() async {
    final kheladiService = KheladiService();
    List<LeaderboardEntry> leaderboard = await kheladiService.fetchLeaderboard(widget.gameId);
    setState(() {
      _leaderboard = leaderboard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kheladi Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isPlaying)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _points++;
                  });
                },
                child: Text('Tap to Score (Points: \$_points)'),
              )
            else
              ElevatedButton(
                onPressed: _startPlaying,
                child: Text('Start Playing'),
              ),
            if (_isPlaying)
              ElevatedButton(
                onPressed: _stopPlaying,
                child: Text('Stop Playing'),
              ),
            const SizedBox(height: 20.0),
            Text('Total Points: \$_points'),
            const SizedBox(height: 20.0),
            Text('Leaderboard:'),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _leaderboard.length,
              itemBuilder: (context, index) {
                final entry = _leaderboard[index];
                return ListTile(
                  title: Text('Player: \${entry.phonenumber}'),
                  subtitle: Text('Points: \${entry.points}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
EOF

# Reminder to add http package to pubspec.yaml
echo "Feature Added Enjoy"
