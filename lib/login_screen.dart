import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/register_screen.dart';
import 'services/database.dart'; // Importamos el archivo de conexión

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await Database.connect();
  }

  Future<void> _loginUser() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    final user = await Database.authenticateUser(
      _emailController.text.trim(),
      _nameController.text.trim()
    );

    if (user != null) {
      if (!mounted) return;
      
      // Redirigir según el rol del usuario
      if (user['role'] == 'Adulto Mayor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(email: _emailController.text.trim()),
          ),
        );
      } else if (user['role'] == 'Cuidador') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(email: _emailController.text.trim()),
          ),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas o usuario no registrado')),
      );
    }
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al iniciar sesión. Intenta nuevamente')),
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EAED),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB8CBB1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.medical_services,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Título
                    const Text(
                      'ResQBand',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38353B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ingresa tus datos para continuar',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF38353B).withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Formulario
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Campo nombre
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nombre completo',
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
                          const SizedBox(height: 20),

                          // Campo correo
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
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
                          const SizedBox(height: 30),

                          // Botón Continuar
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
                              onPressed: _isLoading ? null : _loginUser,
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'CONTINUAR',
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
                  ],
                ),
              ),
            ),

            // Texto de registro en la parte inferior
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: const Color(0xFF38353B).withOpacity(0.7),
                      fontSize: 14,
                    ),
                    children: const [
                      TextSpan(text: '¿No tienes una cuenta? '),
                      TextSpan(
                        text: 'Regístrate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB8CBB1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}