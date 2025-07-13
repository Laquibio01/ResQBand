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

  static Future<Map<String, dynamic>?> getUserData(String email) async {
    try {
      var user = await _collection.findOne(where.eq('email', email));
      if (user != null && user['role'] == 'Adulto Mayor') {
        var caregiver = await _collection.findOne(where.eq('_id', user['linkedUserId']));
        user['caregiver'] = caregiver;
      }
      return user;
    } catch (e) {
      print('Error al obtener datos del usuario: $e');
      return null;
    }
  }

  static Future<bool> linkUsers(String elderlyCode, String caregiverEmail) async {
    try {
      // Buscar al adulto mayor por su código
      var elderly = await _collection.findOne(where.eq('_id', elderlyCode));
      if (elderly == null) return false;

      // Buscar al cuidador por email
      var caregiver = await _collection.findOne(where.eq('email', caregiverEmail));
      if (caregiver == null) return false;

      // Actualizar ambos registros
      await _collection.update(
        where.eq('_id', elderly['_id']),
        modify.set('linkedUserId', caregiver['_id'])
      );

      return true;
    } catch (e) {
      print('Error al vincular usuarios: $e');
      return false;
    }
  }

  static Future<String> generateElderlyCode() async {
    // Generar un código único de 6 dígitos
    final code = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    return code;
  }
    static Future<void> updateUser({required String email, required Map<String, dynamic> data}) async {
    await _collection.updateOne(
      {'email': email},
      {'\$set': data}
    );
  }
}