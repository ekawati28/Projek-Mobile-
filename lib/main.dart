import 'package:campusreport/views/admin/petugas_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabese_config.dart';
import 'views/splash_page.dart';
import 'views/auth/lupa_password_page3.dart';
import 'views/mahasiswa/detail_laporan_page.dart';
import 'views/mahasiswa/riwayat_laporan.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    debugPrint('AUTH EVENT: ${data.event}');

    if (data.event == AuthChangeEvent.passwordRecovery) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LupaPasswordPage3(),
        ),
      );
    }

    if (data.event == AuthChangeEvent.initialSession &&
        data.session != null) {
      debugPrint('INITIAL SESSION ADA');
    }
  });

  runApp(const CampusReportApp());
}

class CampusReportApp extends StatelessWidget {
  const CampusReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'CampusReport',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
      ),
      home: const PetugasPage(),
    );
  }
}
