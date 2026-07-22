import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/view/login_view.dart';
import 'package:mynotes/view/register_view.dart';
import 'package:mynotes/view/verify_viewEmail.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'MyApp',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
      routes: {
        '/login/0': (context) => const LoginView(),
        '/register/0': (context) => const RegisterView(),
      }
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null){
                if (user.emailVerified){
                   return const NotesView();  
                } else {
                  return const VerifyEmail  ();
                }
              } else {
                return const LoginView();
              }   
            default:
              return const CircularProgressIndicator();
           }    
        },
      );
  }
}


class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( style: TextStyle(color: Colors.white), 'Notes'),
        backgroundColor: Colors.black,
      ),
    );
  }
}