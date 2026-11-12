
import 'package:flutter/material.dart';
import '../../services/admin/admin_petugas_service.dart';

class TambahPetugasPage extends StatefulWidget {
  const TambahPetugasPage({super.key});

  @override
  State<TambahPetugasPage> createState() => _TambahPetugasPageState();
}

class _TambahPetugasPageState extends State<TambahPetugasPage> {
  static const Color biru = Color(0xFF1749E8);
  static const Color teks = Color(0xFF14213D);
  static const Color abu = Color(0xFF71819D);
  static const Color garis = Color(0xFFDCE5F1);

  final AdminPetugasService _service = AdminPetugasService();

  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final jabatanController = TextEditingController();
  final keahlianController = TextEditingController();
  final teleponController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    jabatanController.dispose();
    keahlianController.dispose();
    teleponController.dispose();
    super.dispose();
  }

  Future<void> _simpanPetugas() async {
    if (isLoading) return;

    final nama = namaController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final jabatan = jabatanController.text.trim();
    final keahlian = keahlianController.text.trim();
    final telepon = teleponController.text.trim();

    if (nama.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        jabatan.isEmpty ||
        keahlian.isEmpty ||
        telepon.isEmpty) {
      _pesan('Semua kolom wajib diisi.', Colors.red);
      return;
    }

    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
        .hasMatch(email)) {
      _pesan('Format email tidak valid.', Colors.red);
      return;
    }

    if (password.length < 8) {
      _pesan('Password minimal 8 karakter.', Colors.red);
      return;
    }

    setState(() => isLoading = true);

    try {
      await _service.tambahPetugas(
        nama: nama,
        email: email,
        password: password,
        jabatan: jabatan,
        keahlian: keahlian,
        noTelepon: telepon,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akun petugas berhasil dibuat.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _pesan(
        e.toString().replaceFirst('Exception: ', ''),
        Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _pesan(String pesan, Color warna) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: warna,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _input({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData ikon,
    TextInputType keyboardType = TextInputType.text,
    bool password = false,
    String? helper,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: teks,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: password && obscurePassword,
          style: const TextStyle(
            fontSize: 13,
            color: teks,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9AA7BA),
              fontSize: 12,
            ),
            prefixIcon: Icon(
              ikon,
              size: 19,
              color: const Color(0xFF8DA0BD),
            ),
            suffixIcon: password
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 19,
                      color: abu,
                    ),
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFFF8FAFD),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: garis),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: garis),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: biru,
                width: 1.4,
              ),
            ),
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: 5),
          Text(
            helper,
            style: const TextStyle(
              color: abu,
              fontSize: 10,
            ),
          ),
        ],
      ],
    );
  }

  Widget _judulBagian(String judul, String keterangan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          judul,
          style: const TextStyle(
            color: teks,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          keterangan,
          style: const TextStyle(
            color: abu,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: teks,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tambah Akun Petugas',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: garis),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFC9DCFF),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: biru,
                      size: 23,
                    ),
                    SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        'Akun petugas dibuat oleh Administrator. '
                        'Gunakan email aktif dan berikan password '
                        'awal kepada petugas secara aman.',
                        style: TextStyle(
                          color: Color(0xFF34517F),
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 23),

              _judulBagian(
                'Identitas Akun',
                'Masukkan informasi untuk login petugas.',
              ),
              const SizedBox(height: 14),

              _input(
                label: 'Nama Lengkap',
                hint: 'Masukkan nama lengkap petugas',
                controller: namaController,
                ikon: Icons.person_outline,
              ),
              const SizedBox(height: 15),

              _input(
                label: 'Email',
                hint: 'Contoh: petugas@email.com',
                controller: emailController,
                ikon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),

              _input(
                label: 'Password Awal',
                hint: 'Minimal 8 karakter',
                controller: passwordController,
                ikon: Icons.lock_outline,
                password: true,
                helper: 'Berikan password awal kepada petugas secara aman.',
              ),

              const SizedBox(height: 25),

              _judulBagian(
                'Informasi Pekerjaan',
                'Lengkapi informasi tugas dan kontak petugas.',
              ),
              const SizedBox(height: 14),

              _input(
                label: 'Jabatan',
                hint: 'Contoh: Teknisi Sarana dan Prasarana',
                controller: jabatanController,
                ikon: Icons.badge_outlined,
              ),
              const SizedBox(height: 15),

              _input(
                label: 'Bidang Keahlian',
                hint: 'Contoh: Kelistrikan, AC, dan Komputer',
                controller: keahlianController,
                ikon: Icons.handyman_outlined,
              ),
              const SizedBox(height: 15),

              _input(
                label: 'Nomor Telepon / WhatsApp',
                hint: 'Masukkan nomor telepon aktif',
                controller: teleponController,
                ikon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 27),

              SizedBox(
                width: double.infinity,
                height: 49,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _simpanPetugas,
                  icon: isLoading
                      ? const SizedBox(
                          width: 19,
                          height: 19,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.person_add_alt_1),
                  label: Text(
                    isLoading
                        ? 'Membuat Akun...'
                        : 'Simpan Akun Petugas',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: biru,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.blueGrey,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'Pastikan seluruh informasi petugas sudah benar.',
                  style: TextStyle(
                    color: abu,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
