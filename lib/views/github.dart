import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../views/home_screen.dart';
import '../utils/session_manager.dart';

bool isLoggedIn = false;
String loggedInUsername = '';
String loggedInName = '';

class Github extends StatefulWidget {
  const Github({super.key});

  @override
  State<Github> createState() => _GithubState();
}

class _GithubState extends State<Github> {

  @override
  void initState() {
    super.initState();
    _checkLoginStatusAndGetUsername();
  }

  Future<void> _checkLoginStatusAndGetUsername() async {
    final loggedIn = await SessionManager.isLoggedIn();
    final loggedInUsername = await SessionManager.getLoggedInUsername();
     if (mounted) {
      setState(() {
        isLoggedIn = loggedIn;
        loggedInName= loggedInUsername;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Github',
      home: isLoggedIn ? HomeScreen(isLoggedIn, loggedInName, '') : const LoginScreen(),
    );
  }
}