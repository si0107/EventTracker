import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/src/screens/home_screen.dart';
import 'package:flutter_complete_guide/src/screens/login_screen.dart';
import 'package:flutter_complete_guide/src/screens/signup_screen.dart';
// import 'package:flutter_complete_guide/src/screens/welcome.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar ToDo',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen()
      },
    );
  }
}
