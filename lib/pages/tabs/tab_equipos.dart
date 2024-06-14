import 'package:aplicacion_esports/pages/pantalla_jugadores.dart';
import 'package:aplicacion_esports/services/http_service.dart';
import 'package:flutter/material.dart';

class Equipos extends StatefulWidget {
  @override
  _EquiposState createState() => _EquiposState();
}

class _EquiposState extends State<Equipos> {
  HttpService httpService = HttpService();
  Map<String, List<dynamic>> equiposPorJuego = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarEquipos();
  }

  void _cargarEquipos() async {
  try {
    List<dynamic> response = await httpService.equipos();
    
    // Agrupar equipos por juego
    Map<String, List<dynamic>> groupedEquipos = {};

    for (var equipo in response) {
      if (equipo.containsKey('juegos')) {
        String juego = equipo['juegos'];

        if (!groupedEquipos.containsKey(juego)) {
          groupedEquipos[juego] = [];
        }

        groupedEquipos[juego]?.add(equipo);
      } else {
        print('Equipo sin juego definido: $equipo');
      }
    }

    // Impresión de depuración para verificar la agrupación
    groupedEquipos.forEach((juego, equipos) {
      print('Juego: $juego - Cantidad de Equipos: ${equipos.length}');
    });

    setState(() {
      equiposPorJuego = groupedEquipos;
      isLoading = false;
    });
  } catch (e) {
    print('Error al obtener equipos: $e');
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: equiposPorJuego.keys.length,
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/fondo1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Equipos',
                        style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Color(0xFFFF8B00), 
                    child: TabBar(
                      labelColor: Colors.white,
                      indicatorColor: Colors.white,
                      isScrollable: true,
                      tabs: equiposPorJuego.keys.map((juego) {
                        return Tab(text: juego);
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: equiposPorJuego.keys.map((juego) {
                        List<dynamic> equipos = equiposPorJuego[juego]!;
                        return ListView.builder(
                          itemCount: equipos.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalleEquipoScreen(
                                      equipoId: equipos[index]['id'],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 5,
                                margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Colors.orange.shade100, Colors.orange.shade200],
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    title: Text(
                                      equipos[index]['nombre'],
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    subtitle: Text(
                                      equipos[index]['juegos'],
                                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.orange),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
