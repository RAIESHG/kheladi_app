import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';
import 'leaderboard_model.dart';
import 'game_model.dart';

class KheladiService {
  final String baseUrl = 'http://192.168.1.88:3000';

  Future<User> loginUser(String phonenumber) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$phonenumber'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<Game>> fetchGames() async {
    final response = await http.get(Uri.parse('$baseUrl/games'));
    print(response.body);
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((game) => Game.fromJson(game)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  Future<void> updateLeaderboard(
      String gameId, String phonenumber, int points) async {
    final response = await http.put(
      Uri.parse('$baseUrl/leaderboard/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'gameId': gameId,
        'phoneNumber': phonenumber,
        'points': points,
        'rewarddistributed': 'no'
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update leaderboard');
    }
  }

  Future<User> getUserProfile(String phonenumber) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/$phonenumber'), // Adjust the endpoint as needed
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User(
          phonenumber: data['phonenumber'],
          username: data['username'],
          rewardpoint: data['rewardpoint'].toString(),
          email: data['email']);
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<List<LeaderboardEntry>> fetchLeaderboard(String gameId) async {
    final response = await http.get(Uri.parse('$baseUrl/leaderboard/$gameId'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      print(response.body);
      return jsonResponse
          .map((entry) => LeaderboardEntry.fromJson(entry))
          .toList();
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }
}
