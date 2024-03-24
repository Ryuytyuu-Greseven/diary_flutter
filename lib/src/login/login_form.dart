import 'package:diary/src/api_services/api_service.dart';
import 'package:diary/src/api_services/api_settings.dart';
import 'package:diary/src/book/books_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginComponent extends StatelessWidget {
  final BuildContext globalContext;

  LoginComponent(this.globalContext);

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // No direct named parameters in textTheme, so defining a custom map of styles
        // This custom map can be used throughout the app
        brightness: Brightness.light,
        textTheme: const TextTheme(
            // Define default text styles if needed
            ),
      ),
      home: LoginInputForm(
          loginStylesHelper: loginStyles, globalContext1: globalContext),
    );
  }
}

class LoginInputForm extends StatefulWidget {
  final BuildContext globalContext1;

  const LoginInputForm(
      {required this.loginStylesHelper, required this.globalContext1});

  final Map<String, TextStyle> loginStylesHelper;

  @override
  LoginForm createState() => LoginForm(
      loginStylesHelper: loginStylesHelper, globalContext2: globalContext1);
}

class LoginForm extends State<LoginInputForm> {
  final BuildContext globalContext2;

  LoginForm({required this.loginStylesHelper, required this.globalContext2});

  final storage = const FlutterSecureStorage();

// form contollers
  final loginFormGroup = GlobalKey<FormState>();
  final signUpFormGroup = GlobalKey<FormState>();
  TextEditingController profilenameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // OTP
  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  late List<TextEditingController> otpControllers;

  // multiple forms
  bool enableLoginForm = true;
  bool enableSignupForm = false;
  bool enableOtpForm = false;
  bool invalidCredentials = false;
  String errorMessage = '';

// data to process
  static String userIdToProcess = '';

// initial state
  @override
  void initState() {
    super.initState();

    // generating multiple controllers for otp
    otpControllers = List.generate(4, (index) => TextEditingController());
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    profilenameController.dispose();
    emailController.dispose();

    // disposing all the otp controllers
    for (var singleOtpController in otpControllers) {
      singleOtpController.dispose();
    }

    super.dispose();
  }

  Future<void> loginForm(BuildContext context) async {
    if (loginFormGroup.currentState!.validate()) {
      // Form is valid, proceed with form submission
      // Access input values from controllers: _nameController.text, _emailController.text
      // Perform actions like sending data to a server, etc.
      // For example:
      print('Name: ${usernameController.text}');
      // print('Email: ${passwordController.text}');

      final body = {
        'username': usernameController.text,
        'password': passwordController.text
      };
      final loginResponse = await apiService.login(body, context);
      print('Login Response ${loginResponse['success']}');
      if (loginResponse != null && loginResponse['success'] == true) {
        invalidCredentials = false;
        errorMessage = '';
        await storage.write(
            key: 'auth_token', value: loginResponse['data']['access_token']);
        await storage.write(
            key: 'username', value: loginResponse['data']['username']);
        await storage.write(
            key: 'profilename', value: loginResponse['data']['profilename']);
        await storage.write(
            key: 'email', value: loginResponse['data']['email']);

        // navigate to books view
        Navigator.pushNamed(
          context,
          '/books-catalog',
        );
      } else {
        setState(() {
          invalidCredentials = true;
          errorMessage = loginResponse['message'];
        });
      }
    }
  }

// user sign up form
  Future<void> signUpForm() async {
    if (signUpFormGroup.currentState!.validate()) {
      // Form is valid, proceed with form submission
      // Access input values from controllers: _nameController.text, _emailController.text
      // Perform actions like sending data to a server, etc.
      // For example:
      print('Name: ${usernameController.text}');
      // print('Email: ${passwordController.text}');

      final body = {
        'username': usernameController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'profilename': profilenameController.text,
      };
      final loginResponse = await apiService.singup(body, context);
      print('Signup Response ${loginResponse['success']}');
      if (loginResponse != null && loginResponse['success'] == true) {
        print('In Success');
        setState(() {
          userIdToProcess = loginResponse['userId'];
        });
        // otp confirmation
        switchOtp();
      } else {
        setState(() {
          invalidCredentials = true;
          errorMessage = loginResponse['message'];
        });
      }
    }
  }

// verify OTP of a user
  Future<void> verifyOtpForm() async {
    String otp = '';
    for (var index = 0; index < 4; index++) {
      otp += otpControllers[index].text;
    }

    final body = {
      'userId': userIdToProcess,
      'otp': otp,
    };

    final otpResponse = await apiService.verifyUser(body, context);
    if (otpResponse != null && otpResponse['success']) {
      print('OTP verified');
      setState(() {
        userIdToProcess = '';
        enableLoginForm = true;
        enableOtpForm = false;
        enableSignupForm = false;
        invalidCredentials = false;
        errorMessage = '';
      });
    }
  }

// switch logins
  Future<void> switchForm() async {
    setState(() {
      enableLoginForm = !enableLoginForm;
      enableSignupForm = !enableSignupForm;
      invalidCredentials = false;
      errorMessage = '';
      // enableOtpForm = !enableOtpForm;
    });
  }

// switch to otp form
  Future<void> switchOtp() async {
    setState(() {
      enableOtpForm = true;
      enableSignupForm = false;
      invalidCredentials = false;
      errorMessage = '';
    });
  }

  static const wheatColor = Color(0xFFf5deb3);
  static const loginCardCol = Color.fromARGB(255, 51, 51, 51);

  final Map<String, TextStyle> loginStylesHelper;

  // api services
  final apiService = ApiService();

// single otp field
  Widget otpField(int index) {
    return Container(
      width: 50.0,
      child: TextField(
        style: loginStylesHelper['loginInputText'],
        controller: otpControllers[index],
        // keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        focusNode: focusNodes[index],
        onChanged: (value) {
          if (value.isNotEmpty && index < focusNodes.length - 1) {
            FocusScope.of(context).requestFocus(focusNodes[index + 1]);
          }
        },
        decoration: const InputDecoration(
          counter: Offstage(),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

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
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   'Login',
            //   style: TextStyle(color: wheatColor),
            // ),
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
                          // Disable the paste button
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: ''));
                          },

                          ///enableInteractiveSelection: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9_ ]')),
                            FilteringTextInputFormatter.deny(RegExp(r'')),
                          ],
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
                          // Disable the paste button
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: ''));
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9_@ ]')),
                            FilteringTextInputFormatter.deny(RegExp(r'')),
                          ],

                          ///enableInteractiveSelection: false,
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

                          // Disable the paste button
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: ''));
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9_ ]')),
                            FilteringTextInputFormatter.deny(RegExp(r'')),
                          ],

                          ///enableInteractiveSelection: false,
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

                          // Disable the paste button
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: ''));
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9_ ]')),
                            FilteringTextInputFormatter.deny(RegExp(r'')),
                          ],

                          ///enableInteractiveSelection: false,
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

                          // Disable the paste button
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: ''));
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9_ ]')),
                            FilteringTextInputFormatter.deny(RegExp(r'')),
                          ],

                          ///enableInteractiveSelection: false,
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

                          // Disable the paste button
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: ''));
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9_@ ]')),
                            FilteringTextInputFormatter.deny(RegExp(r'')),
                          ],

                          ///enableInteractiveSelection: false,
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
                visible: enableOtpForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Entre OTP',
                      style: loginStylesHelper['loginLabel'],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        otpField(0),
                        otpField(1),
                        otpField(2),
                        otpField(3)
                      ],
                    )
                  ],
                )),
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
                                  try {
                                    loginForm(globalContext2);
                                  } catch (e) {
                                    print('Error got that : ${e}');
                                  }

                                  print('Clicked');
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
                          Visibility(
                            visible: enableLoginForm || enableSignupForm,
                            child: ElevatedButton(
                              onPressed: () {
                                switchForm();
                                print('Switch');
                              },
                              child: const Text('Switch'),
                            ),
                          ),
                          Visibility(
                            visible: enableOtpForm,
                            child: ElevatedButton(
                              onPressed: () {
                                verifyOtpForm();
                                print('Verify');
                              },
                              child: const Text('Verify'),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
            Visibility(
                visible: invalidCredentials,
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ))
          ],
        ),
      )),
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
