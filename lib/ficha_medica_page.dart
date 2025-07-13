import 'package:flutter/material.dart';
import 'services/database.dart';
import 'models/user_model.dart';

class FichaMedicaPage extends StatefulWidget {
  final String userEmail;

  const FichaMedicaPage({super.key, required this.userEmail});

  @override
  State<FichaMedicaPage> createState() => _FichaMedicaPageState();
}

class _FichaMedicaPageState extends State<FichaMedicaPage> {
  late Future<UserModel?> _userFuture;
  final List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    _userFuture = getUserMedicalData(widget.userEmail);
  }

  Future<UserModel?> getUserMedicalData(String email) async {
    final userMap = await Database.getUserData(email);
    if (userMap != null) {
      return UserModel.fromMap(userMap);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EAED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2EAED),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF38353B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ficha Médica',
          style: TextStyle(
            color: Color(0xFF38353B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error al cargar los datos.'));
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildPhotoCard(user.name, user.gender),
                const SizedBox(height: 20),
                _buildInfoCard('Información Básica', [
                  _buildInfoItem('Tipo de Sangre', user.bloodType),
                  _buildInfoItem('Fecha de Nacimiento', user.birthDate),
                  _buildInfoItem('Dirección', user.address),
                ]),
                const SizedBox(height: 16),
                _buildInfoCard('Contacto de Emergencia', [
                  _buildInfoItem('Nombre y Teléfono', user.emergencyContact),
                ]),
                const SizedBox(height: 16),
                _buildInfoCard('Historial Médico', [
                  _buildInfoItem('Alergias', user.allergies.join(', ')),
                  _buildInfoItem('Condiciones Crónicas', user.chronicConditions.join(', ')),
                  _buildInfoItem('Medicamentos', user.medications.join(', ')),
                ]),
                const SizedBox(height: 24),
                _buildEditButton(), // aún no adaptamos edición dinámica
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoCard(String name, String gender) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF4C2C2), width: 2),
                image: const DecorationImage(
                  image: NetworkImage('https://baconmockup.com/250/250/'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8CBB1).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    gender,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF38353B),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF38353B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

Widget _buildInfoCard(String title, List<Widget> items) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF38353B),
            ),
          ),
          const SizedBox(height: 12), // <-- más espacio debajo del título
          const Divider(height: 20),
          ...items,
        ],
      ),
    ),
  );
}

Widget _buildInfoItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0), // más separación vertical
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF38353B),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Color(0xFF38353B)),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildEditButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB8CBB1),
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.edit, color: Color(0xFF38353B)),
        label: const Text(
          'Editar Información',
          style: TextStyle(color: Color(0xFF38353B), fontSize: 16),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Funcionalidad de edición en desarrollo')),
          );
        },
      ),
    );
  }
}
