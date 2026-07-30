import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          style: TextStyle(color: Colors.white),
          'Verify Email',
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "We've sent you an email verification, please open it to verify your account!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text("Send Email Verification"),
            ),
            TextButton(
                style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
