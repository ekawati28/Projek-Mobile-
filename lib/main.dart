import 'package:flutter/material.dart';
import 'views/auth/lupa_password_page3.dart';

void main() {
  runApp(const CampusReportApp());
}

class CampusReportApp extends StatelessWidget {
  const CampusReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusReport',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
      ),
      home: const LupaPasswordPage3(
        email: 'mahasiswa@gmail.com',
      ),
    );
  }
}
