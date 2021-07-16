import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:geocoding/geocoding.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:geolocator/geolocator.dart';
import 'package:viajes/viajes/homev.dart';

// ignore: use_key_in_widget_constructors
class Pruebas extends StatefulWidget {
  @override
  _Pruebas createState() => _Pruebas();
}

class _Pruebas extends State<Pruebas> {
  late Position _currentPosition = null as Position;
  late String _currentAddress = null as String;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ignore: unnecessary_null_comparison
            if (_currentAddress != null) Text(_currentAddress),
            // ignore: deprecated_member_use
            FlatButton(
              child: const Text("obtener location"),
              onPressed: () {
                _getCurrentLocation();
                _getAddressFromLatLng();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Homev()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
        // ignore: avoid_print
        print(_currentPosition);
      });
    }).catchError((e) {
      // ignore: avoid_print
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
