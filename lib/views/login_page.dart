import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController emailController =
      TextEditingController(
    text: 'mahasiswa@gmail.com',
  );

  final TextEditingController passwordController =
      TextEditingController(
    text: '123456789',
  );

  // Untuk show / hide password
  bool isPasswordHidden = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }


  void login() {

    String email = emailController.text.trim();
    String password = passwordController.text;

    // Validasi kosong
    if (email.isEmpty || password.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Email dan password harus diisi',
          ),
        ),
      );

      return;
    }

    // Login berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Login berhasil',
        ),
      ),
    );
  }


  void forgotPassword() {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Halaman Lupa Password',
        ),
      ),
    );
  }


  void register() {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Halaman Pendaftaran',
        ),
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
              horizontal: 24,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

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

                        borderRadius:
                            BorderRadius.circular(13),
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
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        RichText(
                          text: const TextSpan(
                            children: [

                              TextSpan(
                                text: 'Campus',

                                style: TextStyle(
                                  color:
                                      Color(0xFF111827),

                                  fontSize: 22,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              TextSpan(
                                text: 'Report',

                                style: TextStyle(
                                  color:
                                      Color(0xFF1769FF),

                                  fontSize: 22,

                                  fontWeight:
                                      FontWeight.bold,
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

                          fontWeight:
                              FontWeight.bold,
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

                  keyboardType:
                      TextInputType.emailAddress,

                  decoration: InputDecoration(

                    prefixIcon: const Icon(
                      Icons.email_outlined,

                      color: Color(0xFF8CA1BF),
                    ),

                    filled: true,

                    fillColor:
                        const Color(0xFFF8FAFC),

                    contentPadding:
                        const EdgeInsets.symmetric(
                      vertical: 17,
                      horizontal: 16,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(17),

                      borderSide:
                          const BorderSide(
                        color: Color(0xFFDCE4EF),
                      ),
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(17),

                      borderSide:
                          const BorderSide(
                        color: Color(0xFFDCE4EF),
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(17),

                      borderSide:
                          const BorderSide(
                        color: Color(0xFF1769FF),

                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    const Text(
                      'Password',

                      style: TextStyle(
                        color: Color(0xFF1E293B),

                        fontSize: 16,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    GestureDetector(
                      onTap: forgotPassword,

                      child: const Text(
                        'Lupa Password?',

                        style: TextStyle(
                          color: Color(0xFF1769FF),

                          fontSize: 15,

                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),


                TextField(
                  controller: passwordController,

                  obscureText: isPasswordHidden,

                  decoration: InputDecoration(

                    prefixIcon: const Icon(
                      Icons.lock_outline,

                      color: Color(0xFF8CA1BF),
                    ),

                    // Tombol mata
                    suffixIcon: IconButton(
                      onPressed: () {

                        setState(() {

                          isPasswordHidden =
                              !isPasswordHidden;

                        });
                      },

                      icon: Icon(

                        isPasswordHidden
                            ? Icons.visibility_outlined
                            : Icons
                                .visibility_off_outlined,

                        color:
                            const Color(0xFF8CA1BF),
                      ),
                    ),

                    filled: true,

                    fillColor:
                        const Color(0xFFF8FAFC),

                    contentPadding:
                        const EdgeInsets.symmetric(
                      vertical: 17,
                      horizontal: 16,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(17),

                      borderSide:
                          const BorderSide(
                        color: Color(0xFFDCE4EF),
                      ),
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(17),

                      borderSide:
                          const BorderSide(
                        color: Color(0xFFDCE4EF),
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(17),

                      borderSide:
                          const BorderSide(
                        color: Color(0xFF1769FF),

                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,

                  height: 58,

                  child: ElevatedButton(

                    onPressed: login,

                    style: ElevatedButton.styleFrom(

                      backgroundColor:
                          const Color(0xFF1769FF),

                      foregroundColor:
                          Colors.white,

                      elevation: 5,

                      shadowColor:
                          const Color(0x551769FF),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(17),
                      ),
                    ),

                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Text(
                          'Login',

                          style: TextStyle(
                            fontSize: 18,

                            fontWeight:
                                FontWeight.bold,
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

                Center(

                  child: RichText(
                    text: TextSpan(
                      children: [

                        const TextSpan(
                          text:
                              'Belum punya akun? ',

                          style: TextStyle(
                            color:
                                Color(0xFF64748B),

                            fontSize: 16,
                          ),
                        ),

                        WidgetSpan(

                          child: GestureDetector(
                            onTap: register,

                            child: const Text(
                              'Daftar',

                              style: TextStyle(
                                color:
                                    Color(0xFF1769FF),

                                fontSize: 16,

                                fontWeight:
                                    FontWeight.bold,
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