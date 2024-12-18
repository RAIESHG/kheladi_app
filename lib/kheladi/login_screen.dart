import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
            builder: (context) =>
                GameSelectionScreen(phonenumber: user.phonenumber),
          ),
        );
      } catch (e) {
        print('Failed to login: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kheladi - Mhangsa Tech',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation for a fun touch
              Lottie.network(
                'https://lottie.host/5dc8b297-e8ae-41e8-9b4a-15e003020987/7appBKbO56.json', // Add a Lottie file in your assets folder
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),
              // Welcome text
              Text(
                'Welcome to Kheladi!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20.0),
              // Phone number input
              TextField(
                controller: _phonenumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.phone, color: Colors.deepPurple),
                ),
              ),
              const SizedBox(height: 30.0),
              // Login button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                  primary: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
