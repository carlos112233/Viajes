import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viajes/finalizarviaje/ingresarviaje.dart';
import 'package:viajes/services/notification.dart';

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
    return MultiProvider(
      child: StartViaje(),
      providers: [ChangeNotifierProvider(create: (_) => NotificationService())],
    );
  }
}
