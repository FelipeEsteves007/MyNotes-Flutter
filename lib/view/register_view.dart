import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

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
        title: const Text(style: TextStyle(color: Colors.white), 'Register'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
               return Column(
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
                  print(userCredencial);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('Weak password');
                  } else if (e.code == 'email-already-in-use') {
                    print('Email already in use');
                  } else if (e.code == 'invalid-email') {
                    print('Invalid email');
                  }
                  //print('Error: ${e.code}');
                }
              }, 
              child: const Text(
                style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold), 
                  'Register')
              ),
          ],
        );
        default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}