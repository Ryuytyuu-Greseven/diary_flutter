import 'package:diary/src/login/login_form.dart';
import 'package:diary/src/login/login_logo.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'DIARY',
            style: TextStyle(
              // backgroundColor: Colors.black,
              color: Color.fromARGB(255, 255, 255, 255),
              // backgroundColor: Colors.black
            ),
          ),
        ),
        body: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    child: Container(
                      // color: Colors.red,
                      height: 150,
                      // padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(139, 147, 139, 1), width: 1),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: LoginComponent(),
                      ),
                    ),
                  ),
                  Container(
                      height: 300,
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: LoginLogo())
                ],
              ),
            )));
  }
}
