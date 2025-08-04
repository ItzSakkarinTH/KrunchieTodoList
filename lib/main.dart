import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KruNchie Todo App',

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English
        Locale('th', ''), // Thai
      ],
      locale: Locale('th', ''),

      theme: ThemeData(
        primarySwatch: Colors.green,

        fontFamily: 'Sarabun',

        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Sarabun'),
          bodyMedium: TextStyle(fontFamily: 'Sarabun'),
          titleLarge: TextStyle(fontFamily: 'Sarabun'),
          titleMedium: TextStyle(fontFamily: 'Sarabun'),
          titleSmall: TextStyle(fontFamily: 'Sarabun'),
        ),
      ),

      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
