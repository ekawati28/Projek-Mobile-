import 'package:flutter/material.dart';
import 'detail_tugas_petugas.dart';

class TugasPetugas extends StatefulWidget {
  const TugasPetugas({super.key});

  @override
  State<TugasPetugas> createState() => _TugasPetugasState();
}

class _TugasPetugasState extends State<TugasPetugas> {
  int _selectedTab = 0;

  final List<Map<String, dynamic>> _semuaTugas = [
    {
      'id': '#CR-2026-0941',
      'prioritas': 'Tinggi',
      'status': 'Diajukan',
      'judul': 'AC di LAP RPL Bermasalah',
      'lokasi': 'LAP RPL',
      'lokasiKampus': 'Kampus III',
      'kategori': 'AC',
      'tanggal': '19 Sep 2026',
      'deskripsi':
          'AC di LAP RPL tidak menyala sejak pagi dan ruangan menjadi sangat '
              'panas saat praktikum berlangsung. Remote tidak merespons dan '
              'terdengar bunyi denging dari indoor unit.',
      'petugas': 'Budi',
      'fotoLabel': 'AC LAP RPL',
      'waktuFoto': '19 Sep 2026, 08:32 WIT',
      'waktuFotoSebelum': '08:30 WIT',
      'waktuFotoSesudah': '11:25 WIT',
      'waktuSelesai': '19 Sep 2026, 11:30 WIT',
      'catatanSelesai':
          'Kapasitor 1.5 PK telah diganti dan freon R32 diisi ulang. Uji '
              'fungsi pendinginan stabil pada suhu 20°C.',
    },
    {
      'id': '#CR-0892',
      'prioritas': 'Sedang',
      'status': 'Diajukan',
      'judul': 'Lampu LED Berkedip dan Mati',
      'lokasi': 'JT3',
      'lokasiKampus': 'Kampus III',
      'kategori': 'Listrik',
      'tanggal': '18 Sep 2026',
      'deskripsi':
          'Lampu LED pada ruang kelas berkedip dan akhirnya mati. Ruangan '
              'menjadi gelap sehingga proses perkuliahan terganggu.',
      'petugas': 'Budi',
      'fotoLabel': 'LAMPU LED JT3',
      'waktuFoto': '18 Sep 2026, 09:15 WIT',
      'waktuFotoSebelum': '09:10 WIT',
      'waktuFotoSesudah': '10:45 WIT',
      'waktuSelesai': '18 Sep 2026, 10:50 WIT',
      'catatanSelesai':
          'Penggantian modul LED dan pemeriksaan jalur kelistrikan telah '
              'dilakukan. Lampu menyala normal.',
    },
    {
      'id': '#CR-0935',
      'prioritas': 'Normal',
      'status': 'Diproses',
      'judul': 'Kipas Exhaust Macet',
      'lokasi': 'LAP JAK',
      'lokasiKampus': 'Kampus III',
      'kategori': 'Listrik',
      'tanggal': '19 Sep 2026',
      'deskripsi':
          'Kipas exhaust pada LAP JAK tidak berputar dan menimbulkan bunyi '
              'kasar. Sirkulasi udara ruangan menjadi tidak optimal.',
      'petugas': 'Budi',
      'fotoLabel': 'KIPAS EXHAUST LAP JAK',
      'waktuFoto': '19 Sep 2026, 10:05 WIT',
      'waktuFotoSebelum': '10:00 WIT',
      'waktuFotoSesudah': '11:10 WIT',
      'waktuSelesai': '19 Sep 2026, 11:15 WIT',
      'catatanSelesai':
          'Pembersihan dan pelumasan bantalan kipas telah dilakukan. Kipas '
              'kembali berputar normal.',
    },
    {
      'id': '#CR-2026-0942',
      'prioritas': 'Sedang',
      'status': 'Diproses',
      'judul': 'Pintu Toilet Rusak',
      'lokasi': 'Gedung Kuliah III',
      'lokasiKampus': 'Kampus III',
      'kategori': 'Sarana',
      'tanggal': '20 Sep 2026',
      'deskripsi':
          'Pintu toilet pada Gedung Kuliah III tidak dapat ditutup dengan '
              'baik karena engsel longgar. Pengguna toilet merasa tidak nyaman.',
      'petugas': 'Budi',
      'fotoLabel': 'PINTU TOILET GK III',
      'waktuFoto': '20 Sep 2026, 08:20 WIT',
      'waktuFotoSebelum': '08:15 WIT',
      'waktuFotoSesudah': '09:05 WIT',
      'waktuSelesai': '20 Sep 2026, 09:10 WIT',
      'catatanSelesai':
          'Engsel pintu telah diperbaiki dan pintu dapat ditutup dengan '
              'rapat.',
    },
  ];

  List<Map<String, dynamic>> get _tugasBaru {
    return _semuaTugas.where((tugas) => tugas['status'] == 'Diajukan').toList();
  }

  List<Map<String, dynamic>> get _tugasDiproses {
    return _semuaTugas.where((tugas) => tugas['status'] == 'Diproses').toList();
  }

  Future<void> _bukaDetail(Map<String, dynamic> tugas) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailTugasPetugas(tugas: tugas),
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tugasBaru = _tugasBaru;
    final tugasDiproses = _tugasDiproses;
    final daftarTugas = _selectedTab == 0 ? tugasBaru : tugasDiproses;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBackButton(),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Laporan Masuk',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Daftar penugasan perbaikan fasilitas',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          'Kampus III',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildTab(
                      index: 0,
                      title: 'Tugas Baru',
                      jumlah: tugasBaru.length,
                    ),
                    _buildTab(
                      index: 1,
                      title: 'Sedang Diproses',
                      jumlah: tugasDiproses.length,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              color: const Color(0xFFE2E8F0),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFF8FAFC),
                child: daftarTugas.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                        itemCount: daftarTugas.length,
                        itemBuilder: (context, index) {
                          return _buildTaskCard(daftarTugas[index]);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedFontSize: 10.5,
        unselectedFontSize: 10.5,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        onTap: (index) {
          if (index == 1) return;

          const labels = ['Dashboard', 'Tugas', 'Riwayat', 'Profil'];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Halaman ${labels[index]} belum dihubungkan.',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded, size: 22),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined, size: 22),
            activeIcon: Icon(Icons.assignment_turned_in_rounded, size: 22),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded, size: 22),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded, size: 22),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          Navigator.maybePop(context);
        },
        padding: EdgeInsets.zero,
        icon: const Icon(
          Icons.arrow_back_rounded,
          size: 19,
          color: Color(0xFF334155),
        ),
      ),
    );
  }

  Widget _buildTab({
    required int index,
    required String title,
    required int jumlah,
  }) {
    final bool aktif = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
          decoration: BoxDecoration(
            color: aktif ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: aktif
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            '$title ($jumlah)',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: aktif ? FontWeight.bold : FontWeight.w600,
              color: aktif ? const Color(0xFF2563EB) : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> tugas) {
    final String id = tugas['id']?.toString() ?? '';
    final String prioritas = tugas['prioritas']?.toString() ?? 'Normal';
    final String status = tugas['status']?.toString() ?? 'Diajukan';
    final String judul = tugas['judul']?.toString() ?? '';
    final String lokasi = tugas['lokasi']?.toString() ?? '';
    final String kategori = tugas['kategori']?.toString() ?? '';
    final String tanggal = tugas['tanggal']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _bukaDetail(tugas),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                id,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildPill(
                                'Prioritas $prioritas',
                                _priorityTextColor(prioritas),
                                _priorityBackgroundColor(prioritas),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildPill(
                      status,
                      _statusTextColor(status),
                      _statusBackgroundColor(status),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoLine(
                        Icons.location_on_outlined,
                        lokasi,
                        iconColor: const Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoLine(
                        Icons.local_offer_outlined,
                        kategori,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoLine(
                        Icons.calendar_today_outlined,
                        tanggal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _bukaDetail(tugas),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Detail',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 17,
                            color: Color(0xFF2563EB),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPill(String text, Color foreground, Color background) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
          color: foreground,
        ),
      ),
    );
  }

  Widget _buildInfoLine(
    IconData icon,
    String text, {
    Color iconColor = const Color(0xFF94A3B8),
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 44,
              color: Color(0xFFCBD5E1),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedTab == 0
                  ? 'Belum ada tugas baru.'
                  : 'Belum ada tugas yang sedang diproses.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _priorityTextColor(String prioritas) {
    switch (prioritas) {
      case 'Tinggi':
        return const Color(0xFFDC2626);
      case 'Sedang':
        return const Color(0xFFEA580C);
      default:
        return const Color(0xFFDC2626);
    }
  }

  Color _priorityBackgroundColor(String prioritas) {
    switch (prioritas) {
      case 'Tinggi':
        return const Color(0xFFFEF2F2);
      case 'Sedang':
        return const Color(0xFFFFF7ED);
      default:
        return const Color(0xFFFEF2F2);
    }
  }

  Color _statusTextColor(String status) {
    switch (status) {
      case 'Diproses':
        return const Color(0xFF7C3AED);
      case 'Selesai':
        return const Color(0xFF15803D);
      default:
        return const Color(0xFFB45309);
    }
  }

  Color _statusBackgroundColor(String status) {
    switch (status) {
      case 'Diproses':
        return const Color(0xFFF5F3FF);
      case 'Selesai':
        return const Color(0xFFDCFCE7);
      default:
        return const Color(0xFFFEF3C7);
    }
  }
}
