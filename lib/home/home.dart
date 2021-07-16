import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viajes/components/response.dart';
import 'package:viajes/components/usuarios.dart';
import 'package:viajes/viajes/pasar.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController users = TextEditingController();
  String clave = '';
  getitemLocalStorage(String user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('usuario', user).toString();

    var url = Uri.parse(
        'http://supertrack-net.ddns.net:50371/viajesapi/api_user_inser.php');
    final response = await http.post(url, body: {
      'clave_op': clave,
      'fecha_reg': DateTime.now().toString(),
    });
    if (response.statusCode == 200) {
      final respuesta = respuestaFromJson(response.body);
      if (respuesta.mensaje == "Se registro correctamente") {
        prefs.setString('token', respuesta.token.toString());
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Mensaje'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Se guardo Correctamente el usuario')
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Pasar(
                                datos: '1',
                              )),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    } else {}
  }

  Future<void> _showMyDialog(String user, String clave) async {
    if (user == '') {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[Text('No ingreso su nombre')],
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
      getitemLocalStorage(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          // ignore: prefer_const_constructors
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                  // ignore: prefer_const_constructors
                  padding: EdgeInsets.all(15),
                  height: 2000,
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      // ignore: prefer_const_constructors

                      Container(
                        // ignore: unnecessary_new
                        // ignore: prefer_const_constructors
                        margin: EdgeInsets.symmetric(horizontal: 100.0),
                        child: TypeAheadField<User?>(
                          debounceDuration: const Duration(milliseconds: 500),
                          hideSuggestionsOnKeyboardHide: false,
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: users,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Buscar Usuario',
                            ),
                          ),
                          suggestionsCallback: UserApi.getUserSuggestion,
                          itemBuilder: (context, User? suggestion) {
                            final user = suggestion!;
                            return ListTile(
                              // ignore: unnecessary_string_interpolations
                              title: Text('${user.operadorNombre}'),
                            );
                          },
                          // ignore: sized_box_for_whitespace
                          noItemsFoundBuilder: (context) => Container(
                            height: 100,
                            child: const Center(
                              child: Text(
                                'No se encontro el operador.',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          onSuggestionSelected: (User? suggestion) {
                            final user = suggestion!;
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                content: Text(
                                    'Selecciono la clave del usuario: ${user.operadorClave}'),
                              ));

                            setState(() {
                              users.text = user.operadorNombre.trim();
                              // ignore: unnecessary_string_interpolations
                              clave = '${user.operadorClave}';
                            });
                          },
                        ),
                      ),

                      // ignore: prefer_const_constructors
                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        // ignore: unnecessary_new
                        // ignore: prefer_const_constructors
                        margin: EdgeInsets.symmetric(horizontal: 100.0),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          textColor: Colors.white,
                          color: Colors.red.shade700,
                          // ignore: prefer_const_constructors
                          child: Text("Enviar"),
                          onPressed: () {
                            _showMyDialog(users.text, clave);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class UserApi {
  static Future<List<User>> getUserSuggestion(String query) async {
    var url = Uri.parse(
        'http://supertrack-net.ddns.net:50371/viajesapi/select_user.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List users = json.decode(response.body);

      return users.map((json) => User.fromJson(json)).where((user) {
        final nameLower = user.operadorNombre.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
