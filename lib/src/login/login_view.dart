import 'package:diary/src/login/login_form.dart';
import 'package:diary/src/login/login_logo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  final BuildContext globalContext;
  const LoginScreen({super.key, required this.globalContext});

  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 0, 0, 0),
            title: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white, width: 2)),
              child: Center(
                child: Text(
                  'DIARY',
                  style: GoogleFonts.getFont('Montserrat',
                      // backgroundColor: Colors.black,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontStyle: FontStyle.normal,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 10
                      // backgroundColor: Colors.black
                      ),
                ),
              ),
            )
            ),
        body: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 350,
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
                        child: LoginComponent(globalContext),
                      ),
                    ),
                  ),
                  // Container(
                  //     height: 300,
                  //     color: Color.fromARGB(255, 255, 255, 255),
                  //     child: LoginLogo())
                ],
              ),
            )));
  }
}
