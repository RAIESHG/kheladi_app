class User {
  final String phonenumber;
  final String username;
  final String email;
  final String rewardpoint;

  User({
    required this.phonenumber,
    required this.username,
    required this.email,
    required this.rewardpoint,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        phonenumber: json['phonenumber'],
        username: json['username'],
        email: json['email'],
        rewardpoint: json['rewardpoint'].toString());
  }
}
