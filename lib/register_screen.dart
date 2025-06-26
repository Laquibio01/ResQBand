import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'services/database.dart'; // Importa el archivo de conexión

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _chronicConditionsController = TextEditingController();
  final _medicationsController = TextEditingController();

  String? _userType; // 'caregiver' o 'elderly'
  String? _selectedGender;
  String? _selectedBloodType;
  DateTime? _selectedDate;
  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await Database.connect();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFB8CBB1),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (_userType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un tipo de usuario')),
      );
      return;
    }
    if (_userType == 'elderly' && (_selectedGender == null || _selectedBloodType == null || _selectedDate == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos obligatorios')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Verificar si el email ya existe
    final emailExists = await Database.emailExists(_emailController.text.trim());
    if (emailExists) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este correo electrónico ya está registrado')),
      );
      return;
    }

    // Preparar datos del usuario
    final now = DateTime.now().toUtc();
    final userData = <String, dynamic>{
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'role': _userType == 'caregiver' ? 'Cuidador' : 'Adulto Mayor',
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    };

    // Añadir campos específicos para adultos mayores
    if (_userType == 'elderly') {
      userData.addAll(<String, dynamic>{
        'gender': _selectedGender ?? '', // Proporciona un valor por defecto si es null
        'bloodType': _selectedBloodType ?? '', // Proporciona un valor por defecto si es null
        'birthDate': _selectedDate?.toIso8601String(),
        'address': _addressController.text.trim(),
        'emergencyContact': {
          'phone': _emergencyContactController.text.trim(),
        },
        'allergies': _allergiesController.text.trim().isNotEmpty
            ? _allergiesController.text.trim().split(',')
            : <String>[],
        'chronicConditions': _chronicConditionsController.text.trim().isNotEmpty
            ? _chronicConditionsController.text.trim().split(',')
            : <String>[],
        'medications': _medicationsController.text.trim().isNotEmpty
            ? _medicationsController.text.trim().split(',')
            : <String>[],
      });
    }

    // Insertar usuario en la base de datos
    final success = await Database.insertUser(userData);
    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrar. Intenta nuevamente')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EAED),
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: const Color(0xFFB8CBB1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tipo de usuario
              const Text(
                'Tipo de usuario*',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38353B),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Cuidador'),
                      selected: _userType == 'caregiver',
                      onSelected: (bool selected) {
                        setState(() {
                          _userType = selected ? 'caregiver' : null;
                        });
                      },
                      selectedColor: const Color(0xFFB8CBB1),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: _userType == 'caregiver' ? Colors.white : const Color(0xFF38353B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Adulto Mayor'),
                      selected: _userType == 'elderly',
                      onSelected: (bool selected) {
                        setState(() {
                          _userType = selected ? 'elderly' : null;
                        });
                      },
                      selectedColor: const Color(0xFFB8CBB1),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: _userType == 'elderly' ? Colors.white : const Color(0xFF38353B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Campos comunes
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre completo*',
                  prefixIcon: const Icon(Icons.person, color: Color(0xFFB8CBB1)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Ingresa tu nombre' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico*',
                  prefixIcon: const Icon(Icons.email, color: Color(0xFFB8CBB1)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Ingresa tu correo';
                  if (!value.contains('@')) return 'Correo no válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campos específicos para adulto mayor
              if (_userType == 'elderly') ...[
                const SizedBox(height: 16),
                const Text(
                  'Información médica',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF38353B),
                  ),
                ),
                const SizedBox(height: 16),

                // Selector de Género
                const Text(
                  'Género*',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF38353B),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Masculino'),
                        value: 'Masculino',
                        groupValue: _selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        activeColor: const Color(0xFFB8CBB1),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Femenino'),
                        value: 'Femenino',
                        groupValue: _selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        activeColor: const Color(0xFFB8CBB1),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),

                // Selector de Tipo de Sangre
                const SizedBox(height: 8),
                const Text(
                  'Tipo de sangre*',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF38353B),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedBloodType,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  items: _bloodTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBloodType = newValue;
                    });
                  },
                  validator: _userType == 'elderly'
                      ? (value) => value == null ? 'Selecciona tu tipo de sangre' : null
                      : null,
                  hint: const Text('Selecciona tu tipo de sangre'),
                ),

                // Selector de Fecha de Nacimiento
                const SizedBox(height: 16),
                const Text(
                  'Fecha de nacimiento*',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF38353B),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : 'Selecciona tu fecha',
                          style: TextStyle(
                            color: _selectedDate != null ? Colors.black : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Resto de campos
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Dirección*',
                    prefixIcon: const Icon(Icons.home, color: Color(0xFFB8CBB1)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: _userType == 'elderly'
                      ? (value) => value!.isEmpty ? 'Ingresa tu dirección' : null
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emergencyContactController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Contacto de emergencia*',
                    prefixIcon: const Icon(Icons.emergency, color: Color(0xFFB8CBB1)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: _userType == 'elderly'
                      ? (value) => value!.isEmpty ? 'Ingresa un contacto de emergencia' : null
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _allergiesController,
                  decoration: InputDecoration(
                    labelText: 'Alergias (separadas por coma)',
                    prefixIcon: const Icon(Icons.warning, color: Color(0xFFB8CBB1)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _chronicConditionsController,
                  decoration: InputDecoration(
                    labelText: 'Condiciones crónicas',
                    prefixIcon: const Icon(Icons.healing, color: Color(0xFFB8CBB1)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _medicationsController,
                  decoration: InputDecoration(
                    labelText: 'Medicamentos',
                    prefixIcon: const Icon(Icons.medication, color: Color(0xFFB8CBB1)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Botón de registro
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4C2C2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _registerUser,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'REGISTRARSE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _allergiesController.dispose();
    _chronicConditionsController.dispose();
    _medicationsController.dispose();
    Database.close();
    super.dispose();
  }
}