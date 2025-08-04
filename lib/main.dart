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
      
      // เพิ่มการตั้งค่า Locale สำหรับภาษาไทย
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English
        Locale('th', ''), // Thai
      ],
      locale: Locale('th', ''), // ตั้งค่าเป็นภาษาไทยเป็นหลัก
      
      theme: ThemeData(
        primarySwatch: Colors.green,
        // เพิ่ม Thai font
        fontFamily: 'Sarabun', // หรือใช้ default ที่รองรับไทย
        

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