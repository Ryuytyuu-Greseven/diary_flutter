import 'package:flutter/material.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({Key? key}) : super(key: key);

  static const fontColor = Colors.white;
  static const fontSize = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text(
        'DIARY',
        style: TextStyle(
            color: fontColor,
            backgroundColor: Colors.red,
            fontSize: 100,
            fontWeight: FontWeight.w800),
      ),
    );
  }
}
