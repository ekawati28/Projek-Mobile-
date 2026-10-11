import 'lupa_password_page2.dart';
import '../../controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});
  

  @override
  State<ForgotPasswordDialog> createState() =>
      _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController emailController = TextEditingController();
  final AuthController authController = AuthController();

  String? emailError;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> kirimResetPassword() async {
    final email = emailController.text.trim();
    setState(() {
      emailError = null;
    });

    if(email.isEmpty){
      setState(() {
        emailError =
            "Email wajib diisi";
      });
      return;
    }

    if(!RegExp( r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)){
      setState(() {
        emailError =
            "Format email tidak valid";
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authController.resetPassword(
        email,
      );

      setState(() {
        isLoading = false;
      });

      if(!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.30),
        builder: (_) {

          return const Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: LupaPasswordPage2(),
          );

        },
      );

    } catch(e){
      setState(() {
        isLoading = false;
          emailError =
              "Terjadi kesalahan, coba lagi";
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 340,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF2FF),
                          borderRadius:
                              BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.key_outlined,
                          color: Color(0xFF1769FF),
                          size: 21,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Expanded(
                        child: Text(
                          'Lupa Kata Sandi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                            Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 19,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Masukkan email akun Mahasiswa '
                    'Anda untuk menerima link reset '
                    'kata sandi.',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Email Akun',
                    style: TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 7),

                  TextField(
                    controller: emailController,
                    keyboardType:
                        TextInputType.emailAddress,

                    onChanged: (value) {
                      if (emailError != null) {
                        setState(() {
                          emailError = null;
                        });
                      }
                    },

                    decoration: InputDecoration(
                      hintText: 'Masukkan email Anda',
                      hintStyle: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                      ),

                      prefixIcon: const Icon(Icons.email_outlined,
                        size: 19,
                        color: Color(0xFF8CA1BF),
                      ),

                      filled: true,
                      fillColor:const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 13,
                        horizontal: 12,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFDCE4EF),
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: emailError != null
                          ? Colors.red
                          : const Color(0xFFDCE4EF),
                        ),
                      ),
                      
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF1769FF),
                        ),
                      ),
                    ),
                  ),

                  if(emailError != null)
                  Padding(
                    padding:
                        const EdgeInsets.only(
                          left: 12,
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

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 43,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF1F5F9),
                              foregroundColor: const Color(0xFF334155),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            
                            child: const Text(
                              'Batal',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 9),

                      Expanded(
                        child: SizedBox(
                          height: 43,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : kirimResetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1769FF),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: const Color(0x551769FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )

                            : const Text(
                                'Kirim Link Reset\nPassword',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void showForgotPasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.30),
    
    builder: (_) {
      return const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ForgotPasswordDialog(),
      );
    },
  );
  
}