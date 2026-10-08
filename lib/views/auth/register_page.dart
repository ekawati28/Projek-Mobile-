import 'package:flutter/material.dart';

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

  bool isPasswordHidden = true;
  bool isKonfirmasiHidden = true;

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
  }) {
    return Container(
      height: 58,
      margin: const EdgeInsets.only(bottom: 22),
      child: TextField(
        controller: controller,
        obscureText: password && isHidden,
        keyboardType: password
            ? TextInputType.visiblePassword
            : icon == Icons.email_outlined
                ? TextInputType.emailAddress
                : TextInputType.text,
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
            borderSide: const BorderSide(
              color: Color(0xffDCE5F2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(
              color: Color(0xffDCE5F2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(
              color: Color(0xff1E5EFF),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  void daftar() {
    String nama = namaController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String konfirmasi = konfirmasiController.text;

    if (nama.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        konfirmasi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua kolom wajib diisi'),
        ),
      );
      return;
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Format email tidak valid'),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password minimal 6 karakter'),
        ),
      );
      return;
    }

    if (password != konfirmasi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi password tidak sama'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Validasi pendaftaran berhasil'),
      ),
    );

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
                ),

                // EMAIL
                requiredLabel("Email"),

                inputField(
                  "budi@gmail.com",
                  Icons.email_outlined,
                  controller: emailController,
                ),

                // PASSWORD
                requiredLabel("Password"),

                inputField(
                  "Minimal 6 karakter",
                  Icons.lock_outline,
                  controller: passwordController,
                  password: true,
                  isHidden: isPasswordHidden,
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
                    onPressed: daftar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1E5EFF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Daftar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward,
                          size: 22,
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
