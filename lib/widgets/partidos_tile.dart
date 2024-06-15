import 'package:aplicacion_esports/pages/partido_detalle.dart';
import 'package:aplicacion_esports/pages/partido_editar.dart';
import 'package:flutter/material.dart';
import 'package:aplicacion_esports/services/http_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PartidosTile extends StatefulWidget {
  final String id;
  final String equipoLocal;
  final String equipoVisitante;
  final String fecha;
  final String lugar;
  final String campeonato;
  final VoidCallback onRecargar;

  PartidosTile({
    required this.id,
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.fecha,
    required this.lugar,
    required this.campeonato,
    required this.onRecargar,
  });

  @override
  State<PartidosTile> createState() => _PartidosTileState();
}

class _PartidosTileState extends State<PartidosTile> {
  String _extractHour(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return DateFormat('HH:mm').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    String hora = _extractHour(widget.fecha);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 212, 212, 212),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 17, 26, 31),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            padding: const EdgeInsets.only(left: 80, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hora,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  widget.lugar,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/partidos.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      widget.equipoLocal.split(' ')[0],
                      style: GoogleFonts.oxanium(
                        textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      widget.equipoLocal.split(' ')[1],
                      style: GoogleFonts.oxanium(
                        textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      widget.equipoVisitante.split(' ')[0],
                      style: GoogleFonts.oxanium(
                        textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      widget.equipoVisitante.split(' ')[1],
                      style: GoogleFonts.oxanium(
                        textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 17, 26, 31),
                  fixedSize: Size(100, 40),
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PartidoEditar(
                                id: widget.id,
                                equipoLocal: widget.equipoLocal,
                                equipoVisitante: widget.equipoVisitante,
                                fecha: widget.fecha,
                                lugar: widget.lugar,
                                campeonato: widget.campeonato,
                              ))).then((value) {
                    setState(() {
                      widget.onRecargar();
                    });
                  });
                },
                child: Text('Editar'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 17, 26, 31),
                  fixedSize: Size(100, 40),
                ),
                onPressed: () {
                  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PartidoDetalle(id: widget.id),
                ),
              );
                },
                child: Text(
                  'Resultado',
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 17, 26, 31),
                  fixedSize: Size(100, 40),
                ),
                onPressed: () async {
                  bool confirmarEliminacion = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color.fromARGB(255, 212, 212, 212),
                        title: Text('Confirmar Eliminación'),
                        content: Text(
                            '¿Estás seguro de que deseas eliminar este partido?'),
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
                            child: Text(
                              'Eliminar',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmarEliminacion == true) {
                    bool borradoOK = await HttpService().eliminarPartido(widget.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          borradoOK ? 'Partido eliminado exitosamente' : 'Error al eliminar el partido',
                        ),
                      ),
                    );
                    if (borradoOK) {
                      widget.onRecargar();
                    }
                  }
                },
                child: Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
