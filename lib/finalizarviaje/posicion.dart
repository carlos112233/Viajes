import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:viajes/components/api_insert.dart';
import 'package:viajes/menu/menu.dart';
import 'package:viajes/services/notification.dart';

class Posicionamiento extends StatefulWidget {
  const Posicionamiento({
    key,
  }) : super(key: key);

  @override
  _PosicionamientoState createState() => _PosicionamientoState();
}

class _PosicionamientoState extends State<Posicionamiento> {
  // ignore: prefer_const_constructors, unused_field
  Position _currentPosition;
  // ignore: prefer_const_constructors
  // MethodChannel platform = MethodChannel('BackgroundServices');

  // void startServices() async {
  //   dynamic value = await platform.invokeMethod('startServices');
  //   debugPrint(value);
  //   sleep(const Duration(seconds: 20));
  // }

  // ignore: unused_field

  // ignore: prefer_const_constructors

  final List _image = [];

  // ignore: prefer_typing_uninitialized_variables
  _imgFromCamera() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      var img = File(image.path);
      _image.add(img.path);
    });
  }

  _imgFromGallery() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      var img = File(image.path);
      _image.add(img.path);
    });
  }

  // ignore: unused_element
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Galeria'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showMyDialog(List image) async {
    final prefs = await SharedPreferences.getInstance();
    String cp = prefs.getString('cp');
    List<String> img64 = [];
    for (var i = 0; i < image.length; i++) {
      Uint8List bytes = File(image[i]).readAsBytesSync();
      String data = base64Encode(bytes);
      img64.add(data);
    }

    // ignore: avoid_print

    // ignore: curly_braces_in_flow_control_structures, unnecessary_null_comparison
    if (img64 == null) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Mensaje'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[Text('No ha igresado la fotos')],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      var url = Uri.parse(
          "http://supertrack-net.ddns.net:50371/viajesapi/select_viajes.php");
      final response = await http.post(url, body: {
        'cp': cp.toString().trim(),
        'img': img64.toString(),
      }, headers: {
        'Accept': 'application/javascript',
        'Content-Type': 'application/x-www-form-urlencoded'
      });
      final result = insertPositionFromJson(response.body);
      if (result.mensaje == "Se registro correctamente") {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Mensaje'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Se han enviado correctamente los datos'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _image.clear();
                    });
                  },
                ),
              ],
            );
          },
        );
        //
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers

    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: <Widget>[
          // ignore: prefer_const_constructors
          SizedBox(
            height: 50,
          ),

          // ignore: prefer_const_constructors

          // ignore: deprecated_member_use
        ],
      ),
    );
  }

  _getCurrentLocation(String alerta, String date, String estatus) {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
      _getAddressFromLatLng(alerta, date, estatus, position);
    }).catchError((e) {
      // ignore: avoid_print
      print(e);
    });
  }

  _getAddressFromLatLng(
      String alerta, String date, String estatus, Position position) async {
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
            MaterialPageRoute(builder: (context) => const Menu()),
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
}
