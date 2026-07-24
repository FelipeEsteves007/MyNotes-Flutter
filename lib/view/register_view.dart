import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

@override
  initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

@override
  dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( style: TextStyle(color: Colors.white), 'Register'),
        backgroundColor: Colors.black,
      ),
      body: Column(
            children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter your email here'
                ),
                controller: _email
              ),
              TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter your password here',
                ),
                controller: _password
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () async{
                  final email = _email.text.trim();
                  final password = _password.text.trim();
                  try {
                    final userCredencial = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, password: password);
                    devtools.log(userCredencial.toString());
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      devtools.log('Weak password');
                    } else if (e.code == 'email-already-in-use') {
                      devtools.log('Email already in use');
                    } else if (e.code == 'invalid-email') {
                      devtools.log('Invalid email');
                    }
                    //print('Error: ${e.code}');
                  }
                }, 
                child: const Text(
                  style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold), 
                    'Register')
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login/', 
                      (route) => false);
                  },
                  child: const Text(
                    style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                      'Already registered? Login here!'
                    )
                ),
            ],
          ),
    );
  }
}