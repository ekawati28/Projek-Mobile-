import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'UNIVERSITAS KHAIRUN',
                        style: TextStyle(
                          color: Color(0xFF1E56A0),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Text(
                            'Halo, Mahasiswa',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text('👋', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.black87,
                          size: 22,
                        ),
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '2',
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
                ],
              ),
              const SizedBox(height: 20),

              // Banner Biru
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D5EF8),
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1D5EF8).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pusat Aspirasi Sarpras',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ada fasilitas kampus yang bermasalah?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Laporkan kerusakan AC, listrik, kursi, atau toilet agar segera ditangani tim sarpras.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1D5EF8),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add, size: 22, color: Color(0xFF1D5EF8)),
                            SizedBox(width: 4),
                            Text(
                              '+ Buat Laporan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D5EF8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Header Status Laporan Saya
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Status Laporan Saya',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Lihat Detail',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D5EF8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Status Cards (2 1 1 2)
              Row(
                children: const [
                  Expanded(
                    child: StatusCard(
                      count: '2',
                      label: 'Diajukan',
                      bgColor: Color(0xFFFFFBEC),
                      borderColor: Color(0xFFFFE082),
                      textColor: Color(0xFFB45309),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: StatusCard(
                      count: '1',
                      label: 'Diverifikasi',
                      bgColor: Color(0xFFEFF6FF),
                      borderColor: Color(0xFFBFDBFE),
                      textColor: Color(0xFF1D4ED8),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: StatusCard(
                      count: '1',
                      label: 'Diproses',
                      bgColor: Color(0xFFFAF5FF),
                      borderColor: Color(0xFFE9D5FF),
                      textColor: Color(0xFF7E22CE),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: StatusCard(
                      count: '2',
                      label: 'Selesai',
                      bgColor: Color(0xFFECFDF5),
                      borderColor: Color(0xFFA7F3D0),
                      textColor: Color(0xFF047857),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Header Laporan Terbaru
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Laporan Terbaru',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '3 Terkini',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // List Laporan
              const LaporanCard(
                icon: Icons.air,
                iconBg: Color(0xFFE0F2FE),
                iconColor: Color(0xFF0284C7),
                title: 'AC di LAP RPL...',
                code: '#CR-2026-0941',
                location: 'LAP RPL',
                locationColor: Colors.red,
                date: '19 Sep 2026',
                statusText: 'Diajukan',
                statusBg: Color(0xFFFFFBEC),
                statusColor: Color(0xFFB45309),
                isBordered: true,
              ),
              const SizedBox(height: 12),
              const LaporanCard(
                icon: Icons.bolt,
                iconBg: Color(0xFFFEF9C3),
                iconColor: Color(0xFFCA8A04),
                title: 'Lampu JT3 Mati',
                code: '#CR-0892',
                location: 'JT3',
                locationColor: Colors.grey,
                date: '18 Sep 2026',
                statusText: 'Diverifikasi',
                statusBg: Color(0xFFEFF6FF),
                statusColor: Color(0xFF1D4ED8),
                isBordered: false,
              ),
              const SizedBox(height: 12),
              const LaporanCard(
                icon: Icons.chair_outlined,
                iconBg: Color(0xFFECFDF5),
                iconColor: Color(0xFF059669),
                title: 'Kursi Rusak di JT1',
                code: '#CR-0845',
                location: 'JT1',
                locationColor: Colors.grey,
                date: '17 Sep 2026',
                statusText: 'Selesai',
                statusBg: Color(0xFFECFDF5),
                statusColor: Color(0xFF047857),
                isBordered: false,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF1D5EF8),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF1D5EF8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
            label: 'Buat Laporan',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String count;
  final String label;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;

  const StatusCard({
    Key? key,
    required this.count,
    required this.label,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class LaporanCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String code;
  final String location;
  final Color locationColor;
  final String date;
  final String statusText;
  final Color statusBg;
  final Color statusColor;
  final bool isBordered;

  const LaporanCard({
    Key? key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.code,
    required this.location,
    required this.locationColor,
    required this.date,
    required this.statusText,
    required this.statusBg,
    required this.statusColor,
    required this.isBordered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isBordered ? const Color(0xFF93C5FD) : Colors.grey.shade200,
          width: isBordered ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF3F4F6)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 15, color: locationColor),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 15, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}