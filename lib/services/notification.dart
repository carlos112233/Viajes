import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viajes/components/api_insert.dart';
import 'package:http/http.dart' as http;
import 'package:viajes/menu/menu.dart';

doSometing() {
  _callback();
}

_callback() async {
  print('start hilo: ${DateTime.now()}');
  try {
    // ignore: prefer_const_constructors
    BuildContext context;
    await Future.delayed(
        // ignore: prefer_const_constructors
        Duration(seconds: 8),
        _getCurrentLocation(context, '', DateTime.now().toString(), "1"));

    // ignore: unnecessary_null_comparison, prefer_conditional_assignment

  } finally {
    // ignore: avoid_print
    print('fin hilo: ${DateTime.now()}');
    // ignore: prefer_const_constructors
    Timer(Duration(minutes: 1), _callback);
  }
}

_getCurrentLocation(
    BuildContext context, String alerta, String date, String estatus) {
  Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position) {
    _getAddressFromLatLng(context, alerta, date, estatus, position);
  }).catchError((e) {
    // ignore: avoid_print
    print(e);
  });
}

_getAddressFromLatLng(BuildContext context, String alerta, String date,
    String estatus, Position position) async {
  InsertPosition mensaje;
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final prefs = await SharedPreferences.getInstance();
    String tracto = prefs.getString('tracto');
    String rem = prefs.getString('rem');
    String rem2 = prefs.getString('rem2');
    String cp = prefs.getString('cp');
    String token = prefs.getString('token');
    Placemark place = placemarks[0];
    // ignore: unused_local_variable
    var _currentAddress =
        "${place.locality}, ${place.country}, ${place.street}, ${place.postalCode}";
    var url = Uri.parse(
        'http://supertrack-net.ddns.net:50371/viajesapi/api_insert.php');
    if (alerta != '') {
      var response = await http.post(url, body: {
        'unidad': tracto.toString(),
        'remolque': rem.toString(),
        'remolque2': rem2.toString(),
        'latitud': position.latitude.toString(),
        'longitud': position.longitude.toString(),
        'fecha_ap': date,
        'desc_evento': alerta,
        'localidad': _currentAddress.toString(),
        'cp': cp.toString(),
        'token': token.toString(),
        'estatus': estatus
      }, headers: {
        'Accept': 'application/javascript',
        'Content-Type': 'application/x-www-form-urlencoded'
      });
      mensaje = insertPositionFromJson(response.body);
      // ignore: avoid_print
      print(mensaje.mensaje);
    } else if (estatus == "0") {
      var response = await http.post(url, body: {
        'unidad': tracto.toString(),
        'remolque': rem.toString(),
        'remolque2': rem2.toString(),
        'latitud': position.latitude.toString(),
        'longitud': position.longitude.toString(),
        'fecha_ap': date,
        'desc_evento': alerta,
        'localidad': _currentAddress.toString(),
        'cp': cp.toString(),
        'token': token.toString(),
        'estatus': estatus
      }, headers: {
        'Accept': 'application/javascript',
        'Content-Type': 'application/x-www-form-urlencoded'
      });
      mensaje = insertPositionFromJson(response.body);
      if (mensaje.mensaje == "finalizo el viaje") {
        prefs.setString('cancelar', "si");
        sleep(const Duration(seconds: 1));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Menu()),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      var response = await http.post(url, body: {
        'unidad': tracto.toString(),
        'remolque': rem.toString(),
        'remolque2': rem2.toString(),
        'latitud': position.latitude.toString(),
        'longitud': position.longitude.toString(),
        'fecha_ap': date,
        'desc_evento': alerta,
        'localidad': _currentAddress.toString(),
        'cp': cp.toString(),
        'token': token.toString(),
        'estatus': estatus
      }, headers: {
        'Accept': 'application/javascript',
        'Content-Type': 'application/x-www-form-urlencoded'
      });
      mensaje = insertPositionFromJson(response.body);
      // ignore: avoid_print
      print(mensaje.mensaje);
    }
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }
}

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //initilize

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("ic_launcher");

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: doSometing());
  }

  //Instant Notifications
  Future instantNofitication() async {
    var android = AndroidNotificationDetails("id", "channel", "description");

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(0, "En viaje",
        "Estas Compartiendo tu viaje para tu seguridad", platform,
        payload: "Welcome to demo app");
  }

  //Image notification
  Future imageNotification() async {
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        contentTitle: "Notificación Demo image ",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, "Notificación Demo Image ", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Stylish Notification
  Future stylishNotification() async {
    var android = AndroidNotificationDetails("id", "channel", "description",
        color: Colors.deepOrange,
        enableLights: true,
        enableVibration: true,
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        styleInformation: MediaStyleInformation(
            htmlFormatContent: true, htmlFormatTitle: true));

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, "Notificación Demo Stylish ", "Tap to do something", platform);
  }

  //Sheduled Notification

  Future sheduledNotification() async {
    var interval = RepeatInterval.everyMinute;
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        contentTitle: "Notificación Demo image ",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        "Notificación Demo Sheduled ",
        "Tap to do something",
        interval,
        platform,
        payload: "Welcome to demo app");
  }

  //Cancel notification

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
