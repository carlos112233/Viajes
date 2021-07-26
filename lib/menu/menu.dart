import 'package:flutter/material.dart';
import 'package:viajes/liquidacion/liquidacion.dart';
import 'package:viajes/viajes/notificaciones.dart';
import 'package:viajes/viajes/pasar.dart';

class Menu extends StatefulWidget {
  const Menu({Key key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text(
          "Menu",
          // ignore: prefer_const_constructors
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          Card(
            child: ListTile(
              leading: const Icon(Icons.pin_drop),
              title: const Text(
                'Viajes',
                textScaleFactor: 1.5,
              ),
              subtitle: const Text('Toque'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Notificaciones()),
                  (Route<dynamic> route) => true,
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.send_and_archive),
              title: const Text(
                'Liquidaciones',
                textScaleFactor: 1.5,
              ),
              subtitle: const Text('Toque'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Liquidacion()),
                  (Route<dynamic> route) => true,
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(
                'Datos del usuario',
                textScaleFactor: 1.5,
              ),
              subtitle: const Text('Toque'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Pasar(
                            datos: '',
                          )),
                  (Route<dynamic> route) => true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
