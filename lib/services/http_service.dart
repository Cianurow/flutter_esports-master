import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  final String apiUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> partidos() async {
    return listarDatos('partidos');
  }

  Future<List<dynamic>> equipos() async {
    return listarDatos('equipos');
  }

  Future<List<dynamic>> campeonatos() async {
    return listarDatos('campeonatos');
  }

  Future<List<dynamic>> listarDatos(String coleccion) async {
    var respuesta = await http.get(Uri.parse(apiUrl + '/' + coleccion));

    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    }
    print(respuesta.statusCode);
    return [];
  }

  //Partido

  Future<bool> actualizarPartido(
      String id,
      String equipoLocal,
      String equipoVisitante,
      String fecha,
      String lugar,
      String campeonato) async {
    final url = '$apiUrl/partidos/$id';
    print(url);
    final response = await http.put(
      Uri.parse(url),
      body: {
        'equipo_local_id': equipoLocal,
        'equipo_visitante_id': equipoVisitante,
        'fecha': fecha,
        'lugar': lugar,
        'campeonato_id': campeonato,
      },
    );

    if (response.statusCode == 200) {
      print('Partido actualizado exitosamente');
      return true;
    } else {
      print('Error al actualizar el partido: ${response.statusCode}');
      return false;
    }
  }

  Future<Map<String, dynamic>> obtenerPartido(String id) async {
    final response = await http.get(Uri.parse('$apiUrl/partidos/$id'));
    print(id);
    if (response.statusCode == 200) {
      return json.decode(response.body); // Devuelve los detalles del partido como un mapa
    } else {
      throw Exception('Failed to load partido');
    }
  }

  Future<bool> eliminarPartido(String id) async {
    final url = '$apiUrl/partidos/$id'; 
    print(url);
    print(id);
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      // Éxito
      print('Partido eliminado con éxito');
      return true;
    } else {
      print('Error al actualizar el partido: ${response.statusCode}');
      return false;
    }
  }

  Future<LinkedHashMap<String, dynamic>> agregarPartido(String fecha, String lugar, int equipoLocal, int equipoVisitante, int campeonato) async {
    var url = Uri.parse('$apiUrl/partidos');
    var respuesta = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Accept': 'application/json'},
      body: json.encode(<String, dynamic>{
        'fecha': fecha,
        'lugar': lugar,
        'equipo_local_id': equipoLocal.toString(),
        'equipo_visitante_id': equipoVisitante.toString(),
        'campeonato_id': campeonato.toString(),
      }),
    );
    return json.decode(respuesta.body);
  }


  //Resultado

  Future<bool> crearResultado(String partidoId, String puntuacionGanador, String puntuacionPerdedor, String equipoGanadorId, String equipoPerdedorId) async {
  final url = Uri.parse('$apiUrl/resultados');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'partido_id': partidoId,
      'puntuacion_ganador': puntuacionGanador,
      'puntuacion_perdedor': puntuacionPerdedor,
      'equipo_ganador_id': equipoGanadorId,
      'equipo_perdedor_id': equipoPerdedorId,
    }),
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

  Future<bool> actualizarResultado(
      String id,
      String puntuacion_ganador,
      String puntuacion_perdedor,
      String partido_id,
      String equipo_ganador_id,
      String equipo_perdedor_id) async {
    final url = '$apiUrl/resultados/$id';
    print(url);
    final response = await http.put(
      Uri.parse(url),
      body: {
        'puntuacion_ganador': puntuacion_ganador,
        'puntuacion_perdedor': puntuacion_perdedor,
        'partido_id': partido_id,
        'equipo_ganador_id': equipo_ganador_id,
        'equipo_perdedor_id': equipo_perdedor_id,
      },
    );

    print(id+'id');

    if (response.statusCode == 200) {
      print('Partido actualizado exitosamente');
      return true;
    } else {
      print('Error al actualizar el partido: ${response.statusCode}');
      return false;
    }
  }

  Future<bool> eliminarResultado(String id) async {
    final url = Uri.parse('$apiUrl/resultados/$id');
    print(id);
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> actualizarPartidoJugado(String id, int jugado) async {
    final url = Uri.parse('$apiUrl/partidos/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'jugado': jugado}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  //Equipo
  Future<List<dynamic>> obtenerJugadoresPorEquipo(int equipoId) async {
    var url = Uri.parse('$apiUrl/jugadores?equipo_id=$equipoId');
    var respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      print('Error al obtener jugadores por equipo: ${respuesta.statusCode}');
      throw Exception('Failed to load jugadores');
    }
  }

}
