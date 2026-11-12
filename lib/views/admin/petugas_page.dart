import 'dart:ui';
import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar_admin.dart';
import 'dashboard_admin.dart';
import 'laporan_admin_page.dart';
import 'profil_administrator.dart';
import '../../services/admin/admin_petugas_service.dart';

const Color biru = Color(0xFF1743D1);
const Color biruMuda = Color(0xFFE1EDFF);
const Color latar = Color(0xFFF7F9FC);
const Color garis = Color(0xFFDCE5F1);
const Color teks = Color(0xFF14213D);
const Color abu = Color(0xFF71819D);

class PetugasPage extends StatefulWidget {
  const PetugasPage({super.key});

  @override
  State<PetugasPage> createState() => _PetugasPageState();
}

class _PetugasPageState extends State<PetugasPage> {
  final TextEditingController pencarianController =
      TextEditingController();

    
  final AdminPetugasService _adminPetugasService =
      AdminPetugasService();

  List<Map<String, dynamic>> daftarPetugas = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _muatPetugas();
  }

  Future<void> _muatPetugas() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final data =
          await _adminPetugasService.getDaftarPetugas();

      if (!mounted) return;

      setState(() {
        daftarPetugas = data.map((item) {
          final nama =
              item['nama_pengguna']?.toString() ?? 'Tanpa nama';

          final jumlah =
              (item['jumlah_penugasan'] as num?)?.toInt() ?? 0;

          final inisial = nama
              .trim()
              .split(RegExp(r'\s+'))
              .where((kata) => kata.isNotEmpty)
              .take(2)
              .map((kata) => kata[0].toUpperCase())
              .join();

          return {
            'id_pengguna': item['id_pengguna'],
            'auth_id': item['auth_id'],
            'nama': nama,
            'email': item['email']?.toString() ?? '-',
            'inisial': inisial.isEmpty ? 'P' : inisial,

            'jabatan': item['jabatan']?.toString() ?? 'Belum diisi',
            'keahlian': item['keahlian']?.toString() ?? 'Belum diisi',
            'kontak': item['no_telepon']?.toString() ?? 'Belum diisi',

            'status': 'Terdaftar',

            'tugas': jumlah,
            'beban': jumlah == 0
                ? 'Belum ada penugasan'
                : '$jumlah penugasan tercatat',
          };
        }).toList();

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  List<Map<String, dynamic>> get petugasTerfilter {
    final kata = pencarianController.text.trim().toLowerCase();

    return daftarPetugas.where((petugas) {
      return petugas['nama']
              .toString()
              .toLowerCase()
              .contains(kata) ||
          petugas['email']
              .toString()
              .toLowerCase()
              .contains(kata);
    }).toList();
  }

  @override
  void dispose() {
    pencarianController.dispose();
    super.dispose();
  }
  
  void _navigasiAdmin(int index) {
    if (index == 2) return;

    Widget halaman;

    switch (index) {
      case 0:
        halaman = const DashboardAdminScreen();
        break;
      case 1:
        halaman = const LaporanAdminPage();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          _header(),

          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF0F3F8),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                23, 14, 23, 16,
              ),
              children: [
                _kolomPencarian(),
                const SizedBox(height: 14),

                _bannerPenanganan(),
                const SizedBox(height: 14),
                
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(35),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: biru,
                      ),
                    ),
                  )
                else if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 35,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Gagal mengambil data petugas',
                          style: const TextStyle(
                            color: teks,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: abu,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _muatPetugas,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                else if (petugasTerfilter.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Petugas tidak ditemukan.',
                        style: TextStyle(color: abu),
                      ),
                    ),
                  )
                else
                  ...petugasTerfilter.map(
                    (petugas) => Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: _kartuPetugas(petugas),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),

    bottomNavigationBar: BottomNavbarAdmin(
      currentIndex: 2,
      onTap: _navigasiAdmin,
    ),
  );
  }
  
  // HEADER DAFTAR PETUGAS
  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(23, 20, 23, 18),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Judul dan subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar Petugas',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: teks,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Staf Teknisi Sarpras · Kampus III',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF506B91),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Jumlah petugas
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F6FF),
              border: Border.all(
                color: const Color(0xFFBBD5FF),
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.people_alt_outlined,
                  size: 19,
                  color: biru,
                ),
                const SizedBox(width: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${daftarPetugas.length}',
                      style: const TextStyle(
                        color: biru,
                        fontSize: 14,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Petugas',
                      style: TextStyle(
                        color: biru,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // PENCARIAN PETUGAS
  Widget _kolomPencarian() {
    return Container(
      height: 41,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: latar,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: garis),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Color(0xFF8CA0BD),
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: pencarianController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(
                fontSize: 13,
                color: teks,
              ),
              decoration: const InputDecoration(
                hintText: 'Cari nama atau email petugas...',
                hintStyle: TextStyle(
                  color: Color(0xFF929DB0),
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BANNER BIRU
  Widget _bannerPenanganan() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2050ED),
            Color(0xFF1939B9),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: biru.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'UNIT PENANGANAN\nCEPAT',
                  style: TextStyle(
                    color: Color(0xFFD9E5FF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.35,
                  ),
                ),
              ),
              Container(
                width: 78,
                padding: const EdgeInsets.symmetric(
                  horizontal: 9, vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C58B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Siaga\nPenuh',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'Teknisi Lapangan Siaga Pemeliharaan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Pilih teknisi untuk melihat profil keahlian, '
            'nomor kontak darurat, dan beban tugas berjalan.',
            style: TextStyle(
              color: Color(0xFFDCE6FF),
              fontSize: 12,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  // KARTU PETUGAS: SELURUH KARTU BISA DIKLIK
  Widget _kartuPetugas(Map<String, dynamic> petugas) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _bukaDetail(petugas),
        borderRadius: BorderRadius.circular(17),
        child: Container(
          constraints: const BoxConstraints(minHeight: 96),
          padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFD),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: garis),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: biruMuda,
                  border: Border.all(
                    color: const Color(0xFFBBD5FF),
                  ),
                ),
                child: Center(
                  child: Text(
                    petugas['inisial']?.toString() ?? 'P',
                    style: const TextStyle(
                      color: biru,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            petugas['nama']?.toString() ?? 'Tanpa nama',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: teks,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8FFF6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF8CEBC9),
                            ),
                          ),
                          child: Text(
                            petugas['status']?.toString() ?? 'Terdaftar',
                            style: const TextStyle(
                              color: Color(0xFF009C70),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      petugas['jabatan']?.toString() ?? 'Belum diisi',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: biru,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      petugas['keahlian']?.toString() ?? 'Belum diisi',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: abu,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: garis),
                    ),
                    child: Text(
                      '${petugas['tugas']} Tugas',
                      style: const TextStyle(
                        color: Color(0xFF40516D),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Detail',
                        style: TextStyle(
                          color: biru,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Color(0xFF8CA0BD),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // POPUP PROFIL SESUAI PETUGAS YANG DIPILIH
  void _bukaDetail(Map<String, dynamic> petugas) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0x990D172D),
      builder: (dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  22, 22, 22, 21,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2160FF),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: biru.withValues(alpha: 0.18),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              petugas['inisial']?.toString() ?? 'P',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                petugas['nama']?.toString() ?? 'Tanpa nama',
                                style: const TextStyle(
                                  color: teks,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                petugas['jabatan']?.toString() ?? 'Belum diisi',
                                style: const TextStyle(
                                  color: biru,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8FFF5),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF8CEBC9),
                                  ),
                                ),
                                child: Text(
                                  '• Status: ${petugas['status']?.toString() ?? 'Terdaftar'}',
                                  style: const TextStyle(
                                    color: Color(0xFF009C70),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 5),

                        InkWell(
                          onTap: () =>
                              Navigator.pop(dialogContext),
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF0F4F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Color(0xFF657995),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 19),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F9FC),
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: garis),
                      ),
                      child: Column(
                        children: [
                          _barisInformasi(
                              ikon: Icons.handyman_outlined,
                              label: 'Bidang\nKeahlian:',
                              isi: petugas['keahlian']?.toString() ?? 'Belum diisi',
                            ),
                          const Divider(
                            height: 1,
                            color: Color(0xFFE6ECF4),
                          ),

                          _barisInformasi(
                            ikon: Icons.email_outlined,
                            label: 'Email:',
                            isi: petugas['email']?.toString() ?? 'Belum diisi',
                          ),
                          _barisInformasi(
                            ikon: Icons.phone_outlined,
                            label: 'Kontak\nTelepon/WA:',
                            isi: petugas['kontak']?.toString() ?? 'Belum diisi',
                            warnaIsi: biru,
                            tebal: true,
                          ),
                          const Divider(
                            height: 1,
                            color: Color(0xFFE6ECF4),
                          ),
                          _barisInformasi(
                            ikon:
                                Icons.home_repair_service_outlined,
                            label: 'Beban\nPekerjaan:',
                            isi: petugas['beban']?.toString() ?? 'Belum diisi',
                            tebal: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // BARIS INFORMASI POPUP
  Widget _barisInformasi({
    required IconData ikon,
    required String label,
    required String isi,
    Color warnaIsi = teks,
    bool tebal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            ikon,
            size: 14,
            color: const Color(0xFF8DA0BE),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 91,
            child: Text(
              label,
              style: const TextStyle(
                color: abu,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              isi,
              style: TextStyle(
                color: warnaIsi,
                fontSize: 12,
                height: 1.5,
                fontWeight:
                    tebal ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}