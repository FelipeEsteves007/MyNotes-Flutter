import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enum/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';

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
          actions: [
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogDialog(context); 
                  if (shouldLogout){
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }
                  break;
              }
            }, itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: MenuAction.logout, child: Text('Logout'),)
              ];
            },)
          ],
        ),
        body: Text(
          'This is the Notes View',
          style: TextStyle(fontSize: 24),
        ),
      );
    }
  }

  Future<bool> showLogDialog(BuildContext context){
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure want to sign out?'),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop(false);
            }, child: const Text('Cancel')),
            TextButton(onPressed: () {
              Navigator.of(context).pop(true);
            }, child: const Text('Log out'))
          ],
        );
      }
    ).then((value) => value ?? false);
  }