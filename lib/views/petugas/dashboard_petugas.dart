import 'package:flutter/material.dart';

class DashboardPetugasPage extends StatefulWidget {
  const DashboardPetugasPage({super.key});

  @override
  State<DashboardPetugasPage> createState() => _DashboardPetugasPageState();
}

class _DashboardPetugasPageState extends State<DashboardPetugasPage> {
  // Data contoh, nanti ganti dengan data dari Supabase
  final String nama = 'Budi';
  final String jabatan = 'Teknisi Fasilitas & Pendingin (HVAC)';
  final int jumlahNotifikasi = 2;
  final int tugasBaru = 0;
  final int tugasDiproses = 0;
  final int tugasSelesai = 41;
  final List<dynamic> daftarTugas = [];

  int _selectedIndex = 0;

  static const Color _biru = Color(0xFF1D4ED8);
  static const Color _teksGelap = Color(0xFF1E293B);
  static const Color _teksAbu = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildStatusLapangan(),
              const SizedBox(height: 24),
              Text(
                'Ringkasan Status Tugas ($nama)',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _teksGelap,
                ),
              ),
              const SizedBox(height: 12),
              _buildRingkasan(),
              const SizedBox(height: 24),
              _buildDaftarTugasHeader(),
              const SizedBox(height: 12),
              daftarTugas.isEmpty ? _buildTugasKosong() : _buildListTugas(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              '👷',
              style: TextStyle(fontSize: 26),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $nama 👋',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _teksGelap,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                jabatan,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: _biru,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(Icons.notifications_none_rounded,
                  color: _teksGelap, size: 24),
            ),
            if (jumlahNotifikasi > 0)
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF87171),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text(
                    '$jumlahNotifikasi',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // ---------------- KARTU STATUS LAPANGAN ----------------
  Widget _buildStatusLapangan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _biru,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _biru.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'STATUS LAPANGAN',
                style: TextStyle(
                  color: Color(0xFFBFDBFE),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Siaga / Aktif',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Siaga Pemeliharaan Fasilitas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Belum ada tugas baru yang ditugaskan Admin Sarpras ke akun $nama.',
            style: const TextStyle(
              color: Color(0xFFDBEAFE),
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- RINGKASAN 3 KARTU ----------------
  Widget _buildRingkasan() {
    return Row(
      children: [
        Expanded(
          child: _kartuAngka(
            jumlah: tugasBaru,
            label: 'Tugas\nBaru',
            warna: const Color(0xFF1D4ED8),
            warnaBg: const Color(0xFFEFF6FF),
            warnaBorder: const Color(0xFFBFDBFE),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _kartuAngka(
            jumlah: tugasDiproses,
            label: 'Diproses',
            warna: const Color(0xFF7E22CE),
            warnaBg: const Color(0xFFFAF5FF),
            warnaBorder: const Color(0xFFE9D5FF),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _kartuAngka(
            jumlah: tugasSelesai,
            label: 'Selesai',
            warna: const Color(0xFF047857),
            warnaBg: const Color(0xFFECFDF5),
            warnaBorder: const Color(0xFFA7F3D0),
          ),
        ),
      ],
    );
  }

  Widget _kartuAngka({
    required int jumlah,
    required String label,
    required Color warna,
    required Color warnaBg,
    required Color warnaBorder,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: warnaBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: warnaBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$jumlah',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: warna,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: warna,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- DAFTAR TUGAS ----------------
  Widget _buildDaftarTugasHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Daftar Tugas Ditugaskan',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _teksGelap,
          ),
        ),
        GestureDetector(
          onTap: () {
            // TODO: buka halaman semua tugas
          },
          child: const Text(
            'Buka Semua',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _biru,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTugasKosong() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        children: [
          Text(
            'Tidak Ada Tugas Aktif',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: _teksGelap,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Laporan fasilitas akan otomatis masuk ke akun Budi setelah diverifikasi dan ditugaskan oleh Admin Sarpras.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: _teksAbu,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTugas() {
    // TODO: tampilkan daftar tugas dari database
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: daftarTugas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => const SizedBox(),
    );
  }

  // ---------------- BOTTOM NAV ----------------
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: _biru,
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_turned_in_outlined),
              label: 'Tugas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
