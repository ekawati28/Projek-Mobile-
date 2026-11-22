import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilPetugasPage extends StatefulWidget {
  const ProfilPetugasPage({super.key});

  @override
  State<ProfilPetugasPage> createState() => _ProfilPetugasPageState();
}

class _ProfilPetugasPageState extends State<ProfilPetugasPage> {
  int selectedIndex = 3;

  // WARNA
  static const Color biru = Color(0xFF1749E8);
  static const Color biruTua = Color(0xFF1D3FBA);
  static const Color gelap = Color(0xFF10182F);
  static const Color abu = Color(0xFF8295B2);
  static const Color garis = Color(0xFFE2E9F2);
  static const Color teks = Color(0xFF243149);


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // =====================================
              // HEADER PROFIL PETUGAS
              // =====================================

              Container(
                height: 61,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFE9EDF4),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profil Petugas',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111B32),
                      ),
                    ),

                    // STATUS AKTIF
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFFF7),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color(0xFF8BEBC6),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 9,
                            color: Color(0xFF10B981),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Status: Siaga Aktif',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // =====================================
              // KONTEN PROFIL
              // =====================================

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    22,
                    16,
                    22,
                    20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // =================================
                      // KARTU IDENTITAS PETUGAS
                      // =================================

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          18,
                          16,
                          17,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1D43C0),
                              Color(0xFF10182F),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 9,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [

                            // FOTO DAN IDENTITAS
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                // AVATAR
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDCEBFF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '👷',
                                      style: TextStyle(
                                        fontSize: 32,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 15),

                                // NAMA DAN JABATAN
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Pak Rustam',
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      const Text(
                                        'ID: TK-094-RUSTAM',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF8FC5FF),
                                          letterSpacing: 0.3,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      const Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.build_outlined,
                                            size: 16,
                                            color: Color(0xFF62B5FF),
                                          ),
                                          SizedBox(width: 7),
                                          Expanded(
                                            child: Text(
                                              'Teknisi Senior Listrik & HVAC',
                                              style: TextStyle(
                                                fontSize: 12,
                                                height: 1.4,
                                                color: Color(0xFFE1E9F8),
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

                            const SizedBox(height: 17),

                            // GARIS PEMBATAS
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: Colors.white.withOpacity(0.16),
                            ),

                            const SizedBox(height: 14),

                            // STATISTIK
                            const Row(
                              children: [

                                // TUNTAS
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        '41',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Tuntas',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFFDCE5F5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // RATING
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 17,
                                            color: Color(0xFFFFB800),
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            '4.9',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFFFFB800),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Rating',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFFDCE5F5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // RATA-RATA
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        '1.2 Jam',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF00D6A0),
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Rata-rata',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFFDCE5F5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // =================================
                      // JUDUL UNIT PENUGASAN
                      // =================================

                      const Text(
                        'Unit Penugasan & Wilayah Kerja',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: teks,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // =================================
                      // KARTU INFORMASI PEKERJAAN
                      // =================================

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFD),
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(
                            color: garis,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [

                            // WILAYAH TUGAS
                            _buildInfoRow(
                              icon: Icons.workspace_premium_outlined,
                              title: 'Wilayah Tugas:',
                              value: 'Kampus III Jati Unkhair',
                            ),

                            _buildDivider(),

                            // JAM SHIFT
                            _buildInfoRow(
                              icon: Icons.access_time,
                              title: 'Jam Shift:',
                              value: '08:00 - 16:30 WIT',
                            ),

                            _buildDivider(),

                            // KONTAK DARURAT
                            _buildInfoRow(
                              icon: Icons.call_outlined,
                              title: 'Kontak Darurat:',
                              value: '0812-4433-2211',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // =================================
                      // TOMBOL KELUAR PORTAL
                      // =================================

                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton.icon(
                          onPressed: _showLogoutDialog,
                          icon: const Icon(
                            Icons.logout,
                            size: 18,
                            color: Colors.red,
                          ),
                          label: const Text(
                            'Keluar Portal Petugas',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFF0F0),
                            side: const BorderSide(
                              color: Color(0xFFFFBABA),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // =====================================
              // BOTTOM NAVIGATION
              // =====================================

              Container(
                height: 76,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFE0E7F0),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    _buildNavItem(
                      icon: Icons.bar_chart_outlined,
                      label: 'Dashboard',
                      index: 0,
                    ),

                    _buildNavItem(
                      icon: Icons.assignment_outlined,
                      label: 'Tugas',
                      index: 1,
                    ),

                    _buildNavItem(
                      icon: Icons.history,
                      label: 'Riwayat',
                      index: 2,
                    ),

                    _buildNavItem(
                      icon: Icons.person_outline,
                      label: 'Profil',
                      index: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================
  // WIDGET BARIS INFORMASI
  // =============================================

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return SizedBox(
      height: 42,
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: abu,
          ),

          const SizedBox(width: 9),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF7186A6),
            ),
          ),

          const Spacer(),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF26334A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================
  // GARIS PEMBATAS INFORMASI
  // =============================================

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.8,
      color: Color(0xFFE5EAF2),
    );
  }

  // =============================================
  // NAVIGASI BAWAH
  // =============================================

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected
                    ? biru
                    : const Color(0xFF8FA2BF),
              ),

              const SizedBox(height: 3),

              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w400,
                  color: isSelected
                      ? biru
                      : const Color(0xFF8FA2BF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================
  // DIALOG LOGOUT
  // =============================================

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Konfirmasi Keluar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari portal petugas?',
            style: TextStyle(
              fontSize: 14,
            ),
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

                // Hubungkan fungsi logout di sini.
              },
              child: const Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
