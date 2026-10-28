import 'package:flutter/material.dart';

class ProfilAdministrator extends StatelessWidget {
  const ProfilAdministrator({super.key});

  static const Color biru = Color(0xFF1749E8);
  static const Color navy = Color(0xFF101A35);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Navigasi bawah
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 68,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Color(0xFFE8EDF5)),
            ),
          ),
          child: Row(
            children: [
              _menu(context, Icons.bar_chart_rounded, 'Dashboard'),
              _menu(context, Icons.description_outlined, 'Laporan'),
              _menu(context, Icons.groups_outlined, 'Petugas'),
              _menu(
                context,
                Icons.person_outline_rounded,
                'Profil',
                aktif: true,
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Header tetap berada di atas
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFF0F2F7)),
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF7F9FD),
                        border: Border.all(
                          color: const Color(0xFFE1E7F0),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profil Administrator',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                            color: Color(0xFF101828),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Biro Sarana &\nPrasarana Unkhair',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.4,
                            color: Color(0xFF71809A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F6FF),
                      border: Border.all(
                        color: const Color(0xFFCADFFF),
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 13,
                          color: biru,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Admin\nUtama',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                            color: biru,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Konten yang bisa di-scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kartu profil gradasi
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1749E8), navy],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(19),
                        boxShadow: [
                          BoxShadow(
                            color: biru.withOpacity(0.14),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'AA',
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: biru,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Arasya Admin',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'admin@gmail.com',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFFDCE7FF),
                                      ),
                                    ),
                                    SizedBox(height: 7),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: Color(0xFF5DF0B0),
                                        ),
                                        SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'Status Akun:\nAdministrator Aktif',
                                            style: TextStyle(
                                              fontSize: 10,
                                              height: 1.3,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Divider(
                              height: 1,
                              color: Color(0x554A76FF),
                            ),
                          ),
                          const Row(
                            children: [
                              Expanded(
                                child: _Statistik(
                                  angka: '6',
                                  label: 'Laporan\nKampus',
                                ),
                              ),
                              Expanded(
                                child: _Statistik(
                                  angka: '4',
                                  label: 'Diverifikasi',
                                ),
                              ),
                              Expanded(
                                child: _Statistik(
                                  angka: '4',
                                  label: 'Petugas\nSiaga',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Informasi Akun Administrator',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF24334D),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Informasi akun
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFE0E7F1),
                        ),
                      ),
                      child: const Column(
                        children: [
                          _InfoBaris(
                            ikon: Icons.person_outline,
                            label: 'Nama Lengkap',
                            nilai: 'Arasya Admin',
                          ),
                          _InfoBaris(
                            ikon: Icons.mail_outline,
                            label: 'Email Dinas',
                            nilai: 'admin@gmail.com',
                          ),
                          _InfoBaris(
                            ikon: Icons.badge_outlined,
                            label: 'NIP',
                            nilai: '19780512 200501 1 003',
                          ),
                          _InfoBaris(
                            ikon: Icons.apartment_outlined,
                            label: 'Jabatan / Peran',
                            nilai: 'Kepala Biro Administrasi & Sarpras',
                          ),
                          _InfoBaris(
                            ikon: Icons.verified_user_outlined,
                            label: 'Status Akun',
                            nilai: 'Aktif & Terverifikasi',
                            terakhir: true,
                            status: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Tombol keluar
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: const Text('Keluar Portal?'),
                                content: const Text(
                                  'Apakah kamu yakin ingin keluar '
                                  'dari halaman administrator?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                    },
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Logout belum dihubungkan '
                                            'ke sistem autentikasi.',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Ya, Keluar',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          size: 17,
                        ),
                        label: const Text(
                          'Keluar Portal Administrator',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFDC2626),
                          backgroundColor: const Color(0xFFFFF5F5),
                          side: const BorderSide(
                            color: Color(0xFFFFD0D0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _menu(
    BuildContext context,
    IconData ikon,
    String label, {
    bool aktif = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (label != 'Profil') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Navigasi $label belum dihubungkan pada halaman ini.',
                ),
              ),
            );
          }
        },
        child: SizedBox(
          height: 68,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                ikon,
                size: 21,
                color: aktif ? biru : const Color(0xFF8B9CB8),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: aktif ? FontWeight.bold : FontWeight.normal,
                  color: aktif ? biru : const Color(0xFF8B9CB8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Statistik extends StatelessWidget {
  final String angka;
  final String label;

  const _Statistik({
    required this.angka,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          angka,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            height: 1.3,
            color: Color(0xFFE0E9FF),
          ),
        ),
      ],
    );
  }
}

class _InfoBaris extends StatelessWidget {
  final IconData ikon;
  final String label;
  final String nilai;
  final bool terakhir;
  final bool status;

  const _InfoBaris({
    required this.ikon,
    required this.label,
    required this.nilai,
    this.terakhir = false,
    this.status = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: terakhir
            ? null
            : const Border(
                bottom: BorderSide(
                  color: Color(0xFFEDF0F6),
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              ikon,
              size: 15,
              color: const Color(0xFF8DA1C0),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 91,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 10,
                height: 1.5,
                color: Color(0xFF71809A),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: status
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        border: Border.all(
                          color: const Color(0xFFA7F3D0),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        nilai,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 10,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF047857),
                        ),
                      ),
                    )
                  : Text(
                      nilai,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF26354D),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
