import 'package:flutter/material.dart';
import 'main.dart';
import 'services/database.dart';

class ElderlyCodeScreen extends StatefulWidget {
  final String email;

  const ElderlyCodeScreen({super.key, required this.email});

  @override
  State<ElderlyCodeScreen> createState() => _ElderlyCodeScreenState();
}

class _ElderlyCodeScreenState extends State<ElderlyCodeScreen> {
  late Future<String> _codeFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _codeFuture = Database.generateElderlyCode();
  }

Future<void> _saveCodeToDatabase(String code) async {
  setState(() => _isLoading = true);
  try {
    await Database.updateUser(
      email: widget.email,
      data: {'elderlyCode': code}
    );
  } finally {
    setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EAED),
      appBar: AppBar(title: const Text('Código generado')),
      body: FutureBuilder<String>(
        future: _codeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error al generar código'));
          }

          final code = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Tu código para vinculación es:', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Text(code, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text(
                  'Comparte este código con tu cuidador',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          await _saveCodeToDatabase(code);
                          if (!mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(email: widget.email),
                            ),
                          );
                        },
                        child: const Text('Continuar'),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}