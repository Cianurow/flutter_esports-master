import 'package:aplicacion_esports/pages/equipos_agregar.dart';
import 'package:aplicacion_esports/pages/pantalla_jugadores.dart';
import 'package:flutter/material.dart';
import 'package:aplicacion_esports/services/http_service.dart';

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
        String juego = equipo['juegos'];

        if (!groupedEquipos.containsKey(juego)) {
          groupedEquipos[juego] = [];
        }

        groupedEquipos[juego]?.add(equipo);
      }

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

  void _eliminarEquipo(String id) async {
    bool confirmado = await _mostrarDialogoConfirmacion();
    if (confirmado) {
      bool success = await httpService.eliminarEquipo(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        
          content: Text('Equipo eliminado exitosamente'),
        ));
        _cargarEquipos();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al eliminar el equipo'),
        ));
      }
    }
  }

  Future<bool> _mostrarDialogoConfirmacion() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 212, 212, 212),
          title: Text('Confirmación'),
          content: Text('¿Estás seguro de que deseas eliminar este equipo?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                                backgroundColor: Colors.white),
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 230, 230, 230)),
              child: Text('Eliminar', style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  void recargarEquipos() {
    _cargarEquipos();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: equiposPorJuego.keys.length,
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
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
                    color: Colors.orange, // Fondo naranja para el TabBar
                    child: TabBar(
                      labelColor: Colors.white, // Letra blanca
                      indicatorColor: Colors.white, // Indicador blanco
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
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _eliminarEquipo(equipos[index]['id'].toString());
                                      },
                                    ),
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
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.blueGrey,
          onPressed: () async {
            MaterialPageRoute ruta = MaterialPageRoute(
              builder: (context) => EquiposAgregar(),
            );
            Navigator.push(context, ruta).then((value) {
              setState(() {
                _cargarEquipos();
              });
            });
          },
        ),
      ),
    );
  }
}
