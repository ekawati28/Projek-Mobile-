import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import '../../widgets/custom_dialog.dart';

class LupaPasswordPage3 extends StatefulWidget {
  const LupaPasswordPage3({
    super.key,
  });

  @override
  State<LupaPasswordPage3> createState() => _LupaPasswordPage3State();
}

class _LupaPasswordPage3State extends State<LupaPasswordPage3> {
  String userEmail = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();

  final supabase = Supabase.instance.client;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;

  @override
    void initState() {
      super.initState();

      final user =
          Supabase.instance.client.auth.currentUser;

        userEmail = user?.email ?? '';
    }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }


    if (_passwordController.text !=
        _confirmPasswordController.text) {

      showErrorDialog(
        context,
        'Konfirmasi password tidak cocok',
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // nanti isi update password Supabase di sini
      await supabase.auth.updateUser(
        UserAttributes(
          password: _passwordController.text,
        ),
      );

      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {

          return AlertDialog(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            contentPadding: const EdgeInsets.all(24),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF2E7D32),
                    size: 40,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Berhasil!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Password Anda berhasil diubah.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoginPage(),
                        ),

                        (route) => false,
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor:const Color(0xFF2463FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

    } catch (e) {

      setState(() {
        _isLoading = false;
      });

      showErrorDialog(
        context,
        'Gagal mengubah password',
      );
    }

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
                  horizontal: 55,
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
                            borderRadius: BorderRadius.circular(16),
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
                                  size: 20,
                                  color: Color(0xFF6B7280),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Kembali ke\nLogin',
                                  style: TextStyle(
                                    fontSize: 14,
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
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2463FF),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Icon(
                                  Icons.shield_outlined,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 7),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 24,
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

                      const SizedBox(height: 30),

                      // =====================================================
                      // ICON KUNCI
                      // =====================================================

                      Container(
                        width: 50,
                        height: 50,
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
                          size: 28,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // =====================================================
                      // JUDUL
                      // =====================================================

                      const Text(
                        'Reset Kata Sandi',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                          height: 1.15,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        'Silakan buat kata sandi baru untuk\nakun Anda.',
                        style: TextStyle(
                          fontSize: 17,
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
                          horizontal: 16,
                          vertical: 16,
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
                              size: 24,
                              color: Color(0xFF2463FF),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                userEmail,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
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
                          fontSize: 16,
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      TextFormField(
                        controller: _passwordController,

                        onChanged: (value) {
                          _formKey.currentState?.validate();
                        },

                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF374151),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Masukkan kata sandi baru',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade400,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            size: 24,
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
                              size: 24,
                              color: const Color(0xFF9AA8BC),
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFD),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
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

                      const SizedBox(height: 20),

                      // =====================================================
                      // KONFIRMASI KATA SANDI
                      // =====================================================

                      const Text(
                        'Konfirmasi Kata Sandi',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      TextFormField(
                        controller: _confirmPasswordController,

                        onChanged: (value) {
                          _formKey.currentState?.validate();
                        },

                        obscureText: _obscureConfirmPassword,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF374151),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ulangi kata sandi baru',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade400,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            size: 24,
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
                              size: 24,
                              color: const Color(0xFF9AA8BC),
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFD),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
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
                        height: 70,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2463FF),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: const Color(0x332463FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              if (_isLoading)
                                const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )

                              else ...[

                                const Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                const Icon(
                                  Icons.arrow_forward,
                                  size: 24,
                                  color: Colors.white,
                                ),

                              ]

                            ],
                          ),
                        ),
                      ),

                      // =====================================================
                      // FOOTER
                      // =====================================================

                      const SizedBox(height: 40),

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
                              fontSize: 14,
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
