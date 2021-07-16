import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viajes/components/api_insert.dart';
import 'package:viajes/components/cpconsulta.dart';
import 'package:viajes/finalizarviaje/finalizarviaje.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:geocoding/geocoding.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// ignore: import_of_legacy_library_into_null_safe
import 'package:multi_image_picker/multi_image_picker.dart';

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
  late Position _currentPosition = null as Position;
  late String _currentAddress = null as String;
  // ignore: prefer_typing_uninitialized_variables
  var _image;
  Future<void> _showMyDialog(String tracto, String rem, String rem2, String cp,
      String operador, File image) async {
    Uint8List bytes = File(image.path).readAsBytesSync();

    String img64 = base64Encode(bytes);
    // ignore: avoid_print
    print(img64);
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
    // ignore: curly_braces_in_flow_control_structures
    if (_image?.path?.isEmpty != false) {
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
        'img': bytes.toString(),
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
                    _getCurrentLocation(tracto, rem, rem2, cp, operador, img64);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Finalizarv(tracto, rem, rem2, cp, operador)),
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
                    _getCurrentLocation(tracto, rem, rem2, cp, operador, img64);
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
                    _getCurrentLocation(tracto, rem, rem2, cp, operador, img64);
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

                  const Imagenes(),

                  // Center(
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       _showPicker(context, 1);
                  //     },
                  //     child: CircleAvatar(
                  //       radius: 55,
                  //       backgroundColor: Colors.white10,
                  //       // ignore: unnecessary_null_comparison
                  //       child: _image != null
                  //           ? ClipRRect(
                  //               borderRadius: BorderRadius.circular(50),
                  //               child: Image.file(
                  //                 _image,
                  //                 width: 400,
                  //                 height: 400,
                  //                 fit: BoxFit.fitHeight,
                  //               ),
                  //             )
                  //           : Container(
                  //               decoration: BoxDecoration(
                  //                   color: Colors.grey[200],
                  //                   borderRadius: BorderRadius.circular(50)),
                  //               width: 400,
                  //               height: 400,
                  //               child: Icon(
                  //                 Icons.camera_alt,
                  //                 color: Colors.grey[800],
                  //               ),
                  //             ),
                  //     ),
                  //   ),
                  // ),
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

  _imgFromCamera(int opc) async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      if (opc == 1) {
        _image = File(image!.path);
      }
    });
  }

  _imgFromGallery(int opc) async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (opc == 1) {
        _image = File(image!.path);
      }
    });
  }

  // ignore: unused_element
  void _showPicker(context, int opc) {
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
                        _imgFromGallery(opc);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _imgFromCamera(opc);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _getCurrentLocation(String tracto, String rem, String rem2, String cp,
      String operador, String bytes) async {
    final prefs = await SharedPreferences.getInstance();
    String datos = "$tracto, $rem, $rem2, $cp, ${DateTime.now()}";
    // ignore: avoid_print
    print(datos);
    prefs.setString("tracto", tracto);
    prefs.setString("rem", rem);
    prefs.setString("rem2", rem2);
    prefs.setString("cp", cp);
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng(tracto, rem, rem2, cp);
        // ignore: avoid_print
        print(_currentPosition);
      });
    }).catchError((e) {
      // ignore: avoid_print
      print(e);
    });
  }

  _getAddressFromLatLng(
      String tracto, String rem, String rem2, String cp) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.country}, ${place.street}, ${place.postalCode}";
        String datos = "$tracto, $rem, $rem2, $cp";
        // ignore: avoid_print
        print(_currentAddress);
        // ignore: avoid_print
        print(datos);
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}

class Imagenes extends StatefulWidget {
  const Imagenes({Key? key}) : super(key: key);

  @override
  _ImagenesState createState() => _ImagenesState();
}

class _ImagenesState extends State<Imagenes> {
  List<Asset> images = <Asset>[];

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickImages() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
    }

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      // ignore: prefer_const_constructors
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          // ignore: deprecated_member_use
          RaisedButton(
            // ignore: prefer_const_constructors
            child: Text("Pick images"),
            onPressed: pickImages,
          ),
          Expanded(
            child: GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 1,
              children: List.generate(images.length, (index) {
                Asset asset = images[index];
                return AssetThumb(
                  asset: asset,
                  width: 600,
                  height: 600,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
