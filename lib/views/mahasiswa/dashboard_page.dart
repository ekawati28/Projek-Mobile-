import '../../services/dashboard_service.dart';
import '../../models/dashboard_model.dart';
import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';
import 'buat_laporan_page.dart';
import 'detail_laporan_page.dart';
import 'profile_page.dart';
import 'riwayat_laporan_page.dart';
import 'notifikasi_mahasiswa.dart' hide DetailLaporanPage;
import '../../services/notifikasi_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardService dashboardService = DashboardService();
  final NotifikasiService notifikasiService = NotifikasiService();

  late Future<DashboardModel> dashboardFuture;
  late Future<int> jumlahNotifikasiFuture;


  @override
  void initState() {
    super.initState();

    dashboardFuture = dashboardService.getDashboard();
    jumlahNotifikasiFuture =
        notifikasiService.getJumlahBelumDibaca();
  }

  String formatTanggal(DateTime tanggal) {
    const bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    return '${tanggal.day} ${bulan[tanggal.month - 1]} ${tanggal.year}';
  }
  
  
  Future<void> handleBottomNavigation(int index) async {
    switch (index) {
      case 0:
        // Dashboard adalah halaman utama.
        break;

      case 1:
        await Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (context) => RiwayatLaporanScreen(
              onNavTap: (selectedIndex) {
                if (selectedIndex == 1) return;

                Navigator.pop(context);
                handleBottomNavigation(selectedIndex);
              },
            ),
          ),
        );

        if (!mounted) return;

        setState(() {
          dashboardFuture = dashboardService.getDashboard();
        });
        break;

      case 2:
        final laporanBerhasil = await Navigator.push<bool>(
          context,
          MaterialPageRoute<bool>(
            builder: (context) => BuatLaporanScreen(
              onNavTap: (selectedIndex) {
                if (selectedIndex == 2) return;

                Navigator.pop(context);
                handleBottomNavigation(selectedIndex);
              },
            ),
          ),
        );

        if (!mounted) return;

        if (laporanBerhasil == true) {
          setState(() {
            dashboardFuture = dashboardService.getDashboard();
          });
        }
        break;

      case 3:
        await Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (context) => ProfilePage(
              onNavTap: (selectedIndex) {
                if (selectedIndex == 3) return;

                Navigator.pop(context);
                handleBottomNavigation(selectedIndex);
              },
            ),
          ),
        );

        if (!mounted) return;

        setState(() {
          dashboardFuture = dashboardService.getDashboard();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardModel>(
      future: dashboardFuture,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting &&
    !snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Gagal memuat dashboard: ${snapshot.error}',
              ),
            ),
          );
        }

        final data = snapshot.data!;

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
                            children: [
                              Text(
                                'Halo, ${data.namaPengguna}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                '👋',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(width: 6),
                              Text('👋', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ],
                      ),
                      
                      InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotifikasiMahasiswa(),
                            ),
                          );

                          if (!mounted) return;

                          setState(() {
                            jumlahNotifikasiFuture =
                                notifikasiService.getJumlahBelumDibaca();
                          });
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: FutureBuilder<int>(
                          future: jumlahNotifikasiFuture,
                          builder: (context, snapshot) {
                            final jumlah = snapshot.data ?? 0;

                            return Stack(
                              clipBehavior: Clip.none,
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
                                if (jumlah > 0)
                                  Positioned(
                                    right: -3,
                                    top: -3,
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        minWidth: 19,
                                        minHeight: 19,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        jumlah > 99 ? '99+' : '$jumlah',
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
                            );
                          },
                        ),
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
                            onPressed: () {
                              handleBottomNavigation(2);
                            },
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
                    children: [
                      const Text(
                        'Status Laporan Saya',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          handleBottomNavigation(1);
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 6,
                          ),
                          child: Text(
                            'Lihat Detail',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1D5EF8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Status Cards (2 1 1 2)
                  Row(
                    children: [
                      Expanded(
                        child: StatusCard(
                          count: data.diajukan.toString(),
                          label: 'Diajukan',
                          bgColor: Color(0xFFFFFBEC),
                          borderColor: Color(0xFFFFE082),
                          textColor: Color(0xFFB45309),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: StatusCard(
                          count: data.diverifikasi.toString(),
                          label: 'Diverifikasi',
                          bgColor: Color(0xFFEFF6FF),
                          borderColor: Color(0xFFBFDBFE),
                          textColor: Color(0xFF1D4ED8),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: StatusCard(
                          count: data.diproses.toString(),
                          label: 'Diproses',
                          bgColor: Color(0xFFFAF5FF),
                          borderColor: Color(0xFFE9D5FF),
                          textColor: Color(0xFF7E22CE),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: StatusCard(
                          count: data.selesai.toString(),
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
                if (data.laporanTerbaru.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Belum ada laporan terbaru.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...data.laporanTerbaru.map((laporan) {
                    Color statusBg;
                    Color statusColor;

                    switch (laporan.status.trim()) {
                      case 'Diajukan':
                        statusBg = const Color(0xFFFFFBEC);
                        statusColor = const Color(0xFFB45309);
                        break;
                      case 'Diverifikasi':
                        statusBg = const Color(0xFFEFF6FF);
                        statusColor = const Color(0xFF1D4ED8);
                        break;
                      case 'Diproses':
                        statusBg = const Color(0xFFFAF5FF);
                        statusColor = const Color(0xFF7E22CE);
                        break;
                      case 'Selesai':
                        statusBg = const Color(0xFFECFDF5);
                        statusColor = const Color(0xFF047857);
                        break;
                      default:
                        statusBg = Colors.grey.shade100;
                        statusColor = Colors.grey.shade700;
                    }

                    return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailLaporanPage(
                              laporan: laporan,
                            ),
                          ),
                        );
                      },
                      child: LaporanCard(
                        icon: Icons.description_outlined,
                        iconBg: const Color(0xFFE0F2FE),
                        iconColor: const Color(0xFF0284C7),
                        title: laporan.deskripsi,
                        code: '#CR-${laporan.idLaporan}',
                        location: laporan.lokasi,
                        locationColor: Colors.grey,
                        date: formatTanggal(laporan.waktuDibuat),
                        statusText: laporan.status,
                        statusBg: statusBg,
                        statusColor: statusColor,
                        isBordered: false,
                      ),
                    ),
                    );
                  }),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: 0,
            onTap: handleBottomNavigation,
          ),
        );
      },
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
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
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

