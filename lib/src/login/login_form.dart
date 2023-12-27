import 'package:diary/src/api_services/api_service.dart';
import 'package:diary/src/api_services/api_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginComponent extends StatelessWidget {
  final Map<String, TextStyle> loginStyles = {
    'loginLabel': const TextStyle(
        fontSize: 18.0, color: Color.fromARGB(255, 255, 255, 255)),
    'loginInputText': const TextStyle(color: Colors.white),
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
      home: LoginInputForm(loginStylesHelper: loginStyles),
    );
  }
}

class LoginInputForm extends StatefulWidget {
  const LoginInputForm({required this.loginStylesHelper});

  final Map<String, TextStyle> loginStylesHelper;

  @override
  LoginForm createState() => LoginForm(loginStylesHelper: loginStylesHelper);
}

class LoginForm extends State<LoginInputForm> {
  LoginForm({required this.loginStylesHelper});

  final storage = const FlutterSecureStorage();

// form contollers
  final loginFormGroup = GlobalKey<FormState>();
  final signUpFormGroup = GlobalKey<FormState>();
  TextEditingController profilenameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // multiple forms
  bool enableLoginForm = true;
  bool enableSignupForm = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginForm() async {
    if (loginFormGroup.currentState!.validate()) {
      // Form is valid, proceed with form submission
      // Access input values from controllers: _nameController.text, _emailController.text
      // Perform actions like sending data to a server, etc.
      // For example:
      print('Name: ${usernameController.text}');
      print('Email: ${passwordController.text}');

      final body = {
        'username': usernameController.text,
        'password': passwordController.text
      };
      final loginResponse = await apiService.login(body);
      print('Login Response ${loginResponse['success']}');
      if (loginResponse != null && loginResponse['success'] == true) {
        await storage.write(
            key: 'auth_token', value: loginResponse['data']['access_token']);
        await storage.write(
            key: 'username', value: loginResponse['data']['username']);
        await storage.write(
            key: 'profilename', value: loginResponse['data']['profilename']);
        await storage.write(
            key: 'email', value: loginResponse['data']['email']);

        // navigate to books view
      }
    }
  }

  Future<void> signUpForm() async {
    if (signUpFormGroup.currentState!.validate()) {
      // Form is valid, proceed with form submission
      // Access input values from controllers: _nameController.text, _emailController.text
      // Perform actions like sending data to a server, etc.
      // For example:
      print('Name: ${usernameController.text}');
      print('Email: ${passwordController.text}');

      final body = {
        'username': usernameController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'profilename': profilenameController.text,
      };
      final loginResponse = await apiService.singup(body);
      print('Login Response ${loginResponse['success']}');
      if (loginResponse != null && loginResponse['success'] == true) {
        // otp confirmation
      }
    }
  }

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
            Visibility(
                visible: enableLoginForm,
                child: Form(
                    key: loginFormGroup,
                    child: Column(
                      children: [
                        Text(
                          'User Name',
                          style: loginStylesHelper['loginLabel'],
                        ),
                        TextFormField(
                          style: loginStylesHelper['loginInputText'],
                          controller: usernameController,
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              usernameController.text =
                                  value.replaceAll(' ', '_');
                              usernameController.selection =
                                  TextSelection.collapsed(
                                      offset: usernameController.text.length);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }

                            return null;
                          },
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
                          controller: passwordController,
                          onChanged: (value) {
                            print(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          style: loginStylesHelper['loginInputText'],
                          // decoration: InputDecoration(
                          //     labelText: 'Password',
                          //     labelStyle: TextStyle(
                          //       color: Colors.white,
                          //     )),
                          obscureText: true,
                        ),
                      ],
                    ))),
            Visibility(
                visible: enableSignupForm,
                child: Form(
                    key: signUpFormGroup,
                    child: Column(
                      children: [
                        Text(
                          'Profile Name',
                          style: loginStylesHelper['loginLabel'],
                        ),
                        TextFormField(
                          style: loginStylesHelper['loginInputText'],
                          controller: profilenameController,
                          onChanged: (value) {
                            print(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your profile name';
                            }

                            return null;
                          },
                          // decoration: InputDecoration(
                          //     labelText: 'Email',
                          //     labelStyle: TextStyle(
                          //       color: Colors.white,
                          //     )),
                        ),
                        Text(
                          'Email',
                          style: loginStylesHelper['loginLabel'],
                        ),
                        TextFormField(
                          style: loginStylesHelper['loginInputText'],
                          controller: emailController,
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              emailController.text = value.replaceAll(' ', '');
                              emailController.selection =
                                  TextSelection.collapsed(
                                      offset: emailController.text.length);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }

                            return null;
                          },
                          // decoration: InputDecoration(
                          //     labelText: 'Email',
                          //     labelStyle: TextStyle(
                          //       color: Colors.white,
                          //     )),
                        ),
                        Text(
                          'User Name',
                          style: loginStylesHelper['loginLabel'],
                        ),
                        TextFormField(
                          style: loginStylesHelper['loginInputText'],
                          controller: usernameController,
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              usernameController.text =
                                  value.replaceAll(' ', '_');
                              usernameController.selection =
                                  TextSelection.collapsed(
                                      offset: usernameController.text.length);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }

                            return null;
                          },
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
                          controller: passwordController,
                          onChanged: (value) {
                            print(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          style: loginStylesHelper['loginInputText'],
                          // decoration: InputDecoration(
                          //     labelText: 'Password',
                          //     labelStyle: TextStyle(
                          //       color: Colors.white,
                          //     )),
                          obscureText: true,
                        ),
                      ],
                    ))),
            Center(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                              visible: enableLoginForm,
                              child: ElevatedButton(
                                onPressed: () {
                                  print('Clicked');
                                  loginForm();
                                },
                                child: const Text('Login'),
                              )),
                          Visibility(
                              visible: enableSignupForm,
                              child: ElevatedButton(
                                onPressed: () {
                                  print('Clicked');
                                  signUpForm();
                                },
                                child: const Text('Sign Up'),
                              )),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                enableLoginForm = !enableLoginForm;
                                enableSignupForm = !enableSignupForm;
                              });
                              print('Switched');
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
