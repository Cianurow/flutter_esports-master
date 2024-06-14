import 'package:aplicacion_esports/pages/tabs/tab_equipos.dart';
import 'package:aplicacion_esports/pages/tabs/tab_home.dart';
import 'package:aplicacion_esports/pages/tabs/tab_partidos.dart';
import 'package:aplicacion_esports/pages/tabs/tab_perfil.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _paginas = [
    {
    'pagina':Home(),
    'texto':'Home',
    'color':0xFFD80100,
    'icono':MdiIcons.home
    },

    {
    'pagina':Partidos(),
    'texto':'Partidos',
    'color':0xFF037470,
    'icono':MdiIcons.soccer
    },

    {
    'pagina':Equipos(),
    'texto':'Equipos',
    'color':0xFFFF8B00,
    'icono':MdiIcons.accountGroup
    },

    {
    'pagina':Perfil(),
    'texto':'Perfil',
    'color':0xFF4A90E2,
    'icono':MdiIcons.account
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_paginas[_currentIndex]['texto'],
            style: TextStyle(color: Colors.white),
          ),
            backgroundColor: Color(_paginas[_currentIndex]['color']),
          ),
          body: _paginas[_currentIndex]['pagina'],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            items: _paginas.map((pagina){
              return BottomNavigationBarItem(
                icon: Icon(pagina['icono']),
                label: pagina['texto'],
                backgroundColor: Color(pagina['color']),
                );
            }).toList(),
            currentIndex: _currentIndex,
            onTap: (index){
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
