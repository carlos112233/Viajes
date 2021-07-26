import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viajes/services/notification.dart';
import 'package:viajes/viajes/homev.dart';

class Notificaciones extends StatelessWidget {
  const Notificaciones({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(child: Homev(), providers: [
      ChangeNotifierProvider(
        create: (_) => NotificationService(),
      )
    ]);
  }
}
