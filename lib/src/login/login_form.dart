import 'package:diary/src/api_services/api_service.dart';
import 'package:diary/src/api_services/api_settings.dart';
import 'package:flutter/material.dart';

class LoginComponent extends StatelessWidget {
  final Map<String, TextStyle> loginStyles = {
    'loginLabel': const TextStyle(
        fontSize: 18.0, color: Color.fromARGB(255, 255, 255, 255)),
    'errorLabel': const TextStyle(
        fontSize: 16.0, color: Color.fromARGB(255, 247, 118, 118)),
    // Add other named text styles as needed
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // No direct named parameters in textTheme, so defining a custom map of styles
        // This custom map can be used throughout the app
        brightness: Brightness.light,
        textTheme: const TextTheme(
            // Define default text styles if needed
            ),
      ),
      home: LoginForm(loginStylesHelper: loginStyles),
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({required this.loginStylesHelper});

  static const wheatColor = Color(0xFFf5deb3);
  static const loginCardCol = Color.fromARGB(255, 51, 51, 51);

  final Map<String, TextStyle> loginStylesHelper;

  // api services
  final apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Login'),
        // ),
        body: Container(
      color: loginCardCol,
      padding: EdgeInsets.all(15),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(color: wheatColor),
            ),
            Text(
              'User Name',
              style: loginStylesHelper['loginLabel'],
            ),
            TextFormField(
                // decoration: InputDecoration(
                //     labelText: 'Email',
                //     labelStyle: TextStyle(
                //       color: Colors.white,
                //     )),
                ),
            Text(
              'Password',
              style: loginStylesHelper['loginLabel'],
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              // decoration: InputDecoration(
              //     labelText: 'Password',
              //     labelStyle: TextStyle(
              //       color: Colors.white,
              //     )),
              obscureText: true,
            ),
            Center(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              print('Clicked');
                              this.apiService.login({'body': 'test'});
                            },
                            child: const Text('Login'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Implement login logic here
                            },
                            child: const Text('Switch'),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    ));
  }
}

// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextFormField(
//             decoration: InputDecoration(labelText: 'Email'),
//           ),
//           TextFormField(
//             decoration: InputDecoration(labelText: 'Password'),
//             obscureText: true,
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Implement login logic
//             },
//             child: Text('Login'),
//           ),
//         ],
//       ),
//     );
//   }
// }
