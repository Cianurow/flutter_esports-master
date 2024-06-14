import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(32),
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Enrique',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/perfil.png', // Cambia esto por el nombre de tu imagen
                  width: 100,
                  height: 100,
                ),
                 SizedBox(height: 20),
                Text(
                  '"La victoria no siempre es para el más fuerte, sino para el que persevera."',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Estadísticas Generales',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '500',
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                        Text(
                          'Victorias',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '150',
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                        Text(
                          'Derrotas',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '10',
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                        Text(
                          'Campeonatos',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                const Divider(color: Colors.black,),
                SizedBox(height: 20),
                Text(
                  'Información Personal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Nombre: Enrique Sanhueza',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                SizedBox(height: 10),
                Text(
                  'Correo: esanhueza@usm.cl',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                SizedBox(height: 10),
                Text(
                  'Edad: 21',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                SizedBox(height: 20),
                const Divider(color: Colors.black,),
                SizedBox(height: 20),
                Text(
                  'Equipos Favoritos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      '- Team Alpha',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    Text(
                      '- Team Bravo',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    Text(
                      '- Team Charlie',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                const Divider(color: Colors.black,),
                SizedBox(height: 20),
                Text(
                  'Posiciones Preferidas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      '- Ataque',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    Text(
                      '- Defensa',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    Text(
                      '- Soporte',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                const Divider(color: Colors.black,),
                SizedBox(height: 20),
                Text(
                  'Juegos Favoritos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      '- League of Legends',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    Text(
                      '- Counter Strike',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    Text(
                      '- Dota 2',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
