import 'package:flutter/material.dart';
import 'package:aplicacion_esports/services/http_service.dart';
import 'package:aplicacion_esports/pages/campeonato_agregar.dart';

class CampeonatoAgregarScreen extends StatefulWidget {
  const CampeonatoAgregarScreen({Key? key}) : super(key: key);

  @override
  _CampeonatoAgregarScreenState createState() => _CampeonatoAgregarScreenState();
}

class _CampeonatoAgregarScreenState extends State<CampeonatoAgregarScreen> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController fechaInicioController = TextEditingController();
  TextEditingController fechaTerminoController = TextEditingController();
  TextEditingController reglasController = TextEditingController();
  TextEditingController premiosController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nuevo Campeonato'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              // Nombre del Campeonato
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Campeonato'),
                controller: nombreController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el nombre del campeonato';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),

              // Fecha de Inicio
              TextFormField(
                decoration: InputDecoration(labelText: 'Fecha de Inicio (YYYY-MM-DD)'),
                controller: fechaInicioController,
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese la fecha de inicio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),

              // Fecha de Término
              TextFormField(
                decoration: InputDecoration(labelText: 'Fecha de Término (YYYY-MM-DD)'),
                controller: fechaTerminoController,
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese la fecha de término';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),

              // Reglas
              TextFormField(
                decoration: InputDecoration(labelText: 'Reglas'),
                controller: reglasController,
                maxLines: 3,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese las reglas del campeonato';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),

              // Premios (nombre y cantidad)
              TextFormField(
                decoration: InputDecoration(labelText: 'Premios (nombre y cantidad)'),
                controller: premiosController,
                maxLines: 3,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese los premios del campeonato';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),

              // Botón
              Container(
                margin: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Color(kSecondaryColor),
                  ),
                  child: Text('Agregar Campeonato'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      var response = await HttpService().agregarCampeonato(
                        nombreController.text,
                        fechaInicioController.text,
                        fechaTerminoController.text,
                        reglasController.text,
                        premiosController.text,
                      );

                      if (response['error'] != null) {
                        // Manejar el error, mostrar mensaje al usuario
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al agregar campeonato: ${response['error']}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        // Éxito al agregar el campeonato
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Campeonato agregado con éxito'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // Volver a la pantalla anterior y actualizar la lista de campeonatos
                        Navigator.pop(context, true); // Enviamos true para indicar que se agregó un campeonato
                      }
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
