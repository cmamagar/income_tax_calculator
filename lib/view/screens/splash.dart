import 'dart:async';
import 'package:flutter/material.dart';
import 'package:income_tax_calculator/view/screens/home.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Set a timer to navigate to the Home Screen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage(onLocaleChange: (Locale locale) {  },)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/b.png', // Update with your actual image path
              width: 200, // Adjust as needed
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
