import 'package:flutter/material.dart';
import 'views/mahasiswa/detail_laporan_page.dart';
import 'views/mahasiswa/riwayat_laporan.dart';
import 'views/mahasiswa/admin/dashboard_admin.dart';
import 'views/mahasiswa/admin/profile_admin.dart';

void main() {
  runApp(const CampusReportPreviewApp());
}

class CampusReportPreviewApp extends StatelessWidget {
  const CampusReportPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusReport Preview',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
      ),
      home: const DashboardAdminScreen(),
    );
  }
}
