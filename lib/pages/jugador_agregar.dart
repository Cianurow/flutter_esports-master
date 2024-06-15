import 'package:flutter/material.dart';
import 'package:aplicacion_esports/services/http_service.dart';

class AgregarJugadorScreen extends StatefulWidget {
  final int equipoId;

  AgregarJugadorScreen({required this.equipoId});

  @override
  _AgregarJugadorScreenState createState() => _AgregarJugadorScreenState();
}

class _AgregarJugadorScreenState extends State<AgregarJugadorScreen> {
  HttpService httpService = HttpService();
  TextEditingController rutController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController posicionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nuevo Jugador'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: rutController,
                decoration: InputDecoration(labelText: 'RUT'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el RUT';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: apellidoController,
                decoration: InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: posicionController,
                decoration: InputDecoration(labelText: 'Posición'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese la posición';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // Llamar al servicio para agregar el jugador
                    var response = await httpService.agregarJugador(
                      rutController.text,
                      nombreController.text,
                      apellidoController.text,
                      posicionController.text,
                      widget.equipoId,
                    );

                    if (response) {
                      // Mostrar mensaje de éxito o navegación de vuelta a la pantalla anterior
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Jugador agregado correctamente'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pop(context); // Volver a la pantalla anterior
                    } else {
                      // Mostrar mensaje de error si falla la creación
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al agregar el jugador'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                child: Text('Agregar Jugador'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
