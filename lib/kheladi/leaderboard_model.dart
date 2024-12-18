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
      points: json['point'],
    );
  }
}
