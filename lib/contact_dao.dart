import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:async';
import 'contact.dart';

//classe para o gerenciamento de Contatos
class ContactDao {
  static const String databaseName = 'agenda.db';
  late Future<Database> database;

  //Método para conexão com o banco de dados
  Future connect() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, databaseName);
    database = openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
        return db.execute("CREATE TABLE IF NOT EXISTS ${Contact.tableName} ( "
            "${Contact.columnName} TEXT PRIMARY KEY, "
            "${Contact.columnPhone} TEXT)");
      },
    );
  }

  //Método para retornar todos os registros do banco de dados
  Future<List<Contact>> list() async {
    //carrega o banco de dados
    final Database db = await database;
    //aramzena todos os registro em uma lista Map
    final List<Map<String, dynamic>> maps = await db.query(Contact.tableName);

    //transfprma o Map JSON em um objeto Contact
    return List.generate(maps.length, (i) {
      return Contact(
        name: maps[i][Contact.columnName],
        phone: maps[i][Contact.columnPhone],
      );
    });
  }

// Método para inserir um contato na banco de dados
  Future<void> insert(Contact contact) async {
    final Database db = await database;
    await db.insert(
      Contact.tableName,
      contact.toMap(),
    );
  }

  //Método para atualizar um registro
  Future<void> update(Contact contact) async {
    final db = await database;
    await db.update(
      Contact.tableName,
      contact.toMap(),
      where: "${Contact.columnName} = ?",
      whereArgs: [contact.name],
    );
  }

  //Método Para Deletar um registro
  Future<void> delete(String name) async {
    final db = await database;
    await db.delete(
      Contact.tableName,
      where: "${Contact.columnName} = ?",
      whereArgs: [name],
    );
  }
}
