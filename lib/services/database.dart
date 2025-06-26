import 'package:mongo_dart/mongo_dart.dart';

class Database {
  static const String _mongoUrl = 'mongodb+srv://alan2025:martin25@cluster0.ryuyx1m.mongodb.net/Integradora?retryWrites=true&w=majority';
  static const String _collectionName = 'Usuarios';
  
  static late Db _db;
  static late DbCollection _collection;

  static Future<void> connect() async {
    _db = await Db.create(_mongoUrl);
    await _db.open();
    _collection = _db.collection(_collectionName);
    print('<-- Conectado a MongoDB -->');
  }

  static Future<void> close() async {
    await _db.close();
    print('<-- Conexión cerrada -->');
  }

  static Future<bool> insertUser(Map<String, dynamic> userData) async {
    try {
      var result = await _collection.insertOne(userData);
      return result.isSuccess;
    } catch (e) {
      print('### Error al insertar usuario: $e ###');
      return false;
    }
  }

  static Future<bool> emailExists(String email) async {
    try {
      var user = await _collection.findOne(where.eq('email', email));
      return user != null;
    } catch (e) {
      print('### Error al verificar email: $e ###');
      return false;
    }
  }
  
  static Future<Map<String, dynamic>?> authenticateUser(String email, String name) async {
  try {
    var user = await _collection.findOne(
      where.eq('email', email).eq('name', name)
    );
    return user;
  } catch (e) {
    print('Error al autenticar usuario: $e');
    return null;
  }
}
}
