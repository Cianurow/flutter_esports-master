import 'package:aplicacion_esports/pages/jugador_agregar.dart';
import 'package:flutter/material.dart';
import 'package:aplicacion_esports/services/http_service.dart';

class DetalleEquipoScreen extends StatefulWidget {
  final int equipoId;

  DetalleEquipoScreen({required this.equipoId});

  @override
  _DetalleEquipoScreenState createState() => _DetalleEquipoScreenState();
}

class _DetalleEquipoScreenState extends State<DetalleEquipoScreen> {
  HttpService httpService = HttpService();
  List<dynamic> jugadores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarJugadores();
  }

  void _cargarJugadores() async {
    try {
      List<dynamic> response =
          await httpService.obtenerJugadoresPorEquipo(widget.equipoId);
      setState(() {
        jugadores = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar jugadores del equipo: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _eliminarJugador(String jugadorId) async {
    try {
      await httpService.eliminarJugador(jugadorId);
      // Actualizar la lista de jugadores después de eliminar uno
      _cargarJugadores();
    } catch (e) {
      print('Error al eliminar jugador: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jugadores del Equipo'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: jugadores.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      jugadores[index]['nombre'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(jugadores[index]['posicion']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmar Eliminación'),
                              content: Text(
                                  '¿Estás seguro de que deseas eliminar este jugador?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'Eliminar',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    _eliminarJugador(jugadores[index]['id']);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarJugadorScreen(equipoId: widget.equipoId),
            ),
          ).then((_) {
            // Recargar la lista de jugadores después de agregar uno nuevo
            _cargarJugadores();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
