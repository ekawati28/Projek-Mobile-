
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/bottom_navbar_admin.dart';
import '../../services/admin/admin_service.dart';
import 'dashboard_admin.dart';
import 'laporan_admin_page.dart';
import 'petugas_page.dart';
import '../auth/login_page.dart';
import 'tambah_petugas_page.dart';

class ProfilAdministrator extends StatefulWidget {
  const ProfilAdministrator({super.key});

  @override
  State<ProfilAdministrator> createState() =>
      _ProfilAdministratorState();
}

class _ProfilAdministratorState extends State<ProfilAdministrator> {
  static const Color biru = Color(0xFF1749E8);
  static const Color navy = Color(0xFF101A35);

  final SupabaseClient supabase = Supabase.instance.client;
  final AdminService _adminService = AdminService();

  Map<String, dynamic>? profilAdmin;
  Map<String, int> statistik = {};

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _muatDataProfil();
  }

  // Mengambil profil dan statistik dari Supabase.
  Future<void> _muatDataProfil() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('Admin belum login.');
      }

      // Mengambil identitas Admin.
      final profil = await supabase
          .from('pengguna')
          .select(
            'id_pengguna, nama_pengguna, email, role, usr_waktu_dibuat',
          )
          .eq('auth_id', user.id)
          .maybeSingle();

      if (profil == null || profil['role'] != 'admin') {
        throw Exception('Profil Administrator tidak ditemukan.');
      }

      // Mengambil statistik laporan.
      final hasilStatistik =
          await _adminService.getStatistikLaporan();

      // Menghitung jumlah petugas.
      final dataPetugas = await supabase
          .from('pengguna')
          .select('id_pengguna')
          .eq('role', 'petugas');

      if (!mounted) return;

      setState(() {
        profilAdmin = Map<String, dynamic>.from(profil);

        statistik = {
          'total': hasilStatistik['total'] ?? 0,
          'diverifikasi':
              hasilStatistik['Diverifikasi'] ?? 0,
          'petugas': dataPetugas.length,
        };

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String get namaAdmin {
    return profilAdmin?['nama_pengguna']?.toString() ??
        'Administrator';
  }

  String get emailAdmin {
    return profilAdmin?['email']?.toString() ??
        supabase.auth.currentUser?.email ??
        '-';
  }

  String get inisialAdmin {
    final kata = namaAdmin
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .take(2)
        .toList();

    if (kata.isEmpty) return 'A';

    return kata
        .map((item) => item[0].toUpperCase())
        .join();
  }

  String get tanggalBergabung {
    final waktu = profilAdmin?['usr_waktu_dibuat'];

    if (waktu == null) return '-';

    try {
      final tanggal = DateTime.parse(waktu.toString()).toLocal();

      return '${tanggal.day.toString().padLeft(2, '0')}/'
          '${tanggal.month.toString().padLeft(2, '0')}/'
          '${tanggal.year}';
    } catch (_) {
      return '-';
    }
  }

  // Navigasi Bottom Navbar Admin.
  void _navigasiAdmin(int index) {
    if (index == 3) return;

    Widget halaman;

    switch (index) {
      case 0:
        halaman = const DashboardAdminScreen();
        break;
      case 1:
        halaman = const LaporanAdminPage();
        break;
      case 2:
        halaman = const PetugasPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => halaman),
    );
  }

  // Membuka halaman manajemen petugas.
  void _bukaManajemenPetugas() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TambahPetugasPage(),
      ),
    );
  }

  // Logout Admin.
  Future<void> _logout() async {
    try {
      await supabase.auth.signOut();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => LoginPage(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal logout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _konfirmasiLogout() {
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
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _logout();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: BottomNavbarAdmin(
        currentIndex: 3,
        onTap: _navigasiAdmin,
      ),

      body: SafeArea(
        child: Column(
          children: [
            _header(),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _muatDataProfil,
                child: _kontenProfil(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF0F2F7),
          ),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil Administrator',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101828),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Biro Sarana & Prasarana Unkhair',
                  style: TextStyle(
                    fontSize: 11,
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
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 14,
                  color: biru,
                ),
                SizedBox(width: 5),
                Text(
                  'Admin Utama',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: biru,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kontenProfil() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: biru),
      );
    }

    if (errorMessage != null) {
      return ListView(
        padding: const EdgeInsets.all(25),
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 40,
          ),
          const SizedBox(height: 12),
          const Text(
            'Gagal memuat profil administrator',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: ElevatedButton.icon(
              onPressed: _muatDataProfil,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 22),
      children: [
        _kartuProfil(),
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

        _informasiAkun(),
        const SizedBox(height: 20),

        const Text(
          'Manajemen Akun',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF24334D),
          ),
        ),
        const SizedBox(height: 10),

        _menuManajemenPetugas(),
        const SizedBox(height: 20),

        _tombolLogout(),
      ],
    );
  }

  Widget _kartuProfil() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [biru, navy],
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
                child: Text(
                  inisialAdmin,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: biru,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaAdmin,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      emailAdmin,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFDCE7FF),
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: Color(0xFF5DF0B0),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Administrator Aktif',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
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

          Row(
            children: [
              Expanded(
                child: _Statistik(
                  angka: '${statistik['total'] ?? 0}',
                  label: 'Laporan\nKampus',
                ),
              ),
              Expanded(
                child: _Statistik(
                  angka: '${statistik['diverifikasi'] ?? 0}',
                  label: 'Diverifikasi',
                ),
              ),
              Expanded(
                child: _Statistik(
                  angka: '${statistik['petugas'] ?? 0}',
                  label: 'Akun\nPetugas',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _informasiAkun() {
    return Container(
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
      child: Column(
        children: [
          _InfoBaris(
            ikon: Icons.person_outline,
            label: 'Nama Lengkap',
            nilai: namaAdmin,
          ),
          _InfoBaris(
            ikon: Icons.mail_outline,
            label: 'Email',
            nilai: emailAdmin,
          ),
          _InfoBaris(
            ikon: Icons.badge_outlined,
            label: 'ID Pengguna',
            nilai: profilAdmin?['id_pengguna']?.toString() ?? '-',
          ),
          _InfoBaris(
            ikon: Icons.admin_panel_settings_outlined,
            label: 'Jabatan / Peran',
            nilai: profilAdmin?['role']?.toString() ?? 'admin',
          ),
          _InfoBaris(
            ikon: Icons.calendar_today_outlined,
            label: 'Tanggal Bergabung',
            nilai: tanggalBergabung,
          ),
          const _InfoBaris(
            ikon: Icons.verified_user_outlined,
            label: 'Status Akun',
            nilai: 'Aktif',
            terakhir: true,
            status: true,
          ),
        ],
      ),
    );
  }

  // Menu manajemen akun petugas.
  Widget _menuManajemenPetugas() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: _bukaManajemenPetugas,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFE0E7F1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.manage_accounts_outlined,
                  color: biru,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manajemen Akun Petugas',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF24334D),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Tambah dan kelola akun teknisi CampusReport',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF71809A),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: Color(0xFF8DA1C0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tombolLogout() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: _konfirmasiLogout,
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
                        style: const TextStyle(
                          fontSize: 10,
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
