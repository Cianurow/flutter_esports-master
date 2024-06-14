import 'package:flutter/material.dart';

class Pantalla_Inicio_Sesion extends StatelessWidget {
  const Pantalla_Inicio_Sesion({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Inicio De Sesion',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255)
              ),
              ),
            backgroundColor: Color.fromARGB(255, 0, 0, 0),
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image.jpg'),
                    fit: BoxFit.cover,
                  )
                ),
              ),
           SingleChildScrollView(
            padding: EdgeInsets.all(32),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Text(
                'Bienvenido a los Esports',
                style: TextStyle(
                  fontSize: 35,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          labelText: 'Correo Electronico',
                          labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                          hintText: 'Ingresar correo electronico',
                          hintStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                          prefixIcon: Icon(Icons.email,
                          color: const Color.fromARGB(255, 0, 0, 0)
                          ),
                          border: OutlineInputBorder()
                        ),
                        onChanged: (String value) {
                                    
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'Porfavor ingrese su correo electronico' : null;
                        },
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          hintText: 'Ingresar Contraseña',
                          hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          prefixIcon: Icon(Icons.password,
                          color: Color.fromARGB(255, 0, 0, 0)
                          ),
                          border: OutlineInputBorder()
                        ),
                        onChanged: (String value) {
                                    
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'Porfavor ingrese su contraseña' : null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        onPressed: () {
                          Navigator.pushNamed(context, '/PantallaInicio');
                        },
                        child: Text('Iniciar Sesion'),
                        color: Color.fromARGB(255, 255, 255, 255),
                        textColor: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(
              'assets/logo.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 50),
            ],
            ),
          ),
          ],
          ),
        ),
      ),
    );
  }
}