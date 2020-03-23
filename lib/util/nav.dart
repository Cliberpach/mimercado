import 'package:flutter/material.dart';

class Nav {
  navPush(
    BuildContext context,
    Widget navigate,
    VoidCallback callback(response),
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => navigate,
      ),
    ).then((response) => callback(response));
  }
}
