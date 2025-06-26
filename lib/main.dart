import 'package:flutter/material.dart';
import 'package:flutter_app/safe_area_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'ficha_medica_page.dart';
import 'login_screen.dart';

void main() {
  runApp(const ResQBandApp());
}

class ResQBandApp extends StatelessWidget {
  const ResQBandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ResQBand',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFB8CBB1),
          secondary: Color(0xFFF4C2C2),
          surface: Color(0xFFF2EAED),
          onSurface: Color(0xFF38353B),
        ),
        scaffoldBackgroundColor: Color(0xFFF2EAED),
      ),
      home: const LoginScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Llamada directa
  Future<void> _makeEmergencyCall() async {
    const phoneNumber = '6142837972';
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SafeAreaMap(),
          Column(
            children: const [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: BraceletDropdown(),
                ),
              ),
              InfoCard(),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 70,
        margin: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          onPressed: _makeEmergencyCall,
          child: const Icon(Icons.emergency, size: 30, color: Colors.black),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.menu, size: 30),
              onPressed: () {},
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.medical_services, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FichaMedicaPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BraceletDropdown extends StatelessWidget {
  const BraceletDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButton<String>(
            value: 'Pulsera de Juan',
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            underline: Container(),
            onChanged: (String? newValue) {},
            items: const [
              'Pulsera de Juan',
              'Opción 1',
              'Opción 2',
              'Opción 3',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Juan Perez',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const RepaintBoundary(child: HeartBeatIcon()),
                    const SizedBox(height: 8),
                    const Text(
                      '78 BPM',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Ritmo Cardíaco',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 80,
                  color: Colors.grey[300],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 40,
                      color: Color(0xFFD66D75),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '12:45 PM',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Última actualización',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HeartBeatIcon extends StatefulWidget {
  const HeartBeatIcon({super.key});

  @override
  State<HeartBeatIcon> createState() => _HeartBeatIconState();
}

class _HeartBeatIconState extends State<HeartBeatIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: const Icon(
            FontAwesomeIcons.solidHeart,
            color: Color(0xFFD66D75),
            size: 40,
          ),
        );
      },
    );
  }
}
