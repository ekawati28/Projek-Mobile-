import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController konfirmasiController = TextEditingController();

  final AuthController authController = AuthController();

  String? namaError;
  String? emailError;
  String? passwordError;
  String? konfirmasiError;

  bool isPasswordHidden = true;
  bool isKonfirmasiHidden = true;
  bool isLoading = false;

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    konfirmasiController.dispose();
    super.dispose();
  }

  Widget requiredLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: const TextStyle(
                color: Color(0xff12233F),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(
              text: " *",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputField(
    String hint,
    IconData icon, {
    required TextEditingController controller,
    bool password = false,
    bool isHidden = true,
    VoidCallback? onVisibilityPressed,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
        height: 58,
        margin: const EdgeInsets.only(bottom: 5),
        child: TextField(
          controller: controller,
          obscureText: password && isHidden,
          keyboardType: password
              ? TextInputType.visiblePassword
              : icon == Icons.email_outlined
                  ? TextInputType.emailAddress
                  : TextInputType.text,

          onChanged: (value) {

            if (errorText != null) {
              setState(() {

                if (controller == namaController) {
                  namaError = null;
                }

                if (controller == emailController) {
                  emailError = null;
                }

                if (controller == passwordController) {
                  passwordError = null;
                }

                if (controller == konfirmasiController) {
                  konfirmasiError = null;
                }
              });
            }
          },

          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xff91A3BE),
              fontSize: 16,
            ),
            prefixIcon: Icon(
              icon,
              size: 23,
              color: const Color(0xff91A3BE),
            ),
            suffixIcon: password
                ? IconButton(
                    onPressed: onVisibilityPressed,
                    icon: Icon(
                      isHidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 23,
                      color: const Color(0xff91A3BE),
                    ),
                  )
                : null,
            filled: true,
            fillColor: const Color(0xffF8FAFD),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 17,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
              color: errorText != null
                  ? Colors.red
                  : const Color(0xffDCE5F2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
              color: errorText != null
                  ? Colors.red
                  : const Color(0xffDCE5F2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
              color: errorText != null
                  ? Colors.red
                  : const Color(0xffDCE5F2),
              ),
            ),
          ),
        ),
      ),
      if (errorText != null)
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            bottom: 8,
            top: 2,
          ),

          child: Text(
            errorText,

            style: const TextStyle(
              color: Colors.red,
              fontSize: 14,
              height: 1.2,
            ),
          ),
        ),
      ],
      );
    }

  Future<void> daftar() async {
    String nama = namaController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String konfirmasi = konfirmasiController.text;

    setState(() {
      namaError = null;
      emailError = null;
      passwordError = null;
      konfirmasiError = null;
    });

    bool isValid = true;

    setState(() {
    if (nama.isEmpty) {
      namaError = "Nama wajib diisi";
      isValid = false;
    }

    if (email.isEmpty) {
      emailError = "Email wajib diisi";
      isValid = false;
    }

    if (password.isEmpty) {
      passwordError = "Password wajib diisi";
      isValid = false;
    }

    if (konfirmasi.isEmpty) {
      konfirmasiError =
          "Konfirmasi password wajib diisi";
      isValid = false;
    }

    });

    if (!isValid) {
      return;
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email)) {
      setState(() {
        emailError = "Format email tidak valid";
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        passwordError =
            "Password minimal 6 karakter";
      });
      return;
    }

    if (password != konfirmasi) {
      setState(() {
        konfirmasiError =
            "Password tidak sama";
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await authController.register(
        nama: nama,
        email: email,
        password: password,
      );


      if (response.user != null) {

        setState(() {
          isLoading = false;
        });

        showSuccessDialog(
          context,
          'Pendaftaran berhasil',
          onPressed: () {
            Navigator.pop(context);
          },
        );
      }

    } catch (e) {
      setState(() {
        isLoading = false;
      });

      showErrorDialog(
        context,
        'Pendaftaran gagal',
      );
    }

    // Tambahkan proses penyimpanan akun ke backend di sini.
  }

  void kembaliLogin() {
    Navigator.pop(context);
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

                // HEADER
                Row(
                  children: [
                    InkWell(
                      onTap: kembaliLogin,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xffF8FAFD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xffDCE5F2),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Color(0xff4B5D78),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xff1E5EFF),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: Colors.white,
                        size: 29,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Campus",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff111827),
                              ),
                            ),
                            TextSpan(
                              text: "Report",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1E5EFF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // JUDUL
                const Text(
                  "Daftar Akun Mahasiswa 📝",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff071A38),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Lengkapi data diri untuk membuat\n"
                  "akun pelaporan fasilitas kampus.",
                  style: TextStyle(
                    color: Color(0xff647897),
                    fontSize: 17,
                    height: 1.7,
                  ),
                ),

                const SizedBox(height: 26),

                // NAMA LENGKAP
                requiredLabel("Nama Lengkap"),

                inputField(
                  "Masukkan nama lengkap Anda",
                  Icons.person_outline,
                  controller: namaController,
                  errorText: namaError,
                ),

                // EMAIL
                requiredLabel("Email"),

                inputField(
                  "contoh@gmail.com",
                  Icons.email_outlined,
                  controller: emailController,
                  errorText: emailError,
                ),

                // PASSWORD
                requiredLabel("Password"),

                inputField(
                  "Minimal 6 karakter",
                  Icons.lock_outline,
                  controller: passwordController,
                  password: true,
                  isHidden: isPasswordHidden,
                  errorText: passwordError,
                  onVisibilityPressed: () {
                    setState(() {
                      isPasswordHidden = !isPasswordHidden;
                    });
                  },
                ),

                // KONFIRMASI PASSWORD
                requiredLabel("Konfirmasi Password"),

                inputField(
                  "Ulangi kata sandi Anda",
                  Icons.lock_outline,
                  controller: konfirmasiController,
                  password: true,
                  isHidden: isKonfirmasiHidden,
                  errorText: konfirmasiError,
                  onVisibilityPressed: () {
                    setState(() {
                      isKonfirmasiHidden = !isKonfirmasiHidden;
                    });
                  },
                ),

                const SizedBox(height: 2),

                // TOMBOL DAFTAR
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff1E5EFF).withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : daftar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1E5EFF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
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
                            "Daftar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // SUDAH PUNYA AKUN
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        "Sudah punya akun? ",
                        style: TextStyle(
                          color: Color(0xff647897),
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: kembaliLogin,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Color(0xff1E5EFF),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
