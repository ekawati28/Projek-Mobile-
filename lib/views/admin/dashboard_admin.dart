import 'package:flutter/material.dart';
import 'notifikasi_admin.dart';
import '../../services/admin/admin_service.dart';
import 'laporan_admin_page.dart';
import 'detail_laporan_admin_page.dart';
import '../../widgets/bottom_navbar_admin.dart';
import 'petugas_page.dart';
import 'profil_administrator.dart';
import '../../services/admin/admin_notifikasi_service.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() =>
      _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {

  List<Map<String, dynamic>> _antreanVerifikasi = [];
  final AdminService _adminService = AdminService();

  final AdminNotifikasiService _notifikasiService = AdminNotifikasiService();
  int _jumlahNotifikasiBelumDibaca = 0;

  // Mengambil jumlah notifikasi Admin yang belum dibaca.
  Future<void> _muatJumlahNotifikasi() async {
    try {
      final jumlah =
          await _notifikasiService.getJumlahBelumDibaca();

      if (!mounted) return;

      setState(() {
        _jumlahNotifikasiBelumDibaca = jumlah;
      });
    } catch (e) {
      debugPrint('Gagal memuat jumlah notifikasi: $e');
    }
  }

  Map<String, int> _statistik = {
    'total': 0,
    'Diajukan': 0,
    'Diverifikasi': 0,
    'Diproses': 0,
    'Selesai': 0,
  };


  Map<String, int> _statistikGedung = {
    for (final lokasi in AdminService.daftarLokasiResmi)
      lokasi: 0,
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _muatStatistik();
    _muatJumlahNotifikasi();
  }

  void _navigasiAdmin(int index) {
    if (index == 0) return;

    Widget halaman;

    switch (index) {
      case 1:
        halaman = const LaporanAdminPage();
        break;
      case 2:
        halaman = const PetugasPage();
        break;
      case 3:
        halaman = const ProfilAdministrator();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => halaman,
      ),
    );
  }
  
  Future<void> _muatStatistik() async {
    try {
      final hasil = await _adminService.getStatistikLaporan();

      final antrean =
          await _adminService.getAntreanVerifikasi();

      final statistikGedung =
          await _adminService.getStatistikKerusakanGedung();

      if (!mounted) return;

      setState(() {
        _statistik = hasil;
        _antreanVerifikasi = antrean;
        _statistikGedung = statistikGedung;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat statistik Admin: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat statistik: $e'),
        ),
      );
    }
  }

  int get _persentaseTuntas {
    final total = _statistik['total'] ?? 0;
    final selesai = _statistik['Selesai'] ?? 0;

    if (total == 0) return 0;

    return ((selesai / total) * 100).round();
  }

  // Membuka halaman notifikasi Admin.
  Future<void> _bukaNotifikasi() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotifikasiAdminPage(),
      ),
    );

    // Memperbarui jumlah notifikasi setelah kembali.
    if (!mounted) return;

    await _muatJumlahNotifikasi();
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
                          'Dashboard Monitoring',
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            height: 1.2,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    // IKON NOTIFIKASI + BADGE DINAMIS
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

                          // Badge hanya muncul jika ada notifikasi belum dibaca.
                          if (_jumlahNotifikasiBelumDibaca > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  _jumlahNotifikasiBelumDibaca > 99
                                      ? '99+'
                                      : '$_jumlahNotifikasiBelumDibaca',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
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
                          child: Text(
                            'Tahun\n${DateTime.now().year}',
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
                      children: [
                        Text(
                          _isLoading
                              ? '...'
                              : '${_statistik['total'] ?? 0}',
                          style: const TextStyle(
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
                          _isLoading
                              ? '...'
                              : '$_persentaseTuntas% Tuntas',
                          style: const TextStyle(
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
                ],
              ),

              const SizedBox(height: 12),

              // BARIS PERTAMA
              Row(
                children: [
                  Expanded(
                    child: _buildStatusCard(
                      title: 'DIAJUKAN',
                      count: _isLoading ? '...' : '${_statistik['Diajukan'] ?? 0}',
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
                      count: _isLoading ? '...' : '${_statistik['Diverifikasi'] ?? 0}',
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
                      count: _isLoading ? '...' : '${_statistik['Diproses'] ?? 0}',
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
                      count: _isLoading
                          ? '...'
                          : '${_statistik['Selesai'] ?? 0}',
                      badgeText: 'Berita Acara\nAda',
                      titleColor: const Color(0xFF15803D),
                      borderColor: const Color(0xFFA7F3D0),
                      cardBgColor: const Color(0xFFF4FBF7),
                      badgeBgColor: const Color(0xFFA7F3D0),
                      badgeTextColor: const Color(0xFF15803D),
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

                    const SizedBox(height: 4),

                    const Text(
                      'Berdasarkan 12 lokasi resmi Kampus III',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    
                    const SizedBox(height: 16),

                    if (_isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      _buildDaftarGedung(),

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LaporanAdminPage(),
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

              const SizedBox(height: 8),

                            if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (_antreanVerifikasi.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: const Text(
                    'Belum ada laporan yang menunggu verifikasi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                )
                
              else
                ..._antreanVerifikasi.take(2).map((laporan) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF5),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFFDE68A),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.build_outlined,
                            color: Color(0xFFD97706),
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                laporan['judul']?.toString() ??
                                laporan['title']?.toString() ??
                                'Tanpa judul',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                'Pelapor: ${laporan['nama_pelapor'] ?? laporan['pelapor'] ?? '-'}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                laporan['lokasi']?.toString() ?? '-',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Diajukan',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB45309),
                              ),
                            ),
                            const SizedBox(height: 9),
                            SizedBox(
                              height: 34,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailLaporanAdminPage(
                                        laporan: {
                                          'id_laporan': laporan['id_laporan'],
                                          'id': '#CR-${laporan['id_laporan']}',

                                          // Judul laporan
                                          'judul': laporan['judul'] ?? laporan['title'] ?? '-',
                                          'title': laporan['judul'] ?? laporan['title'] ?? '-',

                                          // Identitas mahasiswa
                                          'nama_pelapor': laporan['nama_pelapor'] ?? laporan['pelapor'] ?? '-',
                                          'pelapor': laporan['nama_pelapor'] ?? laporan['pelapor'] ?? '-',
                                          'nama_pengguna': laporan['nama_pelapor'] ?? laporan['pelapor'] ?? '-',
                                          'email': laporan['email'] ?? '-',

                                          // Informasi laporan
                                          'status': laporan['status'] ?? 'Diajukan',
                                          'kategori': laporan['kategori'] ?? '-',
                                          'lokasi': laporan['lokasi'] ?? '-',
                                          'deskripsi': laporan['deskripsi'] ?? laporan['lpr_deskripsi'] ?? '-',
                                          'tanggal': laporan['tanggal'] ?? '-',
                                        },
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13,
                                  ),
                                  minimumSize: Size.zero,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Periksa',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      // ==========================================
      // 6. NAVIGASI BAWAH ADMIN
      // ==========================================
      bottomNavigationBar: BottomNavbarAdmin(
        currentIndex: 0,
        onTap: _navigasiAdmin,
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
  // DAFTAR STATISTIK KERUSAKAN GEDUNG
  // ==========================================
  Widget _buildDaftarGedung() {
    final daftarLokasi = AdminService.daftarLokasiResmi;

    final jumlahMaksimal = _statistikGedung.values.fold<int>(
      0,
      (maks, jumlah) => jumlah > maks ? jumlah : maks,
    );

    const warnaGrafik = [
      Color(0xFF2563EB),
      Color(0xFFF59E0B),
      Color(0xFFA855F7),
      Color(0xFF0D9488),
      Color(0xFFEF4444),
      Color(0xFF6366F1),
    ];

    return Column(
      children: List.generate(daftarLokasi.length, (index) {
        final lokasi = daftarLokasi[index];

        final jumlah = _statistikGedung[lokasi] ?? 0;

        final progress = jumlahMaksimal == 0
            ? 0.0
            : jumlah / jumlahMaksimal;

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == daftarLokasi.length - 1 ? 0 : 12,
          ),
          child: _buildGedungProgress(
            lokasi,
            '$jumlah Laporan',
            progress,
            warnaGrafik[index % warnaGrafik.length],
          ),
        );
      }),
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
}