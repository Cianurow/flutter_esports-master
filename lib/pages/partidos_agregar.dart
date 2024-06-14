import 'package:aplicacion_esports/services/http_service.dart';
import 'package:flutter/material.dart';

class PartidosAgregar extends StatefulWidget {
  const PartidosAgregar({Key? key}) : super(key: key);

  @override
  _PartidosAgregarState createState() => _PartidosAgregarState();
}

class _PartidosAgregarState extends State<PartidosAgregar> {
  TextEditingController fechaController = TextEditingController();
  TextEditingController lugarController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  int? equipoLocalSeleccionado;
  int? equipoVisitanteSeleccionado;
  int? campeonatoSeleccionado;

  String errFecha = "";
  String errLugar = "";
  String errEquipoLocal = "";
  String errEquipoVisitante = "";
  String errCampeonato = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nuevo Partido'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              // Fecha
              TextFormField(
                decoration: InputDecoration(labelText: 'Fecha (YYYY-MM-DD HH:mm)'),
                controller: fechaController,
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese una fecha';
                  }
                  return null;
                },
              ),
              Text(errFecha, style: TextStyle(color: Colors.red)),
              // Lugar
              TextFormField(
                decoration: InputDecoration(labelText: 'Lugar'),
                controller: lugarController,
              ),
              Text(errLugar, style: TextStyle(color: Colors.red)),
              // Equipo Local
              FutureBuilder(
                future: HttpService().equipos(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Cargando equipos...');
                  }
                  List<dynamic> equipos = snapshot.data;
                  equipoLocalSeleccionado = equipoLocalSeleccionado ?? equipos[0]['id'];
                  return DropdownButtonFormField<int>(
                    value: equipoLocalSeleccionado,
                    items: equipos.map<DropdownMenuItem<int>>((equipo) {
                      return DropdownMenuItem<int>(
                        child: Text(equipo['nombre']),
                        value: equipo['id'],
                      );
                    }).toList(),
                    onChanged: (opcionSeleccionada) {
                      setState(() {
                        equipoLocalSeleccionado = opcionSeleccionada!;
                      });
                    },
                  );
                },
              ),
              Text(errEquipoLocal, style: TextStyle(color: Colors.red)),
              // Equipo Visitante
              FutureBuilder(
                future: HttpService().equipos(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Cargando equipos...');
                  }
                  List<dynamic> equipos = snapshot.data;
                  equipoVisitanteSeleccionado = equipoVisitanteSeleccionado ?? equipos[0]['id'];
                  return DropdownButtonFormField<int>(
                    value: equipoVisitanteSeleccionado,
                    items: equipos.map<DropdownMenuItem<int>>((equipo) {
                      return DropdownMenuItem<int>(
                        child: Text(equipo['nombre']),
                        value: equipo['id'],
                      );
                    }).toList(),
                    onChanged: (opcionSeleccionada) {
                      setState(() {
                        equipoVisitanteSeleccionado = opcionSeleccionada!;
                      });
                    },
                  );
                },
              ),
              Text(errEquipoVisitante, style: TextStyle(color: Colors.red)),
              // Campeonato
              FutureBuilder(
                future: HttpService().campeonatos(), // Método para obtener campeonatos
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Cargando campeonatos...');
                  }
                  List<dynamic> campeonatos = snapshot.data;
                  campeonatoSeleccionado = campeonatoSeleccionado ?? campeonatos[0]['id'];
                  return DropdownButtonFormField<int>(
                    value: campeonatoSeleccionado,
                    items: campeonatos.map<DropdownMenuItem<int>>((campeonato) {
                      return DropdownMenuItem<int>(
                        child: Text(campeonato['nombre']),
                        value: campeonato['id'],
                      );
                    }).toList(),
                    onChanged: (opcionSeleccionada) {
                      setState(() {
                        campeonatoSeleccionado = opcionSeleccionada!;
                      });
                    },
                  );
                },
              ),
              Text(errCampeonato, style: TextStyle(color: Colors.red)),
              // Botón
              Container(
                margin: EdgeInsets.only(top: 20),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    //backgroundColor: Color(kSecondaryColor),
                  ),
                  child: Text('Agregar Partido'),
                  onPressed: () async {
                    
                    var respuesta = await HttpService().agregarPartido(
                      fechaController.text,
                      lugarController.text,
                      equipoLocalSeleccionado!,
                      equipoVisitanteSeleccionado!,
                      campeonatoSeleccionado!,
                    );
                    

                    if (respuesta['message'] != null) {
                      var errores = respuesta['errors'];
                      setState(() {
                        errFecha = errores['fecha'] != null ? errores['fecha'][0] : '';
                        errLugar = errores['lugar'] != null ? errores['lugar'][0] : '';
                        errEquipoLocal = errores['equipo_local'] != null ? errores['equipo_local'][0] : '';
                        errEquipoVisitante = errores['equipo_visitante'] != null ? errores['equipo_visitante'][0] : '';
                        errCampeonato = errores['campeonato'] != null ? errores['campeonato'][0] : '';
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}