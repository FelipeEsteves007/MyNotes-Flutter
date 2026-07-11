import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text(style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold), 
          'Login'),
        backgroundColor: Colors.blueGrey,
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
              ),
              onPressed: () async{
                final email = _email.text;
                final password = _password.text;
                final userLogin = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email, password: password);
                  print(userLogin);
              }, 
              child: const Text(
                style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold), 
                  'Login')
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
