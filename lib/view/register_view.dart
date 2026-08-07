import 'package:flutter/material.dart';
//import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';

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
                    AuthService.firebase().createUser(email: email, password: password);
                    Navigator.of(context).pushNamed(emailRoute);
                    //final user = AuthService.firebase().currentUser;
                    AuthService.firebase().sendEmailVerification();
                  } on WeakpeakException{
                    await showErrorDialog(
                    context, 
                    'weak-password'
                    );
                  } on EmailAlreadyInUseExcepeption {
                    await showErrorDialog(
                    context, 
                    'email already in use'
                    );
                  } on InvalidEmailException {
                    await showErrorDialog(
                    context, 
                    'Invalid email'
                    );
                  } on GenericAuthException {
                    await showErrorDialog(
                    context, 
                    'Error'
                    );
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
                      loginRoute, 
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