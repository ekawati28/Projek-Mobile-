
import 'package:flutter/material.dart';

import '../../widgets/bottom_navbar.dart';
import '../../controllers/auth_controller.dart';
import '../../services/profile_service.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  final ValueChanged<int>? onNavTap;

  const ProfilePage({
    super.key,
    this.onNavTap,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService profileService = ProfileService();

  late Future<Map<String, dynamic>> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = profileService.getProfile();
  }

  Future<void> _refreshProfile() async {
    final futureBaru = profileService.getProfile();

    setState(() {
      profileFuture = futureBaru;
    });

    await futureBaru;
  }

  String _inisial(String nama) {
    final bagian = nama
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (bagian.isEmpty) return 'M';

    if (bagian.length == 1) {
      return bagian.first.substring(0, 1).toUpperCase();
    }

    return '${bagian.first[0]}${bagian.last[0]}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Gagal memuat profil mahasiswa.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _refreshProfile,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final data = snapshot.data!;

            final nama =
                data['nama_pengguna']?.toString() ??
                'Mahasiswa';

            final email =
                data['email']?.toString() ?? '-';

            final totalLaporan =
                data['total_laporan'] as int? ?? 0;

            final totalSelesai =
                data['total_selesai'] as int? ?? 0;

            final persentase = totalLaporan == 0
                ? 0
                : (totalSelesai * 100 / totalLaporan)
                    .round();

            return RefreshIndicator(
              onRefresh: _refreshProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER PROFIL
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Profil\nMahasiswa',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius:
                                BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFBFDBFE),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified,
                                color: Color(0xFF2563EB),
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Akun\nTerverifikasi',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1D4ED8),
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // KARTU PROFIL UTAMA
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E40AF),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _inisial(nama),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                          FontWeight.bold,
                                      color: Color(0xFF1E40AF),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nama,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      email,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: Colors.white70,
                                          size: 13,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Akun Mahasiswa Aktif',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          const Divider(
                            color: Colors.white24,
                            height: 1,
                          ),
                          const SizedBox(height: 16),

                          // STATISTIK DARI DATABASE
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                '$totalLaporan',
                                'Laporan',
                              ),
                              _buildStatDivider(),
                              _buildStatItem(
                                '$totalSelesai',
                                'Selesai',
                              ),
                              _buildStatDivider(),
                              _buildStatItem(
                                '$persentase%',
                                'Selesai',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // INFORMASI AKUN
                    const Text(
                      'Informasi Akun Mahasiswa',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            icon: Icons.person_outline,
                            label: 'Nama Lengkap:',
                            value: nama,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Divider(
                              color: Color(0xFFF1F5F9),
                              height: 1,
                            ),
                          ),
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            label: 'Email:',
                            value: email,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Divider(
                              color: Color(0xFFF1F5F9),
                              height: 1,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                size: 18,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Status Akun:',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Aktif',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF15803D),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // LOGOUT
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(
                          Icons.logout,
                          color: Color(0xFFDC2626),
                          size: 18,
                        ),
                        label: const Text(
                          'Keluar Akun (Logout)',
                          style: TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFFEF2F2),
                          side: const BorderSide(
                            color: Color(0xFFFCA5A5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          widget.onNavTap?.call(index);
        },
      ),
    );
  }

  Future<void> _logout() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Keluar Akun'),
          content: const Text(
            'Apakah kamu yakin ingin keluar dari akun CampusReport?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Keluar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true || !mounted) return;

    try {
      await AuthController().logout();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal keluar dari akun: $e'),
        ),
      );
    }
  }

  static Widget _buildStatItem(
    String count,
    String label,
  ) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  static Widget _buildStatDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.white24,
    );
  }

  static Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF64748B),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
