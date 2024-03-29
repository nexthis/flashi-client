import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashi_client/src/main/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controlers/mause_view.dart';
import 'controlers/music_view.dart';
import 'controlers/presentation_view.dart';
import 'login/login_view.dart';
import 'main/main_view.dart';
import 'main/example/settings_view.dart';
import 'themes/base.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> _sub;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    _sub = FirebaseAuth.instance.userChanges().listen((event) {
      _navigatorKey.currentState?.pushReplacementNamed(
        event != null ? MainView.routeName : LoginView.routeName,
      );
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MaterialApp(
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',

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
      theme: BaseTheme.themeData(BaseTheme.whiteColorScheme),
      darkTheme: BaseTheme.themeData(BaseTheme.darkColorScheme),
      themeMode: ThemeMode.dark,

      navigatorKey: _navigatorKey,
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? LoginView.routeName
          : MainView.routeName,
      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case MouseControl.routeName:
                return const MouseControl();
              case MusicControl.routeName:
                return const MusicControl();
              case PresentationControl.routeName:
                return const PresentationControl();
              case MainView.routeName:
                return const MainView();
              case LoginView.routeName:
                return const LoginView();
              default:
                return const DashboardView();
            }
          },
        );
      },
    );
  }
}
