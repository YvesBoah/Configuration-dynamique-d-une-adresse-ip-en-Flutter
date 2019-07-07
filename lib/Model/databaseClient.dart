import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// Import du model
import 'package:myapi/Model/ip.dart';

class DatabaseClient {

  Database _database;
  /* Quand dans une class on commence l'écriture d'une variable par _ (enderscore)
    celà veut dire tout simplement que cette variable est privée.
    on y accède via une clause FUTURE & get
  */

  Future<Database> get database async {
    if(_database != null){
      return _database;
    } else{
      // Crée cette base de données
      _database = await create();
      return _database;
    }
  }

  // Fonction de création de base de données
  Future create() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String databaseDirectory = join(directory.path, 'database.db');
    // Déclaration de la variable contenant la base de données bdd
    var bdd = await openDatabase(databaseDirectory, version:1, onCreate: _onCreate);
    return bdd;

  }
  // Fonction enfant de Create()
  Future _onCreate(Database db,int version) async {
    await db.execute('''
    CREATE TABLE ip (
      id INTEGER PRIMARY KEY autoincrement, 
      adresseIp TEXT 
      )
    ''');
  }


  //*********************** ECRITURE DE DONNEES ***********************

  Future<Ip> ajoutIp(Ip ip) async {
    // le database du Future get qui verifie l'etat de la base de données
    Database maDatabase = await database;
    ip.id = await maDatabase.insert('ip', ip.toMap());
    return ip;
  }





  //*********************** LECTURE DE DONNEES ***********************

  Future<List<Ip>> allIp() async {
    // le database du Future get qui verifie l'etat de la base de données
    Database maDatabase = await database;
    // Création d'une liste pour récupérer le contenu d'une table dans notre cas.
    List<Map<String, dynamic>> resultat = await maDatabase.rawQuery('SELECT * FROM ip ');
    //List<Map<String, dynamic>> resultat = await maDatabase.rawQuery('SELECT * FROM ip order by id desc LIMIT 1');
    // ips ou ip_all recupère tout les enregistrements.
    List<Ip> ips = [];
    resultat.forEach((map) {
      Ip ip = new Ip();
      ip.fromMap(map);
      //--
      ips.add(ip);
      // Ajout
    });
    return ips;
  }


  Future<List<Ip>> oneIp() async {
    // le database du Future get qui verifie l'etat de la base de données
    Database maDatabase = await database;
    // Création d'une liste pour récupérer le contenu d'une table dans notre cas.
    //List<Map<String, dynamic>> resultat = await maDatabase.rawQuery('SELECT * FROM ip ');
    List<Map<String, dynamic>> resultat = await maDatabase.rawQuery('SELECT * FROM ip order by id desc LIMIT 1');
    // ips ou ip_all recupère tout les enregistrements.
    List<Ip> ips = [];
    resultat.forEach((map) {
      Ip ip = new Ip();
      ip.fromMap(map);
      //--
      ips.add(ip);
      // Ajout
    });
    return ips;
  }
  //***********************  DE DONNEES ***********************


}