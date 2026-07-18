import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.emailAddress,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(hintText: 'Enter your email here'),
          controller: _email,
        ),
        TextField(
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(
            hintText: 'Enter your password here',
          ),
          controller: _password,
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            final email = _email.text.trim();
            final password = _password.text.trim();
            try {
              final userLogin = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: password);
              print(userLogin);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'invalid-credential') {
                print('Invalid credentials error');
              }
              ;
              //print(e.runtimeType);
            }
          },
          child: const Text(
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            'Login',
          ),
        ),
      ],
    );
  }
}
