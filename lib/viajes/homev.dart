import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:viajes/components/api_insert.dart';
import 'package:viajes/components/cpconsulta.dart';
import 'package:viajes/finalizarviaje/finalizarviaje.dart';
// ignore: import_of_legacy_library_into_null_safe
//import 'package:geocoding/geocoding.dart';
// ignore: import_of_legacy_library_into_null_safe
//import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Homev extends StatefulWidget {
  const Homev({Key? key}) : super(key: key);

  @override
  _HomevState createState() => _HomevState();
}

class _HomevState extends State<Homev> {
  final TextEditingController tracto = TextEditingController();
  final TextEditingController remolque = TextEditingController();
  final TextEditingController remolque2 = TextEditingController();
  final TextEditingController cartaporte = TextEditingController();
  final TextEditingController operador = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var mensajes;
  String? trac;
  String? rem;
  String? rem2;
  String? cp;
  String? token;
  // late Position _currentPosition = null as Position;
  // late String _currentAddress = null as String;
  late final List _image = [];

  // ignore: unused_element

  // ignore: prefer_const_constructors
  // MethodChannel platform = MethodChannel('BackgroundServices');

  // void startServices() async {
  //   dynamic value = await platform.invokeMethod('startServices');
  //   debugPrint(value);
  // }

  @override
  void initState() {
    super.initState();
    iniciar();
  }

  // ignore: prefer_typing_uninitialized_variables
  _imgFromCamera() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      var img = File(image!.path);
      _image.add(img.path);
    });
  }

  _imgFromGallery() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      var img = File(image!.path);
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

  Future<void> _showMyDialog(String tracto, String rem, String rem2, String cp,
      String operador, List image) async {
    final prefs = await SharedPreferences.getInstance();
    // startServices();
    List<String> img64 = [];
    for (var i = 0; i < image.length; i++) {
      Uint8List bytes = File(image[i]).readAsBytesSync();
      String data = base64Encode(bytes);

      img64.add(data);
    }
    prefs.setString('cancelar', "");
    // ignore: avoid_print
    print(img64.length);
    if (tracto == '') {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('No ha igresado el Economico del Tracto')
                ],
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
    } else if (rem == '') {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[Text('No ha igresado el remolque')],
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
    } else if (cp == '') {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Mensaje'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[Text('No ha igresado la carta porte')],
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
    }
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
                children: const <Widget>[Text('No ha igresado la foto')],
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
          "http://supertrack-net.ddns.net:50371/viajesapi/insert_viaje.php");
      final response = await http.post(url, body: {
        'unidad': tracto.toString(),
        'rem': rem.trim().toString(),
        'rem2': rem2.trim().toString(),
        'Oper': operador.trim().toString(),
        'cp': cp.trim().toString(),
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
                    // _getCurrentLocation(tracto, rem, rem2, cp, operador, img64);

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Finalizarv(tracto, rem, rem2, cp)),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
        //
      }
      if (result.mensaje == "ya se ha insertado") {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Mensaje'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('ya fue insertado este viaje'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    // _getCurrentLocation(tracto, rem, rem2, cp, operador, img64);

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        //
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Mensaje'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Hubo un error al registrar los datos'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    // _getCurrentLocation(tracto, rem, rem2, cp, operador, img64);

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  _cargar(var cp) async {
    // ignore: avoid_print
    print(cp);
    var url = Uri.parse(
        "http://supertrack-net.ddns.net:50371/Controldeunidades/php/consulta_cp.php");

    var response = await http.post(url, body: {
      'cp': cp,
    }, headers: {
      'Accept': 'application/javascript',
      'Content-Type': 'application/x-www-form-urlencoded'
    });
    final mensaje = insertPositionFromJson(response.body);
    // ignore: unnecessary_null_comparison
    if (mensaje.mensaje == null) {
      final data = cpConsultaFromJson(response.body);
      setState(() {
        cartaporte.text = "";
        tracto.text = "";
        remolque.text = "";
        remolque2.text = "";
        operador.text = "";
        cartaporte.text = data.cartaporte.trim();
        tracto.text = data.tractoNumEco.trim();
        remolque.text = data.remNe1.trim();

        if (data.remNe2 != null) {
          remolque2.text = data.remNe2.trim();
        } else {
          remolque2.text = "";
        }
        operador.text = data.operadorNombre.trim();
      });
    } else if (mensaje.mensaje == "No existe la carta porte") {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Mensaje'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[Text("No existe la carta porte")],
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
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mensajes == "Si existe un viaje activo") {
      return Finalizarv(trac!, rem!, rem2!, cp!);
    } else {
      return _viajeCurso();
    }
  }

  _viajeCurso() {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text(
          "Registrar viaje",
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
              height: 4000,
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    // ignore: unnecessary_
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.symmetric(horizontal: 70.0),
                    child: TextFormField(
                      controller: cartaporte,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'Inserte su carta porte',
                        labelText: 'Carta porte',
                      ),
                    ),
                  ),
                  Container(
                    // ignore: unnecessary_new
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.symmetric(horizontal: 150.0),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue[700],
                      // ignore: prefer_const_constructors
                      child: Text("Cargar"),
                      onPressed: () {
                        _cargar(cartaporte.text);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // ignore: unnecessary_new
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.symmetric(horizontal: 70.0),
                    child: TextFormField(
                      controller: operador,
                      enabled: false,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'Inserte su remolque 2',
                        labelText: 'Operador',
                      ),
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // ignore: unnecessary_new
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.symmetric(horizontal: 70.0),
                    child: TextFormField(
                      enabled: false,
                      controller: tracto,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'Inserte su tracto',
                        labelText: 'Tracto',
                      ),
                    ),
                  ),

                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // ignore: unnecessary_new
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.symmetric(horizontal: 70.0),
                    child: TextFormField(
                      controller: remolque,
                      enabled: false,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'Inserte su remolque',
                        labelText: 'Remolque',
                      ),
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // ignore: unnecessary_new
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.symmetric(horizontal: 70.0),
                    child: TextFormField(
                      controller: remolque2,
                      enabled: false,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'Inserte su remolque 2',
                        labelText: 'Remolque 2',
                      ),
                    ),
                  ),
                  // ignore: prefer_const_constructors

                  // ignore: prefer_const_constructors
                  SizedBox(height: 15),
                  // ignore: prefer_const_constructors, deprecated_member_use

                  Container(
                    height: 180,
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
                            )),
                        Expanded(
                          child: GridView.count(
                            scrollDirection: Axis.horizontal,
                            crossAxisCount: 1,
                            children: List.generate(_image.length, (index) {
                              File asset = File(_image[index]);
                              return Center(
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.white10,
                                  // ignore: unnecessary_null_comparison
                                  child: asset != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          child: Image.file(
                                            asset,
                                            width: 400,
                                            height: 400,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(0)),
                                          width: 400,
                                          height: 400,
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 20,
                  ),

                  Container(
                    // ignore: unnecessary_new
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.symmetric(horizontal: 150.0),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.red.shade700,
                      // ignore: prefer_const_constructors
                      child: Text("Iniciar"),
                      onPressed: () {
                        _showMyDialog(
                          tracto.text,
                          remolque.text,
                          remolque2.text,
                          cartaporte.text,
                          operador.text,
                          _image,
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> iniciar() async {
    final prefs = await SharedPreferences.getInstance();
    String? tracs = prefs.getString('tracto');
    String? rems = prefs.getString('rem');
    String? rems2 = prefs.getString('rem2');
    String? cps = prefs.getString('cp');
    String? tokens = prefs.getString('token');
    var url = Uri.parse(
        "http://supertrack-net.ddns.net:50371/viajesapi/select_viajes_activos.php");
    var response = await http.post(url, body: {
      'cp': cps.toString(),
      'token': tokens.toString(),
    }, headers: {
      'Accept': 'application/javascript',
      'Content-Type': 'application/x-www-form-urlencoded'
    });
    final mensaje = insertPositionFromJson(response.body);
    setState(() {
      mensajes = mensaje.mensaje;
      trac = tracs;
      rem = rems;
      rem2 = rems2;
      cp = cps;
    });
  }
}
