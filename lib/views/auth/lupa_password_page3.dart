import 'package:flutter/material.dart';
import 'login_page.dart';

class LupaPasswordPage3 extends StatefulWidget {
  const LupaPasswordPage3({
    super.key,
    this.email = 'mahasiswa@gmail.com',
  });

  final String email;

  @override
  State<LupaPasswordPage3> createState() => _LupaPasswordPage3State();
}

class _LupaPasswordPage3State extends State<LupaPasswordPage3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password berhasil diubah.'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // =====================================================
                      // HEADER
                      // =====================================================

                      Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder:  (context) => LoginPage(),
                                ),
                                (route) => false,
                              );
                             
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.arrow_back,
                                  size: 18,
                                  color: Color(0xFF6B7280),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Kembali ke\nLogin',
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.15,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // Logo CampusReport
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2463FF),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Icon(
                                  Icons.shield_outlined,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ),
                              const SizedBox(width: 7),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Campus',
                                      style: TextStyle(
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Report',
                                      style: TextStyle(
                                        color: Color(0xFF2463FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // =====================================================
                      // ICON KUNCI
                      // =====================================================

                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F5FF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFDCE7FF),
                          ),
                        ),
                        child: const Icon(
                          Icons.key_outlined,
                          color: Color(0xFF2463FF),
                          size: 20,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // =====================================================
                      // JUDUL
                      // =====================================================

                      const Text(
                        'Reset Kata Sandi',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                          height: 1.15,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        'Silakan buat kata sandi baru untuk\nakun Anda.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Colors.grey.shade500,
                        ),
                      ),

                      const SizedBox(height: 17),

                      // =====================================================
                      // EMAIL MAHASISWA
                      // =====================================================

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE1E7F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.mail_outline,
                              size: 18,
                              color: Color(0xFF2463FF),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                widget.email,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF374151),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF1FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Mahasiswa',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF2463FF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // =====================================================
                      // KATA SANDI BARU
                      // =====================================================

                      const Text(
                        'Kata Sandi Baru',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF374151),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Masukkan kata sandi baru',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            size: 18,
                            color: Color(0xFF9AA8BC),
                          ),
                          suffixIcon: IconButton(
                            splashRadius: 18,
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: const Color(0xFF9AA8BC),
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFD),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE1E7F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE1E7F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF2463FF),
                              width: 1.3,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kata sandi wajib diisi';
                          }

                          if (value.length < 6) {
                            return 'Minimal 6 karakter';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      // =====================================================
                      // KONFIRMASI KATA SANDI
                      // =====================================================

                      const Text(
                        'Konfirmasi Kata Sandi',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF374151),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ulangi kata sandi baru',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            size: 18,
                            color: Color(0xFF9AA8BC),
                          ),
                          suffixIcon: IconButton(
                            splashRadius: 18,
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: const Color(0xFF9AA8BC),
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFD),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE1E7F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE1E7F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF2463FF),
                              width: 1.3,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi kata sandi wajib diisi';
                          }

                          if (value != _passwordController.text) {
                            return 'Kata sandi tidak cocok';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      // =====================================================
                      // TOMBOL RESET PASSWORD
                      // =====================================================

                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2463FF),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: const Color(0x332463FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Reset Password',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 7),
                              Icon(
                                Icons.arrow_forward,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // =====================================================
                      // FOOTER
                      // =====================================================

                      const SizedBox(height: 25),

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8,
                          ),
                          child: Text(
                            'Universitas Khairun • Sistem Informasi\n'
                            'Pelaporan Kampus',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              height: 1.35,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
