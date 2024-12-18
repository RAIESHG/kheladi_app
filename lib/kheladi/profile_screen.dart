import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For icons
import 'kheladi_service.dart'; // Update to your service file
import 'user_model.dart'; // Ensure you have access to the User model

class ProfileScreen extends StatefulWidget {
  final String phonenumber;

  ProfileScreen({required this.phonenumber});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  void _fetchUserProfile() async {
    final kheladiService = KheladiService();
    User user = await kheladiService.getUserProfile(widget.phonenumber);
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: _user == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        FontAwesomeIcons.userAlt,
                        size: 50,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${_user!.username}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.phone,
                                  color: Colors.deepPurple),
                              SizedBox(width: 8),
                              Text(
                                'Phone Number: ${_user!.phonenumber}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.trophy,
                                  color: Colors.deepPurple),
                              SizedBox(width: 8),
                              Text(
                                'Points: ${_user!.rewardpoint}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.deepPurple),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                      child: ElevatedButton(
                          onPressed: () {}, child: Text("Redeem Points")),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
