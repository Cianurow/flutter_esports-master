import 'package:flutter/material.dart';
import 'package:aplicacion_esports/services/http_service.dart';

class PartidoEditar extends StatefulWidget {
  final String id;
  final String equipoLocal;
  final String equipoVisitante;
  final String fecha;
  final String lugar;
  final String campeonato;

  PartidoEditar({
    required this.id,
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.fecha,
    required this.lugar,
    required this.campeonato,
  });

  @override
  _PartidoEditarState createState() => _PartidoEditarState();
}

class _PartidoEditarState extends State<PartidoEditar> {
  late TextEditingController fechaController;
  late TextEditingController lugarController;

  String? selectedEquipoLocal;
  String? selectedEquipoVisitante;
  String? selectedCampeonato;
  List<dynamic> equipos = [];
  List<dynamic> campeonatos = [];

  @override
  void initState() {
    super.initState();
    fechaController = TextEditingController(text: widget.fecha);
    lugarController = TextEditingController(text: widget.lugar);
    selectedEquipoLocal = widget.equipoLocal;
    selectedEquipoVisitante = widget.equipoVisitante;
    selectedCampeonato = widget.campeonato;
    fetchEquiposYCampeonatos();
  }
  
  Future<void> fetchEquiposYCampeonatos() async {
    try {
      List<dynamic> equiposResponse = await HttpService().equipos();
      List<dynamic> campeonatosResponse = await HttpService().campeonatos();
      setState(() {
        equipos = equiposResponse;
        campeonatos = campeonatosResponse;    
      });  
    } catch (e) {
      print('Error fetching equipos y campeonatos: $e');
    }
  }

  String? findEquipoIdFromNombre(String nombreEquipo) {
    var equipo = equipos.firstWhere((equipo) => equipo['nombre'] == nombreEquipo, orElse: () => null);
    return equipo != null ? equipo['id'].toString() : null;
  }

  String? findCampeonatoIdFromNombre(String nombreCampeonato) {
    var campeonato = campeonatos.firstWhere((campeonato) => campeonato['nombre'] == nombreCampeonato, orElse: () => null);
    return campeonato != null ? campeonato['id'].toString() : null;
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Partido', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF037470),
      ),
      body: equipos.isEmpty || campeonatos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedEquipoLocal,
                      onChanged: (value) {
                        setState(() {
                          selectedEquipoLocal = value;
                        });
                      },
                      items: equipos.map((equipo) {
                        return DropdownMenuItem<String>(
                          value: equipo['nombre'],
                          child: Text(equipo['nombre']),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'Equipo Local'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedEquipoVisitante,
                      onChanged: (value) {
                        setState(() {
                          selectedEquipoVisitante = value;
                        });
                      },
                      items: equipos.map((equipo) {
                        return DropdownMenuItem<String>(
                          value: equipo['nombre'],
                          child: Text(equipo['nombre']),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'Equipo Visitante'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCampeonato,
                      onChanged: (value) {
                        setState(() {
                          selectedCampeonato = value;
                        });
                      },
                      items: campeonatos.map((campeonato) {
                        return DropdownMenuItem<String>(
                          value: campeonato['nombre'],
                          child: Text(campeonato['nombre']),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'Campeonato'),
                    ),
                    TextField(
                      controller: fechaController,
                      decoration: InputDecoration(labelText: 'Fecha'),
                    ),
                    TextField(
                      controller: lugarController,
                      decoration: InputDecoration(labelText: 'Lugar'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        String? equipoLocalId = findEquipoIdFromNombre(selectedEquipoLocal!);
                        String? equipoVisitanteId = findEquipoIdFromNombre(selectedEquipoVisitante!);
                        String? campeonatoId = findCampeonatoIdFromNombre(selectedCampeonato!);

                        if (equipoLocalId != null && equipoVisitanteId != null && campeonatoId != null) {
                          final success = await HttpService().actualizarPartido(
                            widget.id,
                            equipoLocalId,
                            equipoVisitanteId,
                            fechaController.text,
                            lugarController.text,
                            campeonatoId,
                          );

                          if (success) {
                            // Actualización exitosa, navegamos hacia atrás
                            Navigator.pop(context);
                          } else {
                            // Manejo de errores si la actualización no fue exitosa
                            print('Error al actualizar el partido.');
                          }
                        } else {
                          // Manejo de error si no se encontraron los IDs correspondientes
                          print('No se encontró el ID correspondiente para algún equipo o campeonato.');
                        }
                      },
                      child: Text('Guardar Cambios'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    fechaController.dispose();
    lugarController.dispose();
    super.dispose();
  }
}
