import 'package:flutter/material.dart';
import 'main.dart';
import 'services/database.dart';

class CaregiverLinkScreen extends StatefulWidget {
  final String email;

  const CaregiverLinkScreen({super.key, required this.email});

  @override
  State<CaregiverLinkScreen> createState() => _CaregiverLinkScreenState();
}

class _CaregiverLinkScreenState extends State<CaregiverLinkScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _linkWithElderly() async {
    if (_codeController.text.isEmpty || _codeController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un código válido')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await Database.linkUsers(
        _codeController.text.trim(),
        widget.email
      );

      if (!mounted) return;

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(email: widget.email),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código no válido o usuario no encontrado')),
        );
      }
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
      appBar: AppBar(title: const Text('Vincular con adulto mayor')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Ingresa el código de 6 dígitos del adulto mayor:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Código de vinculación',
                prefixIcon: Icon(Icons.code),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _linkWithElderly,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Vincular'),
                  ),
          ],
        ),
      ),
    );
  }
}