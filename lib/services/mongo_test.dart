import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  const mongoUrl = 'mongodb+srv://alan2025:martin25@cluster0.ryuyx1m.mongodb.net/Integradora?retryWrites=true&w=majority';
  const collectionName = 'Usuarios'; // Ajusta el nombre si es necesario

  // Conexión a la base de datos
  var db = await Db.create(mongoUrl);
  await db.open();
  print('✅ Conectado a MongoDB');

  var collection = db.collection(collectionName);

  // Documento de prueba
  var now = DateTime.now().toUtc();
  var newUser = {
    'name': 'Juan',
    'email': 'juan.perez@example.com',
    'role': 'Paciente',
    'linkedUserId': '',
    'gender': 'Masculino',
    'birthDate': '1990-01-15',
    'bloodType': 'O+',
    'address': 'Calle Falsa 123',
    'emergencyContact': {
      'name': 'María Pérez',
      'phone': '555-123-4567',
      'relationship': 'Hermana',
    },
    'allergies': [],
    'chronicConditions': [],
    'medications': [],
    'createdAt': now.toIso8601String(),
    'updatedAt': now.toIso8601String(),
  };

  // Insertar el documento
  var result = await collection.insertOne(newUser);
  if (result.isSuccess) {
    print('✅ Documento insertado con ID: ${result.id}');
  } else {
    print('❌ Error al insertar documento');
  }

  await db.close();
  print('🔌 Conexión cerrada');
}
