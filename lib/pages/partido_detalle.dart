import 'package:aplicacion_esports/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PartidoDetalle extends StatefulWidget {
  final String id;

  PartidoDetalle({required this.id});

  @override
  _PartidoDetalleState createState() => _PartidoDetalleState();
}

class _PartidoDetalleState extends State<PartidoDetalle> {
  late Future<Map<String, dynamic>> _partidoFuture;
  bool _editandoResultados = false;
  TextEditingController _puntuacionGanadorController = TextEditingController();
  TextEditingController _puntuacionPerdedorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _partidoFuture = _fetchPartido();
  }

  Future<Map<String, dynamic>> _fetchPartido() async {
    try {
      return await HttpService().obtenerPartido(widget.id);
    } catch (e) {
      print('Error fetching partido details: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Partido', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF037470),
      ),
      backgroundColor: Color.fromARGB(255, 127, 206, 130),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _partidoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No se encontraron datos'));
          } else {
            var partido = snapshot.data!;
            var jugado = partido['jugado'] == 1;
            var resultados = partido['resultado'];

            if (_editandoResultados && resultados != null) {
              _puntuacionGanadorController.text =
                  resultados['puntuacion_ganador'].toString();
              _puntuacionPerdedorController.text =
                  resultados['puntuacion_perdedor'].toString();
            } else {
              _puntuacionGanadorController.clear();
              _puntuacionPerdedorController.clear();
            }

            return Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.elliptical(130, 100)),
                      image: DecorationImage(
                          image: AssetImage('assets/resultado.jpg'),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDetailRow(
                            'Equipo Local:', partido['equipo_local']['nombre']),
                        _buildDetailRow('Equipo Visitante:',
                            partido['equipo_visitante']['nombre']),
                        _buildDetailRow(
                            'Fecha:',
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(DateTime.parse(partido['fecha']))),
                        _buildDetailRow('Lugar:', partido['lugar']),
                        _buildDetailRow(
                            'Campeonato:', partido['campeonato']['nombre']),
                        _buildDetailRow('Jugado:', jugado ? 'Sí' : 'No'),
                      ],
                    ),
                  ),
                  if (jugado && resultados != null) ...[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.elliptical(130, 100),
                          bottomLeft: Radius.elliptical(130, 100),
                        ),
                        image: DecorationImage(
                            image: AssetImage('assets/resultadopartido.jpg'),
                            fit: BoxFit.cover),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'Resultados:',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Divider(),
                          SizedBox(height: 4),
                          _buildResultRow(
                            partido['equipo_local_id'] ==
                                    resultados['equipo_ganador_id']
                                ? partido['equipo_local']['nombre']
                                : partido['equipo_visitante']['nombre'],
                            resultados['puntuacion_ganador'].toString(),
                            partido['equipo_local_id'] ==
                                    resultados['equipo_ganador_id']
                                ? partido['equipo_visitante']['nombre']
                                : partido['equipo_local']['nombre'],
                            resultados['puntuacion_perdedor'].toString(),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _editandoResultados = true;
                              });
                            },
                            child: Text('Editar Resultados'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              var eliminarExito = await HttpService()
                                  .eliminarResultado(
                                      partido['resultado']['id'].toString());
                              var actualizarExito = await HttpService()
                                  .actualizarPartidoJugado(widget.id, 0);

                              if (eliminarExito && actualizarExito) {
                                setState(() {
                                  _partidoFuture = _fetchPartido();
                                  _editandoResultados = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Resultados eliminados')),
                                );
                                _refreshPartido();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Error al eliminar los resultados')),
                                );
                              }
                            },
                            child: Text('Eliminar Resultados'),
                          ),
                        ],
                      ),
                    ),
                  ] else if (!jugado && resultados == null) ...[
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _editandoResultados = true;
                        });
                      },
                      child: Text('Agregar Resultados'),
                    ),
                  ],
                  if (_editandoResultados) ...[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(130, 100),
                            bottomRight: Radius.elliptical(130, 100)),
                        image: DecorationImage(
                            image: AssetImage('assets/resultado.jpg'),
                            fit: BoxFit.cover),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          _buildEditField(
                            controller: _puntuacionGanadorController,
                            labelText:
                                'Puntuación ${partido['equipo_local']['nombre']}',//ganados o vs
                          ),
                          _buildEditField(
                            controller: _puntuacionPerdedorController,
                            labelText:
                                'Puntuación ${partido['equipo_visitante']['nombre']}',//perdedors o vs
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              if (resultados == null) {
                            
                                String equipoGanadorId = partido[
                                        'equipo_local_id']
                                    .toString(); 
                                String equipoPerdedorId = partido[
                                        'equipo_visitante_id']
                                    .toString(); 
                                var exitoCrear =
                                    await HttpService().crearResultado(
                                  partido['id'].toString(),
                                  _puntuacionGanadorController.text,
                                  _puntuacionPerdedorController.text,
                                  equipoGanadorId,
                                  equipoPerdedorId,
                                );

                                if (exitoCrear) {
                                  var exitoActualizar = await HttpService()
                                      .actualizarPartidoJugado(
                                          partido['id'].toString(), 1);
                                  if (exitoActualizar) {
                                    setState(() {
                                      _partidoFuture = _fetchPartido();
                                      _editandoResultados = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Resultados agregados y partido actualizado')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Error al actualizar el partido')),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Error al agregar los resultados')),
                                  );
                                }
                              } else {
                                // Update the existing result
                                var exito =
                                    await HttpService().actualizarResultado(
                                  widget.id,
                                  _puntuacionGanadorController.text,
                                  _puntuacionPerdedorController.text,
                                  partido['id'].toString(),
                                  partido['equipo_local_id'].toString(),
                                  partido['equipo_visitante_id'].toString(),
                                );

                                if (exito) {
                                  var exitoActualizar = await HttpService()
                                      .actualizarPartidoJugado(
                                          partido['id'].toString(), 1);
                                  if (exitoActualizar) {
                                    setState(() {
                                      _partidoFuture = _fetchPartido();
                                      _editandoResultados = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Resultados actualizados')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Error al actualizar el partido')),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Error al actualizar los resultados')),
                                  );
                                }
                              }
                            },
                            child: Text('Guardar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _refreshPartido() {
    setState(() {
      _partidoFuture = _fetchPartido();
    });
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(
    String ganadorNombre,
    String ganadorPuntuacion,
    String perdedorNombre,
    String perdedorPuntuacion,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 4),
                Text(ganadorNombre.split(' ')[0],
                    style: TextStyle(fontSize: 24, color: Colors.white)),
                Text(ganadorNombre.split(' ')[1],
                    style: TextStyle(fontSize: 24, color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 4),
                Text(
                  ganadorPuntuacion + ' - ' + perdedorPuntuacion,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(perdedorNombre.split(' ')[0],
                    style: TextStyle(fontSize: 24, color: Colors.white)),
                Text(perdedorNombre.split(' ')[1],
                    style: TextStyle(fontSize: 24, color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEditField(
      {required TextEditingController controller, required String labelText}) {
    return Center(
      child: Container(
        width: 300,
        child: TextFormField(
          controller: controller,
          style: TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(fontSize: 24, color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 3.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 3.0,
              ),
            ),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
