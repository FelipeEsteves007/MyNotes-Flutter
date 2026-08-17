import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

  
}
