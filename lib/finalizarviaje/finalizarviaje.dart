import 'package:flutter/material.dart';
import 'package:viajes/finalizarviaje/posicion.dart';

class Finalizarv extends StatelessWidget {
  final String tracto;
  final String rem;
  final String rem2;
  final String cp;

  const Finalizarv(
    this.tracto,
    this.rem,
    this.rem2,
    this.cp, {
    key,
  }) : super(key: key);

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
                      child: const Posicionamiento(),
                    ),
                    // ignore: prefer_const_constructors
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
