import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/services.Dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'components/token_status.dart';
import 'home/home.dart';
import 'menu/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // ignore: avoid_print

    // ignore: prefer_const_constructors
    return Session();
  }
}

class Session extends StatefulWidget {
  const Session({Key? key}) : super(key: key);

  @override
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<Session> {
  // ignore: avoid_init_to_null
  late String? token = null;
  @override
  void initState() {
    super.initState();
    // ignore: prefer_const_constructors
    getitemLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return iniciar();
  }

  getitemLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tok = prefs.getString('token').toString();
    // ignore: unused_local_variable
    String resultado = '';
    var url = Uri.parse(
        'http://supertrack-net.ddns.net:50371/viajesapi/select_token.php');
    final response = await http.post(url, body: {'token': tok});
    if (response.statusCode == 200) {
      final token = tokenestatusFromJson(response.body);
      if (token.token == tok) {
        resultado = token.token;
      } else {
        resultado = '';
      }
    } else {}
    setState(() {
      // ignore: avoid_print
      print(tok);
      token = resultado;
    });
  }

  iniciar() {
    if (token == '') {
      return MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget!),
            maxWidth: 1200,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(450, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: Container(color: const Color(0xFFF5F5F5))),
        debugShowCheckedModeBanner: false,
        title: 'Viajes',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const MyHomePage(
          title: 'Iniciar Sesión',
        ),
      );
    } else {
      return MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget!),
            maxWidth: 1200,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(450, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: Container(color: const Color(0xFFF5F5F5))),
        debugShowCheckedModeBanner: false,
        title: 'Registrar viaje',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const Menu(),
      );
    }
  }
}
