import 'package:anvic/views/VOfficeHours.dart';
import 'package:flutter/material.dart';
import 'views/VSplash.dart';
import 'views/auth/VLogin.dart';
import 'views/auth/VRegister.dart';
import 'views/auth/VRecover.dart';
import 'views/VHome.dart';
import 'views/VProfile.dart';
import 'views/VAddress.dart';
import 'views/VAddPoint.dart';
import 'views/prb.dart';
import 'views/VHistory.dart';
import 'views/VContact.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget login = VLogin();
  Widget register = VRegister();
  Widget recover = VRecover();
  Widget home = VHome();
  Widget profile = VProfile();
  Widget address = VAddress();
  Widget addPoint = VAddPoint();
  Widget history = VHistory();
  Widget contact = VContact();
  Widget officeHours = VOfficeHours();
  Widget prb = Prb();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VSplash(),
      routes: {
        '/login': (context) => login,
        '/register': (context) => register,
        '/recover': (context) => recover,
        '/home': (context) => home,
        '/profile': (context) => profile,
        '/address': (context) => address,
        '/addPoint': (context) => addPoint,
        '/history': (context) => history,
        '/contact': (context) => contact,
        '/officeHours': (context) => officeHours,
        '/prb': (context) => prb,
      },
    );
  }
}
