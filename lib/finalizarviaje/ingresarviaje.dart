import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viajes/components/api_insert.dart';
import 'package:http/http.dart' as http;
import 'package:viajes/menu/menu.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 300,
                        color: Colors.white,
                        child: Center(
                          child: ClipOval(
                            child: Material(
                              color: Colors.yellow[500], // Button color
                              child: InkWell(
                                splashColor:
                                    Colors.redAccent[700], // Splash color
                                onTap: () {
                                  _getCurrentLocation(
                                      'Botón de panico activado',
                                      DateTime.now().toString(),
                                      "1");
                                },
                                child: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Icon(
                                      Icons.report_problem,
                                      size: 100,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        color: Colors.white,
                        child: Center(
                          child: ClipOval(
                            child: Material(
                              color: Colors.blue[500], // Button color
                              child: InkWell(
                                splashColor: Colors.red[700], // Splash color
                                onTap: () {
                                  _getCurrentLocation(
                                      'Botón de panico activado',
                                      DateTime.now().toString(),
                                      "1");
                                },
                                child: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Icon(
                                      Icons.shop_2_outlined,
                                      size: 100,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 2200,
                  color: Colors.white,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Container(
                        height: 500,
                        // ignore: prefer_const_constructors
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: <Widget>[
                            // ignore: deprecated_member_use
                            RaisedButton(
                              textColor: Colors.white,
                              color: Colors.blue.shade700,
                              // ignore: prefer_const_constructors
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                // ignore: prefer_const_literals_to_create_immutables
                                children: <Widget>[
                                  // ignore: prefer_const_constructors
                                  Icon(
                                    Icons.image_search,
                                    size: 30,
                                  )
                                ],
                              ),
                              onPressed: () {
                                _showPicker(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            Container(
                              height: 162,
                              child: GridView.count(
                                scrollDirection: Axis.horizontal,
                                crossAxisCount: 1,
                                children: List.generate(
                                  _image.length,
                                  (index) {
                                    File asset = File(_image[index]);
                                    return Center(
                                      child: CircleAvatar(
                                        radius: 250,
                                        backgroundColor: Colors.white10,
                                        // ignore: unnecessary_null_comparison
                                        child: asset != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                                child: Image.file(
                                                  asset,
                                                  width: 500,
                                                  height: 800,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0)),
                                                width: 500,
                                                height: 800,
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            RaisedButton(
                              textColor: Colors.white,
                              color: Colors.blue.shade700,
                              // ignore: prefer_const_constructors
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                // ignore: prefer_const_literals_to_create_immutables
                                children: <Widget>[
                                  // ignore: prefer_const_constructors
                                  Text('Enviar'),
                                  // ignore: prefer_const_constructors
                                  Icon(
                                    Icons.send,
                                    size: 30,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                _showMyDialog(_image);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            //ignore: prefer_const_constructors
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: Consumer<NotificationService>(
                                builder: (context, model, _) => Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // ignore: prefer_const_constructors, deprecated_member_use
                                      RaisedButton(
                                        textColor: Colors.white,
                                        color: Colors.red.shade800,
                                        onPressed: () {
                                          _getCurrentLocation("",
                                              DateTime.now().toString(), "0");
                                          model.cancelNotification();
                                        },
                                        child: SizedBox(
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
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
}
