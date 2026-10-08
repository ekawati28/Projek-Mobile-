import 'package:flutter/material.dart';
import 'views/auth/lupa_password_page2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusReport',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF003399)),
        useMaterial3: true,
      ),
      home: const LupaPasswordPage2(),
    );
  }
}