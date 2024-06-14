import 'package:aplicacion_esports/pages/partidos_agregar.dart';
import 'package:aplicacion_esports/services/http_service.dart';
import 'package:aplicacion_esports/widgets/partidos_tile.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Partidos extends StatefulWidget {
  @override
  _PartidosState createState() => _PartidosState();
}

class _PartidosState extends State<Partidos> {
  final HttpService httpService = HttpService();
  Map<String, List<Map<String, String>>> partidosPorDia = {};

  @override
  void initState() {
    super.initState();
    fetchPartidos();
  }

  Future<void> fetchPartidos() async {
    try {
      List<dynamic> partidos = await httpService.partidos();
      Map<String, List<Map<String, String>>> groupedPartidos = {};

      for (var partido in partidos) {
        String id = partido['id'].toString();
        String fecha = partido['fecha'].split(' ')[0];
        String equipoLocal = partido['equipo_local']['nombre'];
        String equipoVisitante = partido['equipo_visitante']['nombre'];
        String lugar = partido['lugar'];
        String fechaCompleta = partido['fecha'];
        String campeonato = partido['campeonato']['nombre'].toString();

        if (!groupedPartidos.containsKey(fecha)) {
          groupedPartidos[fecha] = [];
        }

        groupedPartidos[fecha]?.add({
          'id': id,
          'equipoLocal': equipoLocal,
          'equipoVisitante': equipoVisitante,
          'fecha': fechaCompleta,
          'lugar': lugar,
          'campeonato': campeonato,
        });
      }

      setState(() {
        partidosPorDia = groupedPartidos;
      });
    } catch (e) {
      print('Error fetching partidos: $e');
    }
  }

  void recargarPartidos() {
    fetchPartidos();
    print("recargar");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: partidosPorDia.keys.length,
      child: Scaffold(
        body: partidosPorDia.isEmpty
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
                        'Calendario',
                        style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Color(0xFF037470), // Fondo rojo para el TabBar
                    child: TabBar(
                      labelColor: Colors.white, // Letra blanca
                      indicatorColor: Colors.white, // Indicador blanco
                      isScrollable: true,
                      tabs: partidosPorDia.keys.map((fecha) {
                        return Tab(text: fecha);
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: partidosPorDia.keys.map((fecha) {
                        List<Map<String, String>> partidos = partidosPorDia[fecha]!;
                        return ListView.builder(
                          itemCount: partidos.length,
                          itemBuilder: (context, index) {
                            final partido = partidos[index];
                            return PartidosTile(
                              id: partido['id']!,
                              equipoLocal: partido['equipoLocal']!,
                              equipoVisitante: partido['equipoVisitante']!,
                              fecha: partido['fecha']!,
                              lugar: partido['lugar']!,
                              campeonato: partido['campeonato']!,
                              onRecargar: recargarPartidos,
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
            MdiIcons.plus,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.blueGrey,
          onPressed: () async {
            MaterialPageRoute ruta = MaterialPageRoute(
              builder: (context) => PartidosAgregar(),
            );
            Navigator.push(context, ruta).then((value) {
              setState(() {
                fetchPartidos();
              });
            });
          },
        ),
      ),
    );
  }
}



