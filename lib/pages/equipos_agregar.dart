import 'package:flutter/material.dart';
import 'package:aplicacion_esports/services/http_service.dart';

class EquiposAgregar extends StatefulWidget {
  @override
  _EquiposAgregarState createState() => _EquiposAgregarState();
}

class _EquiposAgregarState extends State<EquiposAgregar> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String juegos = '';

  HttpService httpService = HttpService();

  void _agregarEquipo() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Lógica para agregar el equipo usando HttpService
      var response = await httpService.agregarEquipo(nombre, juegos);
      if (response) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al agregar equipo'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Equipo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Equipo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del equipo';
                  }
                  return null;
                },
                onSaved: (value) {
                  nombre = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Juego'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del juego';
                  }
                  return null;
                },
                onSaved: (value) {
                  juegos = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarEquipo,
                child: Text('Agregar Equipo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
