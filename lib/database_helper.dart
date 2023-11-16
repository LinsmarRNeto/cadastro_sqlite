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

  Future<Database> get database async => _database ??= await _initDatabase();

  //abre o banco de dados ou o cria se não existir
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  //codigo sql para criar o banco de dados e a tabela
  Future _onCreate(Database db, int version) async {
    await db.execute('''
            CREATE TABLE $table (
              $columnId INTEGER PRIMARY KEY,
              $columnNome TEXT NOT NULL,
              $columnIdade INTEGER NOT NULL
            )
          ''');
  }

  //metodos helper
  //--------------------------------------------------------------------------
  //insere uma linha no banco de dados onde cada chave
  // no Map é um nome de coluna e o valor é o valor da coluna.
  // O valor de retorno é o id da linha inserida.

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  //Todas as linhas sao retornadas como uma lista de mapas onde cada mapa é
  // uma lista de valores-chave de colunas
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  //Todos os métodos: inserir, consultar, atuaizar e excluir,
  //também podem ser feitos usando comando SQL brutos.
  //Esse método usa uma consulta bruta para fornecer a contagem de linha
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  //Assumimos aqui que a coluna id no mapa está definida. Os outros
  //valores das colunas serão usados para atualizar a linha.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  //Exclui a linha especificada pelo id. O número de linhas afetadas é
  //retornada. Isso deve ser igual a 1, contanto que a linha exista.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
