import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabese_config.dart';
import 'views/splash_page.dart';
import 'views/auth/lupa_password_page3.dart';
import 'views/mahasiswa/dashboard_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool isPasswordRecovery = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  Supabase.instance.client.auth.onAuthStateChange.listen(
    (data) {
      print(
        "AUTH EVENT: ${data.event}",
      );

      if (data.event == AuthChangeEvent.passwordRecovery) {
        print(
          "PASSWORD RECOVERY EVENT",
        );

        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (_) => const LupaPasswordPage3(),
          ),
        );
      }

      if (data.event == AuthChangeEvent.initialSession) {
        final session = data.session;

        if (session != null) {
          print(
            "INITIAL SESSION ADA",
          );

          // cek apakah ini recovery
          if (session.user.email != null) {
            isPasswordRecovery = true;
          }
        }
      }
    },
  );

  runApp(const CampusReportApp());
}

class CampusReportApp extends StatelessWidget {
  const CampusReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'CampusReport',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}
