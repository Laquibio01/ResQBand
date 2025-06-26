import 'package:flutter/material.dart';

class FichaMedicaPage extends StatefulWidget {
  const FichaMedicaPage({super.key});

  @override
  State<FichaMedicaPage> createState() => _FichaMedicaPageState();
}

class _FichaMedicaPageState extends State<FichaMedicaPage> {
  // Datos del paciente
  String name = "María González";
  String gender = "Femenino";
  String bloodType = "O+";
  String birthDate = "15/04/1985";
  String address = "Av. Principal 456, Ciudad";
  String emergencyContact = "Juan González - 555-123-4567";
  String allergies = "Penicilina, Nueces";
  String chronicConditions = "Hipertensión";
  String medications = "Losartán 50mg, 1x día";

  final List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPhotoCard(),
            const SizedBox(height: 20),
            _buildInfoCard('Información Básica', [
              _buildInfoItem('Tipo de Sangre', bloodType),
              _buildInfoItem('Fecha de Nacimiento', birthDate),
              _buildInfoItem('Dirección', address),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard('Contacto de Emergencia', [
              _buildInfoItem('Nombre y Teléfono', emergencyContact),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard('Historial Médico', [
              _buildInfoItem('Alergias', allergies),
              _buildInfoItem('Condiciones Crónicas', chronicConditions),
              _buildInfoItem('Medicamentos', medications),
            ]),
            const SizedBox(height: 24),
            _buildEditButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCard() {
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
            const Divider(height: 20),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF38353B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
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
        onPressed: () => _showEditDialog(context),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: name);
    final addressController = TextEditingController(text: address);
    final emergencyController = TextEditingController(text: emergencyContact);
    final allergiesController = TextEditingController(text: allergies);
    final conditionsController = TextEditingController(text: chronicConditions);
    final medicationsController = TextEditingController(text: medications);

    String tempGender = gender;
    String tempBlood = bloodType;
    String tempBirth = birthDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Editar Información Médica'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Masculino',
                          groupValue: tempGender,
                          onChanged: (v) => setDialogState(() => tempGender = v!),
                          activeColor: const Color(0xFFB8CBB1),
                        ),
                        const Text('Masculino'),
                        Radio<String>(
                          value: 'Femenino',
                          groupValue: tempGender,
                          onChanged: (v) => setDialogState(() => tempGender = v!),
                          activeColor: const Color(0xFFB8CBB1),
                        ),
                        const Text('Femenino'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: tempBlood,
                      decoration: const InputDecoration(labelText: 'Tipo de Sangre'),
                      items: bloodTypes
                          .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                          .toList(),
                      onChanged: (v) => setDialogState(() => tempBlood = v!),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setDialogState(() => tempBirth =
                              '${picked.day}/${picked.month}/${picked.year}');
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Fecha de Nacimiento'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(tempBirth),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: 'Dirección'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emergencyController,
                      decoration: const InputDecoration(labelText: 'Contacto de Emergencia'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: allergiesController,
                      decoration: const InputDecoration(labelText: 'Alergias'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: conditionsController,
                      decoration: const InputDecoration(labelText: 'Condiciones Crónicas'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: medicationsController,
                      decoration: const InputDecoration(labelText: 'Medicamentos'),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB8CBB1)),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      name = nameController.text;
                      gender = tempGender;
                      bloodType = tempBlood;
                      birthDate = tempBirth;
                      address = addressController.text;
                      emergencyContact = emergencyController.text;
                      allergies = allergiesController.text;
                      chronicConditions = conditionsController.text;
                      medications = medicationsController.text;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Información actualizada')),
                    );
                  }
                },
                child: const Text('Guardar', style: TextStyle(color: Color(0xFF38353B))),
              ),
            ],
          );
        },
      ),
    );
  }
}
