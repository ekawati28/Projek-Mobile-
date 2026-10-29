import 'package:flutter/material.dart';
import 'notifikasi_admin.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() =>
      _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  int _selectedNavIndex = 0;

  // Membuka halaman notifikasi ketika lonceng ditekan.
  void _bukaNotifikasi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotifikasiAdminPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. HEADER ADMIN
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PORTAL ADMIN SARPRAS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563EB),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Dashboard\nMonitoring',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IKON NOTIFIKASI + BADGE 3
                      InkWell(
                        onTap: _bukaNotifikasi,
                        borderRadius: BorderRadius.circular(30),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: const Icon(
                                Icons.notifications_none_outlined,
                                color: Color(0xFF334155),
                                size: 24,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // AVATAR ADMIN
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDBEAFE),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'AD',
                            style: TextStyle(
                              color: Color(0xFF1D4ED8),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ==========================================
              // 2. BANNER AKUMULASI SELURUH KAMPUS
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D4ED8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Akumulasi Seluruh\nKampus',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.2,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Tahun\n2026',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: const [
                        Text(
                          '6',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Total Laporan Masuk',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          '33% Tuntas',
                          style: TextStyle(
                            color: Color(0xFF4ADE80),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==========================================
              // 3. STATUS PENANGANAN LAPORAN
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status Penanganan\nLaporan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      height: 1.2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Filter status laporan belum dihubungkan.',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // BARIS PERTAMA
              Row(
                children: [
                  Expanded(
                    child: _buildStatusCard(
                      title: 'DIAJUKAN',
                      count: '2',
                      badgeText: 'Perlu\nVerifikasi',
                      titleColor: const Color(0xFFB45309),
                      borderColor: const Color(0xFFFDE68A),
                      cardBgColor: const Color(0xFFFFFEFA),
                      badgeBgColor: const Color(0xFFFDE68A),
                      badgeTextColor: const Color(0xFFB45309),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatusCard(
                      title: 'DIVERIFIKASI',
                      count: '1',
                      badgeText: 'Siap\nDitugaskan',
                      titleColor: const Color(0xFF1D4ED8),
                      borderColor: const Color(0xFFBFDBFE),
                      cardBgColor: const Color(0xFFF8FBFF),
                      badgeBgColor: const Color(0xFFBFDBFE),
                      badgeTextColor: const Color(0xFF1D4ED8),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // BARIS KEDUA
              Row(
                children: [
                  Expanded(
                    child: _buildStatusCard(
                      title: 'DIPROSES',
                      count: '1',
                      badgeText: 'Sedang\nTeknisi',
                      titleColor: const Color(0xFF7E22CE),
                      borderColor: const Color(0xFFE9D5FF),
                      cardBgColor: const Color(0xFFFAFAFF),
                      badgeBgColor: const Color(0xFFE9D5FF),
                      badgeTextColor: const Color(0xFF7E22CE),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatusCard(
                      title: 'SELESAI',
                      count: '2',
                      badgeText: 'Berita Acara\nAda',
                      titleColor: const Color(0xFF15803D),
                      borderColor: const Color(0xFFA7F3D0),
                      cardBgColor: const Color(0xFFF4FBF7),
                      badgeBgColor: const Color(0xFFA7F3D0),
                      badgeTextColor: const Color(0xFF15803D),
                      showArrow: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ==========================================
              // 4. RINGKASAN KERUSAKAN PER GEDUNG
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildAxisBarChartIcon(
                          const Color(0xFF2563EB),
                          22,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Ringkasan Kerusakan per\nGedung',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildGedungProgress(
                      'LAP RPL & Lab Komputer',
                      '48 Laporan',
                      0.8,
                      const Color(0xFF2563EB),
                    ),

                    const SizedBox(height: 12),

                    _buildGedungProgress(
                      'Ruang Kuliah (JT1 - JT6)',
                      '36 Laporan',
                      0.6,
                      const Color(0xFFF59E0B),
                    ),

                    const SizedBox(height: 12),

                    _buildGedungProgress(
                      'Fasilitas Umum & Ruang\nSidang',
                      '32 Laporan',
                      0.5,
                      const Color(0xFFA855F7),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==========================================
              // 5. ANTREAN VERIFIKASI TERBARU
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Antrean Verifikasi Terbaru',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Halaman seluruh laporan perlu dihubungkan.',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFDE68A),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.build_outlined,
                            color: Color(0xFFD97706),
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            'Kursi ruang kelas\nrusak',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF0F172A),
                              height: 1.2,
                            ),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Detail verifikasi perlu dihubungkan.',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Periksa',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    const Padding(
                      padding: EdgeInsets.only(left: 56),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pelapor: Budi Santoso',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Lokasi: JT3',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      // ==========================================
      // 6. NAVIGASI BAWAH ADMIN
      // ==========================================
      bottomNavigationBar: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFF1F5F9),
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCustomDashboardNavItem(
                'Dashboard',
                0,
                const Color(0xFF2563EB),
              ),
              _buildNavItem(
                Icons.description_outlined,
                'Laporan',
                1,
              ),
              _buildNavItem(
                Icons.group_outlined,
                'Petugas',
                2,
              ),
              _buildNavItem(
                Icons.person_outline,
                'Profil',
                3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // IKON RINGKASAN KERUSAKAN
  // ==========================================
  Widget _buildAxisBarChartIcon(Color color, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 2,
              height: size,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: size,
              height: 2,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 4,
              bottom: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 2.5,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                Container(
                  width: 2.5,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                Container(
                  width: 2.5,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // IKON TIGA BATANG UNTUK NAVIGASI DASHBOARD
  // ==========================================
  Widget _buildOnlyThreeBarsIcon(Color color, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 3,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
          Container(
            width: 3,
            height: 9,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // KARTU STATUS LAPORAN
  // ==========================================
  Widget _buildStatusCard({
    required String title,
    required String count,
    required String badgeText,
    required Color titleColor,
    required Color borderColor,
    required Color cardBgColor,
    required Color badgeBgColor,
    required Color badgeTextColor,
    bool showArrow = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ),
              if (showArrow)
                const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Color(0xFF15803D),
                ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: badgeTextColor,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PROGRESS KERUSAKAN GEDUNG
  // ==========================================
  Widget _buildGedungProgress(
    String title,
    String countText,
    double progress,
    Color progressColor,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF475569),
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              countText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // NAVIGASI BAWAH STANDAR
  // ==========================================
  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    final bool isSelected = _selectedNavIndex == index;

    final Color color = isSelected
        ? const Color(0xFF2563EB)
        : const Color(0xFF94A3B8);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });

        if (index != 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Halaman $label perlu dihubungkan.',
              ),
            ),
          );
        }
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // NAVIGASI BAWAH DASHBOARD
  // ==========================================
  Widget _buildCustomDashboardNavItem(
    String label,
    int index,
    Color activeColor,
  ) {
    final bool isSelected = _selectedNavIndex == index;

    final Color color = isSelected
        ? activeColor
        : const Color(0xFF94A3B8);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOnlyThreeBarsIcon(color, 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}