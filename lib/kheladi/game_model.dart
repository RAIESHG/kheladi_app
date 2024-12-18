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
      id: json['gameid'].toString(),
      name: json['name'],
      description: json['description'],
    );
  }
}
