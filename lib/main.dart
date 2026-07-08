import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            
            case ConnectionState.none:
              // TODO: Handle this case.
              throw UnimplementedError();
            case ConnectionState.waiting:
              // TODO: Handle this case.
              throw UnimplementedError();
            case ConnectionState.active:
              // TODO: Handle this case.
              throw UnimplementedError();
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
              onPressed: () async{
                final email = _email.text;
                final password = _password.text;
                final userCredencial = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email, password: password);
              }, 
              child: const Text(
                style: TextStyle(
                  color: Colors.black), 
                  'Register')
              ),
          ],
        );
              throw UnimplementedError();
          }
        },
      ),
    );
  }
}
