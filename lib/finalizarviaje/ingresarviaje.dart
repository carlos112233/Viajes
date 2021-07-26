import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viajes/finalizarviaje/posicion.dart';
import 'package:viajes/services/notification.dart';

class StartViaje extends StatefulWidget {
  const StartViaje({Key key}) : super(key: key);

  @override
  _StartViajeState createState() => _StartViajeState();
}

class _StartViajeState extends State<StartViaje> {
  @override
  void initState() {
    Provider.of<NotificationService>(context, listen: false).initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text(
          "Viaje en Curso",
          // ignore: prefer_const_constructors
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Container(
              height: 2200,
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      "Botón Panico",
                      style: TextStyle(
                        fontFamily: 'helvetica',
                        fontSize: 40,
                      ),
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    // ignore: unnecessary_new
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    height: 900,
                    // ignore: deprecated_member_use
                    child: Posicionamiento(),
                  ),
                  Center(),
                  // ignore: prefer_const_constructors
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
