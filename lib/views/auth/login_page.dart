import 'package:flutter/material.dart';
import 'register_page.dart';
import 'lupa_password_page1.dart';
import 'lupa_password_page2.dart';
import 'lupa_password_page3.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_dialog.dart';
import '../mahasiswa/dashboard_page.dart';


class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Untuk show / hide password
  bool isPasswordHidden = true;
  bool isLoading = false;

  final AuthController authController = AuthController();
  
  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> login() async {
    String email =
        emailController.text.trim();

    String password =
        passwordController.text;

    bool isValid = true;

    setState(() {
      emailError = null;
      passwordError = null;

      if(email.isEmpty){
        emailError =
            "Email wajib diisi";
        isValid = false;
      }

      if(password.isEmpty){
        passwordError =
            "Password wajib diisi";
        isValid = false;
      }
    });

    if(!isValid){
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await authController.login(
        email: email,
        password: password,
      );

      if (response.user != null) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        debugPrint('Login berhasil');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardPage(),
          ),
        );
      }

    } catch (e) {
      setState(() {
        isLoading = false;
      });

      String message = "Login gagal";
      if (e.toString().contains(
          "Invalid login credentials")) {
        message =
            "Email atau password tidak sesuai";
      }

      if (e.toString().contains(
          "Email not confirmed")) {
        message =
            "Email belum dikonfirmasi";
      }

      showErrorDialog(
        context,
        message,
      );
    }
  }

  void forgotPassword() {
    showForgotPasswordDialog(context);
    showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) {
      return const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ForgotPasswordDialog(),
      );
    },
  );
}
  

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 38),
                Row(
                  children: [
                    // Logo
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1769FF),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: Colors.white,
                        size: 29,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Nama aplikasi
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Campus',
                                style: TextStyle(
                                  color: Color(0xFF111827),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'Report',
                                style: TextStyle(
                                  color: Color(0xFF1769FF),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Universitas Khairun',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Selamat Datang ',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '👋',
                        style: TextStyle(
                          fontSize: 27,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Masuk dengan akun civitas\n'
                  'akademika untuk melaporkan dan\n'
                  'memantau fasilitas kampus.',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 17,
                    height: 1.7,
                  ),
                ),

                const SizedBox(height: 26),

                const Text(
                  'Email',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),
                
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,

                  onChanged: (value) {
                    if (emailError != null || passwordError != null) {
                      setState(() {
                        emailError = null;
                        passwordError = null;
                      });
                    }
                  },

                  decoration: InputDecoration(
                    hintText: 'Masukkan email Anda',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF8CA1BF),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 17,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: const BorderSide(
                        color: Color(0xFFDCE4EF),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide(
                        color: emailError != null
                        ? Colors.red
                        : const Color(0xFFDCE4EF),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide(
                        color: emailError != null
                        ? Colors.red
                        : const Color(0xFFDCE4EF),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                if (emailError != null)

                  Padding(
                    padding:
                        const EdgeInsets.only(
                          left: 16,
                          top: 5,
                        ),

                    child: Text(
                      emailError!,

                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),

                const SizedBox(height: 22),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: forgotPassword,
                      child: const Text(
                        'Lupa Password?',
                        style: TextStyle(
                          color: Color(0xFF1769FF),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: isPasswordHidden,

                  onChanged: (value) {
                    if (passwordError != null || emailError != null) {
                      setState(() {
                        passwordError = null;
                        emailError = null;
                      });
                    }
                  },

                  decoration: InputDecoration(
                    hintText: 'Masukkan kata sandi Anda',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF8CA1BF),
                    ),

                    // Tombol mata
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF8CA1BF),
                      ),
                    ),

                    filled: true,

                    fillColor: const Color(0xFFF8FAFC),

                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 17,
                      horizontal: 16,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: const BorderSide(
                        color: Color(0xFFDCE4EF),
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide(
                        color: passwordError != null
                        ? Colors.red
                        : const Color(0xFFDCE4EF),
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide(
                        color: passwordError != null
                        ? Colors.red
                        : const Color(0xFFDCE4EF),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                if (passwordError != null)
                  Padding(
                    padding:
                        const EdgeInsets.only(
                          left: 16,
                          top: 5,
                        ),

                    child: Text(
                      passwordError!,

                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),

                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1769FF),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: const Color(0x551769FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        if (isLoading)

                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )

                        else
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                      ),
                      children: [

                        const TextSpan(
                          text: 'Belum punya akun? ',
                        ),

                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: register,
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                color: Color(0xFF1769FF),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
