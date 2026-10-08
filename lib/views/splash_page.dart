import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Animasi fade in
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // Pindah ke Login setelah 5 detik
    _timer = Timer(
      const Duration(seconds: 5),
      () {
        if (!mounted) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>  LoginPage(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2563EB);
    const Color successGreen = Color(0xFF10B981);
    const Color accentPurple = Color(0xFF8B5CF6);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,

          child: Column(
            children: [

              const SizedBox(height: 40),

              // UNIVERSITAS KHAIRUN
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primaryBlue.withOpacity(0.2),
                  ),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Icon(
                      Icons.account_balance,
                      size: 16,
                      color: primaryBlue,
                    ),

                    const SizedBox(width: 6),

                    const Text(
                      'UNIVERSITAS KHAIRUN',
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // LOGO
              Container(
                width: 130,
                height: 130,

                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(28),

                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.3),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: Stack(
                  alignment: Alignment.center,

                  children: [

                    const Icon(
                      Icons.shield,
                      size: 65,
                      color: Colors.white,
                    ),

                    Positioned(
                      bottom: 8,
                      right: 8,

                      child: Container(
                        padding: const EdgeInsets.all(5),

                        decoration: const BoxDecoration(
                          color: successGreen,
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // CAMPUS REPORT
              RichText(
                text: const TextSpan(
                  children: [

                    TextSpan(
                      text: 'Campus',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    TextSpan(
                      text: 'Report',
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'SISTEM FASILITAS KAMPUS',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.5,
                ),
              ),

              const SizedBox(height: 32),

              // QUOTE
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 32,
                ),

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),

                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                  ),
                ),

                child: const Text(
                  '"Laporkan, Pantau, dan Wujudkan Kampus yang Lebih Baik."',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // FITUR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  _FeatureBadge(
                    icon: Icons.flash_on,
                    label: 'Cepat',
                    color: primaryBlue,
                  ),

                  const SizedBox(width: 10),

                  _FeatureBadge(
                    icon: Icons.verified,
                    label: 'Terverifikasi',
                    color: successGreen,
                  ),

                  const SizedBox(width: 10),

                  _FeatureBadge(
                    icon: Icons.track_changes,
                    label: 'Terpantau',
                    color: accentPurple,
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // LOADING
              const SizedBox(
                width: 28,
                height: 28,

                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: primaryBlue,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Memuat sistem fasilitas...',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'v1.0.0 • Biro Sarana Prasarana Unkhair',
                style: TextStyle(
                  color: Color(0xFFD1D5DB),
                  fontSize: 10,
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}


class _FeatureBadge extends StatelessWidget {

  final IconData icon;
  final String label;
  final Color color;

  const _FeatureBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.1),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: color.withOpacity(0.25),
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            icon,
            size: 14,
            color: color,
          ),

          const SizedBox(width: 5),

          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}