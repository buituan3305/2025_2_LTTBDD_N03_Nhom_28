import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' Quản Lý Tài Chính',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomeScreen(), // trỏ về homescreen
    );
  }
}
