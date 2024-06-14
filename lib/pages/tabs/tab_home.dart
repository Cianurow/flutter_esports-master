import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fondo1.png'), // Ruta de la imagen en assets
                  fit: BoxFit.cover, // Ajuste de la imagen dentro del contenedor
                ),
              ),
              child: Center(
                child: Text(
                  'Campeonatos',
                  style: TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  _buildButton(
                    onPressed: () => Navigator.pushNamed(context, '/'),
                    image: 'assets/clash of clans.png',
                    tournamentName: 'Clash of Clans',
                  ),
                  SizedBox(height: 50),
                  _buildButton(
                    onPressed: () => Navigator.pushNamed(context, '/'),
                    image: 'assets/dota.png',
                    tournamentName: 'DOTA',
                  ),
                  SizedBox(height: 50),
                  _buildButton(
                    onPressed: () => Navigator.pushNamed(context, '/'),
                    image: 'assets/fifa.png',
                    tournamentName: 'FIFA',
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String image,
    required String tournamentName,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: 200,
                height: 150,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 150,
          color: Colors.white,
          child: Center(
            child: Text(
              tournamentName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}