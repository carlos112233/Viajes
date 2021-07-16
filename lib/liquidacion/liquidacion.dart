import 'package:flutter/material.dart';

class Liquidacion extends StatefulWidget {
  const Liquidacion({Key? key}) : super(key: key);

  @override
  _LiquidacionState createState() => _LiquidacionState();
}

class _LiquidacionState extends State<Liquidacion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liquidación'),
      ),
      body: ListView(
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[],
      ),
    );
  }
}
