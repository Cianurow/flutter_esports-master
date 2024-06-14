
import 'package:aplicacion_esports/pages/Pantalla_Inicio.dart';
import 'package:aplicacion_esports/pages/Pantalla_Inicio_Sesion.dart';
import 'package:aplicacion_esports/pages/pantalla_jugadores.dart';
import 'package:aplicacion_esports/pages/tabs/tab_partidos.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.}
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
        scaffoldBackgroundColor: Color.fromARGB(255, 236, 236, 236),
        useMaterial3: true,
      ),
      //home: PantallaInicio(),
      routes: {
        '/': (context) => Pantalla_Inicio_Sesion(),
        '/PantallaInicio':(context) => PantallaInicio(),
        '/Partidos':(context) => Partidos(),
        '/detalleEquipo': (context) => DetalleEquipoScreen(equipoId: ModalRoute.of(context)!.settings.arguments as int),
      },
      initialRoute: '/',
      );
  }
}