import 'package:flutter/material.dart';

class ProfileAdminScreen extends StatefulWidget {
  const ProfileAdminScreen({super.key});

  @override
  State<ProfileAdminScreen> createState() => _ProfileAdminScreenState();
}

class _ProfileAdminScreenState extends State<ProfileAdminScreen> {
  int _selectedNavIndex = 3; // Profil Aktif

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
              // --- 1. HEADER PROFIL ---
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color(0xFF0F172A)),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Profil\nAdministrator',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Biro Sarana &\nPrasarana Unkhair',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge Admin Utama
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.verified_user_outlined,
                            size: 14, color: Color(0xFF2563EB)),
                        SizedBox(width: 4),
                        Text(
                          'Admin\nUtama',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- 2. KARTU PROFIL UTAMA (BIRU) ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1D4ED8), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Avatar AA
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'AA',
                              style: TextStyle(
                                color: Color(0xFF1E3A8A),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Arasya Admin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'admin@gmail.com',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: const [
                                  Icon(Icons.check_circle_outline,
                                      color: Color(0xFF34D399), size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    'Status Akun:\nAdministrator Aktif',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 12),

                    // Indikator Statis 3 Kolom
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('6', 'Laporan\nKampus'),
                        _buildStatItem('4', 'Diverifikasi'),
                        _buildStatItem('4', 'Petugas\nSiaga'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- 3. INFORMASI AKUN ADMINISTRATOR ---
              const Text(
                'Informasi Akun Administrator',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                        Icons.person_outline, 'Nama Lengkap:', 'Arasya Admin'),
                    const Divider(color: Color(0xFFF1F5F9), height: 20),
                    _buildInfoRow(
                        Icons.email_outlined, 'Email Dinas:', 'admin@gmail.com',
                        isMonospace: true),
                    const Divider(color: Color(0xFFF1F5F9), height: 20),
                    _buildInfoRow(
                        Icons.badge_outlined, 'NIP:', '19780512 200501 1 003',
                        isMonospace: true),
                    const Divider(color: Color(0xFFF1F5F9), height: 20),
                    _buildInfoRow(Icons.business_outlined, 'Jabatan /\nPeran:',
                        'Kepala Biro\nAdministrasi & Sarpras'),
                    const Divider(color: Color(0xFFF1F5F9), height: 20),

                    // Baris Status Akun Badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: Color(0xFF10B981), size: 18),
                        const SizedBox(width: 10),
                        const Text(
                          'Status\nAkun:',
                          style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                              height: 1.2),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFA7F3D0)),
                          ),
                          child: const Text(
                            'Aktif &\nTerverifikasi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF047857),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- 4. TOMBOL KELUAR PORTAL ADMINISTRATOR ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEF2F2),
                    elevation: 0,
                    side: const BorderSide(color: Color(0xFFFECACA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout, color: Color(0xFFDC2626), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Keluar Portal Administrator',
                        style: TextStyle(
                          color: Color(0xFFDC2626),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      // --- 5. BOTTOM NAVIGATION BAR ADMIN ---
      bottomNavigationBar: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.bar_chart_rounded, 'Dashboard', 0),
            _buildNavItem(Icons.description_outlined, 'Laporan', 1),
            _buildNavItem(Icons.group_outlined, 'Petugas', 2),
            _buildNavItem(Icons.person_outline, 'Profil', 3),
          ],
        ),
      ),
    );
  }

  // Helper Item Statistik Kolom
  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  // Helper Baris Informasi Kartu
  Widget _buildInfoRow(IconData icon, String label, String value,
      {bool isMonospace = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF94A3B8), size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
              color: Color(0xFF64748B), fontSize: 13, height: 1.2),
        ),
        const Spacer(),
        Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: isMonospace ? 'monospace' : null,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  // Helper Item Navigasi Bawah
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedNavIndex == index;
    final color =
        isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
