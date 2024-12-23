import 'package:diary/src/book/books_catalog.dart';
import 'package:diary/src/book/single_book.dart';
import 'package:diary/src/login/login_form.dart';
import 'package:diary/src/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.

// global context changes
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;
  static const storage = FlutterSecureStorage();

  Future<Widget> initialState(BuildContext context,
      {required BuildContext globalContext}) async {
    // fetch user details and navigate to books
    final accessToken = await storage.read(key: 'auth_token');
    print('access token:${accessToken}');
    if (accessToken == null || accessToken.toString().isEmpty) {
      return LoginScreen(globalContext: globalContext);
    } else {
      return BooksCatalog(globalContext: globalContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',
          debugShowCheckedModeBanner: false,

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          // routes: {
          //   '/': (context) => LoginComponent(context),
          //   // '/login': (context) => LoginComponent(context),
          //   '/books-catalog': (context) => const BooksCatalog()
          // },
          navigatorKey: navigatorKey,
          onGenerateRoute: (RouteSettings routeSettings) {
            final finalRoute = routeSettings.name?.split('/')[1];
            final uri = Uri.parse(routeSettings.name ?? '');
            final pathSegments = uri.pathSegments;

            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                print(
                    'route details ${routeSettings.name} ${finalRoute} ${pathSegments}');
                if (SettingsView.routeName.isNotEmpty &&
                    SettingsView.routeName == routeSettings.name) {
                  return SettingsView(controller: settingsController);
                } else if (SampleItemDetailsView.routeName.isNotEmpty &&
                    SampleItemDetailsView.routeName == routeSettings.name) {
                  return const SampleItemDetailsView();
                } else if (pathSegments?.length == 1 &&
                    BooksCatalog.routeName.isNotEmpty &&
                    BooksCatalog.routeName == routeSettings.name) {
                  print('I am here ${pathSegments}');
                  return BooksCatalog(globalContext: context);
                } else if (pathSegments?.length == 2 &&
                    '/${pathSegments[0]}' == BooksCatalog.routeName) {
                  print('single book');
                  return SingleBook(
                      bookId: pathSegments[1], globalContext: context);
                } else {
                  print('Check me');
                  return FutureBuilder<Widget>(
                    future: initialState(context, globalContext: context),
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return snapshot.data ??
                            Container(); // Return the widget from initialState
                      }
                    },
                  );
                }
              },
            );
          },
          // home: LoginComponent(),
        );
      },
    );
  }
}
