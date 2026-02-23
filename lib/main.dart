import 'package:flutter/material.dart';
import 'Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(

        inputDecorationTheme: InputDecorationThemeData(
          fillColor: Colors.white,
          prefixIconColor: Colors.black,

        )
      ),

      home: MyHomePage(),
    );
  }
}

