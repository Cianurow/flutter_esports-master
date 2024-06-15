import 'package:flutter/material.dart';
import 'package:aplicacion_esports/services/http_service.dart';
import 'package:aplicacion_esports/pages/campeonato_agregar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HttpService httpService = HttpService(); // Instancia del servicio HTTP

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  'Campeonatos',
                  style: TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              color: Color(0xFFD80100), // Color de fondo rojo
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Campeonatos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CampeonatoAgregarScreen()),
                      ).then((value) {
                        if (value == true) {
                          _cargarCampeonatos(); // Actualizar la lista de campeonatos después de agregar uno nuevo
                        }
                      });
                    },
                    child: Text('Agregar', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<dynamic>>(
              future: httpService.campeonatos(), // Llama al método para obtener campeonatos
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                  return Center(child: Text('No se encontraron campeonatos'));
                } else {
                  List<dynamic> campeonatos = snapshot.data as List<dynamic>;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: campeonatos.length,
                    itemBuilder: (context, index) {
                      var campeonato = campeonatos[index];
                      return _buildCampeonatoCard(campeonato);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampeonatoCard(Map<String, dynamic> campeonato) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  campeonato['nombre'] ?? 'Nombre no disponible',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    bool exito = await _eliminarCampeonato(campeonato['id']);
                    if (exito) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Campeonato eliminado con éxito'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _cargarCampeonatos(); // Actualizar la lista de campeonatos después de eliminar
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al eliminar el campeonato'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Reglas:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              campeonato['reglas'] ?? 'No especificadas',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              'Premios:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              campeonato['premios'] ?? 'No especificados',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 12),
            Text(
              'Fecha de inicio:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatDate(campeonato['fecha_inicio']),
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              'Fecha de término:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatDate(campeonato['fecha_termino']),
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'No especificada';
    DateTime date = DateTime.tryParse(dateStr) ?? DateTime.now();
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _cargarCampeonatos() async {
    setState(() {}); // Este setState vacío forzará a FutureBuilder a reconstruirse y recargar los campeonatos
  }

  Future<bool> _eliminarCampeonato(int? campeonatoId) async {
    if (campeonatoId == null) return false;
    bool exito = await httpService.eliminarCampeonato(campeonatoId.toString());
    return exito;
  }
}
