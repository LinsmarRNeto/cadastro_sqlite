import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "ExemploDB.db";
  static final _databaseVersion = 1;
  static final table = 'contato';
  static final columnId = '_id';
  static final columnNome = 'nome';
  static final columnIdade = 'idade';

  //torna esta classe singleton
  DatabaseHelper._privateContructor();
  static final DatabaseHelper instance = DatabaseHelper._privateContructor();

  // tem somente uma referência ao banco de dados
  static Database? _database;
}
