import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';
  final storage = const FlutterSecureStorage();

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Column(children: [
          Padding(
              padding: const EdgeInsets.all(16),
              // Glue the SettingsController to the theme selection DropdownButton.
              //
              // When a user selects a theme from the dropdown list, the
              // SettingsController is updated, which rebuilds the MaterialApp.
              child: Column(
                children: [
                  DropdownButton<ThemeMode>(
                    // Read the selected themeMode from the controller
                    value: controller.themeMode,
                    // Call the updateThemeMode method any time the user selects a theme.
                    onChanged: controller.updateThemeMode,
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text(
                          'Syestm Style',
                          style: TextStyle(
                              color: Color.fromARGB(227, 178, 233, 139),
                              backgroundColor: Colors.black),
                        ),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light Theme'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark Theme'),
                      )
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async => {
                            await storage.deleteAll(),
                            Navigator.pushNamed(context, '/login')
                          },
                      child: Text('Logout'))
                ],
              )),
        ]));
  }
}
