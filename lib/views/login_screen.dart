// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import '../models/user_data.dart';
import 'home_screen.dart';
import '../utils/session_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isRegistering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Github'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SizedBox(height: 20),
            if(isRegistering) 
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if(isRegistering)
                  TextButton(
                    onPressed: () => _register(context),
                    child: const Text('Submit'),
                  ),
                if(!isRegistering)
                  TextButton(
                    onPressed: () => _login(context),
                    child: const Text('Log in'),
                  ),
                TextButton(
                  onPressed: () => _toggleRegisterState(),
                  child: Text((isRegistering ? 'Cancel' : 'New User? Click here to register'), style: const TextStyle(fontSize: 11)),
                ),
              ], 
            ),
          ],
        ),
      ),
    );
  }

  void _toggleRegisterState() {
    setState(() {
      isRegistering = !isRegistering;
    });
  }

  Future<void> _login(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;
    final email = emailController.text;

    bool isLoggedIn = await UserDataModel().checkUserLoggedIn(username, password);
    await SessionManager.setSessionToken(username, email);

    if (!mounted) return;

    if (isLoggedIn) {

      if (!mounted) return;

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => HomeScreen(isLoggedIn, username, email),
      ));
    } else {
      showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('User might not be registered or the username and password may be incorrect. Try Again!'),
            ],
          ),
        ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),  
            ),
          ],
        );
      },
    );
    }
  }

  bool _validateEmail(String email) {
    bool isValid = true;
    if(email == null || email.isEmpty || !email.contains('@') || !email.contains('.') || !email.contains('.co')) {
      isValid = false;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invalid email'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    return isValid;
  }

  Future<void> _register(BuildContext context) async {
    final email = emailController.text;
    final username = usernameController.text;
    final password = passwordController.text;

    bool emailValidation = _validateEmail(email);

    if(!emailValidation) {
      return;
    }

    final newUser = UserDataModel(
      username: username,
      password: password,
      email: email,
      isLoggedIn: true
    );

    await newUser.dbSave();

    if (!mounted) return;

    if (newUser.isLoggedIn == true) {

      if (!mounted) return;

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => HomeScreen(true, username, email),
      ));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('User already registered'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}