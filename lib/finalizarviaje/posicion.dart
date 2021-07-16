import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
// ignore: import_of_legacy_library_into_null_safe
import 'package:geocoding/geocoding.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:viajes/components/api_insert.dart';
import 'package:viajes/viajes/homev.dart';

class Posicionamiento extends StatefulWidget {
  const Posicionamiento({
    Key? key,
  }) : super(key: key);

  @override
  _PosicionamientoState createState() => _PosicionamientoState();
}

class _PosicionamientoState extends State<Posicionamiento> {
  late String _currentAddress = null as String;
  late Timer time;
  @override
  void initState() {
    super.initState();
    // ignore: prefer_const_constructors
    //main();
  }

  @override
  void dispose() {
    time.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers

    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: <Widget>[
          ClipOval(
            child: Material(
              color: Colors.grey[300], // Button color
              child: InkWell(
                splashColor: Colors.redAccent[700], // Splash color
                onTap: () {
                  _getCurrentLocation(
                      'Botón de panico activado', DateTime.now().toString());
                },
                child: const SizedBox(
                    width: 250,
                    height: 250,
                    child: Icon(
                      Icons.report_problem,
                      size: 150,
                      color: Colors.black,
                    )),
              ),
            ),
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 100,
          ),

          // ignore: unnecessary_new
          // ignore: prefer_const_constructors, deprecated_member_use
          RaisedButton(
            textColor: Colors.white,
            color: Colors.blueGrey,
            // ignore: prefer_const_constructors
            child: const SizedBox(
                width: 250,
                height: 40,
                child: Center(
                  child: Text(
                    'Finalizar viaje',
                    style: TextStyle(
                      fontFamily: 'helvetica',
                      fontSize: 20,
                    ),
                  ),
                )),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Homev()),
                (Route<dynamic> route) => false,
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ],
      ),
    );
  }

  _getCurrentLocation(String alerta, String date) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    } else {}
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      } else {
        Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.best,
                forceAndroidLocationManager: true)
            .then((Position position) {
          _getAddressFromLatLng(alerta, date, position);
        }).catchError((e) {
          // ignore: avoid_print
          print(e);
        });
      }
    }
  }

  _getAddressFromLatLng(String alerta, String date, Position position) async {
    InsertPosition mensaje;
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      final prefs = await SharedPreferences.getInstance();
      String? tracto = prefs.getString('tracto');
      String? rem = prefs.getString('rem');
      String? rem2 = prefs.getString('rem2');
      String? cp = prefs.getString('cp');
      Placemark place = placemarks[0];
      _currentAddress =
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
        }, headers: {
          'Accept': 'application/javascript',
          'Content-Type': 'application/x-www-form-urlencoded'
        });
        mensaje = insertPositionFromJson(response.body);
        // ignore: avoid_print
        print(mensaje.mensaje);
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

  // Future<void> _callback() async {
  //   // ignore: avoid_print
  //   print('start hilo: ${DateTime.now()}');
  //   try {
  //     // ignore: prefer_const_constructors
  //     await Future.delayed(
  //       // ignore: prefer_const_constructors
  //       Duration(seconds: 10),
  //     );

  //     // ignore: unnecessary_null_comparison, prefer_conditional_assignment

  //   } finally {
  //     // ignore: avoid_print
  //     print('fin hilo: ${DateTime.now()}');
  //     // ignore: prefer_const_constructors
  //     Timer(Duration(minutes: 5), _callback);
  //   }
  // }
}
