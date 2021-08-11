import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viajes/components/token_status.dart';
import 'package:viajes/home/home.dart';
import 'package:viajes/menu/menu.dart';
import 'package:viajes/services/notification.dart';
import 'package:http/http.dart' as http;

class Session extends StatefulWidget {
  const Session({Key key}) : super(key: key);

  @override
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<Session> with WidgetsBindingObserver {
  // ignore: avoid_init_to_null
  String token = null;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    Provider.of<NotificationService>(context, listen: false).initialize();
    getitemLocalStorage();
    super.initState();
    // ignore: prefer_const_constructors
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    BuildContext context;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackgrond = state == AppLifecycleState.paused;
    if (isBackgrond) {
      Provider.of<NotificationService>(context, listen: false).initialize();
    } else {
      Provider.of<NotificationService>(context, listen: false).initialize();
    }
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
      return Scaffold(
        body: MyHomePage(
          title: 'Iniciar Sesión',
        ),
      );
    } else {
      return Scaffold(
        body: Menu(),
      );
    }
  }
}
