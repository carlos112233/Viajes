// import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viajes/menu/menu.dart';
// ignore: unused_import

class Pasar extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final String datos;
  const Pasar({Key? key, required this.datos}) : super(key: key);

  @override
  _PasarState createState() => _PasarState();
}

class _PasarState extends State<Pasar> {
  // ignore: prefer_typing_uninitialized_variables
  var _image;
  // ignore: prefer_typing_uninitialized_variables
  var _image2;
  // ignore: prefer_typing_uninitialized_variables
  var _image3;
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
          // ignore: prefer_const_constructors
          SizedBox(
            height: 70,
          ),
          const Center(
            child: Text(
              'Capture o Elija su INE',
              style: TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context, 1);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: const Color(0xffFDCF09),
                // ignore: unnecessary_null_comparison
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _image,
                          width: 400,
                          height: 400,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 400,
                        height: 400,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Center(
            child: Text(
              'Capture o Elija su licencia ',
              style: TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context, 2);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: const Color(0xffFDCF09),
                // ignore: unnecessary_null_comparison
                child: _image2 != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _image2,
                          width: 400,
                          height: 400,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 400,
                        height: 400,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Center(
            child: Text(
              'Capture o Elija su comprobante de Domicilio ',
              style: TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context, 3);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                // ignore: unnecessary_null_comparison
                child: _image3 != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _image3,
                          width: 400,
                          height: 400,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 400,
                        height: 400,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            // ignore: deprecated_member_use
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.red.shade700,
              // ignore: prefer_const_constructors
              child: Text("Enviar"),
              onPressed: () {
                _showMyDialog(_image, _image2, _image3);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
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
      } else if (opc == 2) {
        _image2 = File(image!.path);
      } else {
        _image3 = File(image!.path);
      }
    });
  }

  _imgFromGallery(int opc) async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (opc == 1) {
        _image = File(image!.path);
      } else if (opc == 2) {
        _image2 = File(image!.path);
      } else {
        _image3 = File(image!.path);
      }
    });
  }

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

  Future<void> _showMyDialog(var image, var image2, var image3) async {
    // ignore: avoid_print
    String img64ine = '';
    String img64lic = '';
    String img64doc = '';
    if ((image != null && image2 != null && image3 != null) &&
        widget.datos == '1') {
      Uint8List bytes = File(image.path).readAsBytesSync();
      Uint8List bytes2 = File(image2.path).readAsBytesSync();
      Uint8List bytes3 = File(image3.path).readAsBytesSync();
      img64ine = base64Encode(bytes);
      img64lic = base64Encode(bytes2);
      img64doc = base64Encode(bytes3);
    } else {
      // ignore: prefer_typing_uninitialized_variables
      var bytes;
      // ignore: prefer_typing_uninitialized_variables
      var bytes2;
      // ignore: prefer_typing_uninitialized_variables
      var bytes3;
      if (image != null) {
        bytes = File(image.path).readAsBytesSync();
        img64ine = base64Encode(bytes);
      } else {
        img64ine = '';
      }
      if (image2 != null) {
        bytes2 = File(image2.path).readAsBytesSync();
        img64lic = base64Encode(bytes2);
      } else {
        img64lic = '';
      }
      if (image3 != null) {
        bytes3 = File(image3.path).readAsBytesSync();
        img64doc = base64Encode(bytes3);
      } else {
        img64doc = '';
      }
    }

    if (widget.datos != '1') {
      _insert(img64ine, img64lic, img64doc);
    } else {
      if (image == null) {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[Text('No ha igresado INE')],
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
      } else if (image2 == null) {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[Text('No ha igresado el Licencia')],
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
      } else if (image3 == null) {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Mensaje'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('No ha igresado comprobante de Domicilio')
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
      } else {
        _insert(img64ine, img64lic, img64doc);
      }
    }
  }

  // static Future image2Base64(File path) async {
  //   File file = path;
  //   final bytes = File(file.path).readAsBytesSync();
  //   String image = base64Encode(bytes);
  //   // ignore: avoid_print
  //   print(image);
  // }

  _insert(var image, var image2, var image3) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var url = Uri.parse(
        'http://supertrack-net.ddns.net:50371/viajesapi/insert_image.php');
    final response = await http.post(url, body: {
      'fecha_ing': DateTime.now().toString(),
      'image': image,
      'image2': image2,
      'image3': image3,
      'token': token
    }, headers: {
      'Accept': 'application/javascript',
      'Content-Type': 'application/x-www-form-urlencoded'
    });

    if (response.statusCode == 200) {
      if (widget.datos == '1') {
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Menu()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Menu()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Mensaje'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Hubo un error al incertar'),
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
    }
  }
}
