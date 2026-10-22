
import 'package:flutter/material.dart';
import '../../services/timeline_service.dart';


class TimelineMonitoringPage extends StatefulWidget {
  final int idLaporan;

  const TimelineMonitoringPage({
    super.key,
    required this.idLaporan,
  });

  @override
    State<TimelineMonitoringPage> createState() =>
        _TimelineMonitoringPageState();
  }

  class _TimelineMonitoringPageState extends State<TimelineMonitoringPage> {
    final TimelineService timelineService = TimelineService();

    late Future<Map<String, dynamic>> timelineFuture;
    late Future<List<Map<String, dynamic>>> riwayatFuture;

    static const Color biru = Color(0xFF315B9D);
    static const Color teks = Color(0xFF273449);
    static const Color abu = Color(0xFF718096);
    static const Color garis = Color(0xFFE1E8F2);
    static const Color latar = Color(0xFFF7F9FC);
    static const Color hijau = Color(0xFF00BF8A);

  @override
  void initState() {
    super.initState();

    timelineFuture = timelineService.getDetailLaporan(
      widget.idLaporan,
    );

    riwayatFuture = timelineService.getRiwayatLaporan(
      widget.idLaporan,
    );
  }

  String formatTanggalRiwayat(dynamic tanggal) {
    if (tanggal == null) return '-';

    final waktu = DateTime.tryParse(tanggal.toString());
    if (waktu == null) return '-';

    final lokal = waktu.toLocal();

    const bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];

    return '${lokal.day} ${bulan[lokal.month - 1]} ${lokal.year}';
  }

  String formatJamRiwayat(dynamic tanggal) {
    if (tanggal == null) return '-';

    final waktu = DateTime.tryParse(tanggal.toString());
    if (waktu == null) return '-';

    final lokal = waktu.toLocal();

    final jam = lokal.hour.toString().padLeft(2, '0');
    final menit = lokal.minute.toString().padLeft(2, '0');

    return '$jam:$menit';
  }

  Color warnaStatus(String status) {
    switch (status.toLowerCase()) {
      case 'diverifikasi':
        return const Color(0xFF2563EB);
      case 'diproses':
        return const Color(0xFF7C3AED);
      case 'selesai':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF9A6700);
    }
  }

  Color warnaBackgroundStatus(String status) {
    switch (status.toLowerCase()) {
      case 'diverifikasi':
        return const Color(0xFFDBEAFE);
      case 'diproses':
        return const Color(0xFFEDE9FE);
      case 'selesai':
        return const Color(0xFFD1FAE5);
      default:
        return const Color(0xFFFFF3CD);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: timelineFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Gagal memuat laporan: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('Laporan tidak ditemukan.'),
              );
            }

            final detail = snapshot.data!;

            final status = detail['status']?.toString().trim().toLowerCase()
                ?? 'diajukan';

            const tahapan = [
              'diajukan',
              'diverifikasi',
              'diproses',
              'selesai',
            ];

            final tahapSekarang = tahapan.indexOf(status);

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: riwayatFuture,
            builder: (context, riwayatSnapshot) {
              if (riwayatSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (riwayatSnapshot.hasError) {
                return Center(
                  child: Text(
                    'Gagal memuat riwayat: ${riwayatSnapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final riwayat = riwayatSnapshot.data ??
                  <Map<String, dynamic>>[];

              final riwayatDiajukan = riwayat.where(
                (item) =>
                    item['status']?.toString().trim().toLowerCase() ==
                    'diajukan',
              ).toList();

              final dataDiajukan = riwayatDiajukan.isNotEmpty
                  ? riwayatDiajukan.first
                  : null;

              final riwayatDiverifikasi = riwayat.where(
                (item) =>
                    item['status']?.toString().trim().toLowerCase() ==
                    'diverifikasi',
              ).toList();

              final dataDiverifikasi = riwayatDiverifikasi.isNotEmpty
                  ? riwayatDiverifikasi.first
                  : null;

              final riwayatDiproses = riwayat.where(
                (item) =>
                    item['status']?.toString().trim().toLowerCase() ==
                    'diproses',
              ).toList();

              final dataDiproses = riwayatDiproses.isNotEmpty
                  ? riwayatDiproses.first
                  : null;
              
              final riwayatSelesai = riwayat.where(
                (item) =>
                    item['status']?.toString().trim().toLowerCase() ==
                    'selesai',
              ).toList();

              final dataSelesai = riwayatSelesai.isNotEmpty
                  ? riwayatSelesai.first
                  : null;

              return Column(
              children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEDF1F7)),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: latar,
                          shape: BoxShape.circle,
                          border: Border.all(color: garis),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: teks,
                          size: 19,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monitoring Status',
                          style: TextStyle(
                            color: teks,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Pelacakan Linimasa',
                          style: TextStyle(
                            color: abu,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(height: 9),
                        Text(
                          'Tiket',
                          style: TextStyle(
                            color: abu,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 82,
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF5FF),
                      border: Border.all(
                        color: const Color(0xFFBBD2FF),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '#CR-${detail['id_laporan']}',
                      style: const TextStyle(
                        color: Color(0xFF2458A6),
                        fontSize: 9,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // KONTEN YANG BISA DIGULIR
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KARTU INFORMASI LAPORAN
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: latar,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: garis),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (detail['judul']?.toString().trim().isNotEmpty ?? false)
                                      ? detail['judul'].toString()
                                      : detail['lpr_deskripsi']?.toString() ?? '-',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: teks,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  detail['lokasi']?.toString() ?? '-',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: abu,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: warnaBackgroundStatus(status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              detail['status']?.toString() ?? 'Diajukan',
                              style: TextStyle(
                                color: warnaStatus(status),
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // TAHAP 1
                    TimelineTile(
                      number: '1',
                      title: 'Diajukan',
                      subtitle: 'Laporan Dikirim Mahasiswa',
                      description:
                          dataDiajukan?['catatan']?.toString() ??
                          'Belum ada catatan pengajuan.',
                      date: formatTanggalRiwayat(
                        dataDiajukan?['rwyt_waktu_dibuat'],
                      ),
                      time: formatJamRiwayat(
                        dataDiajukan?['rwyt_waktu_dibuat'],
                      ),
                      isCompleted: tahapSekarang >= 0,
                      isLast: false,
                    ),

                    // TAHAP 2
                    TimelineTile(
                      number: '2',
                      title: 'Diverifikasi',
                      subtitle: 'Diperiksa Administrator',
                      description:
                          dataDiverifikasi?['catatan']?.toString() ??
                          'Belum ada catatan verifikasi.',
                      date: formatTanggalRiwayat(
                        dataDiverifikasi?['rwyt_waktu_dibuat'],
                      ),
                      time: formatJamRiwayat(
                        dataDiverifikasi?['rwyt_waktu_dibuat'],
                      ),
                      isCompleted: tahapSekarang >= 1,
                      isLast: false,
                    ),

                    // TAHAP 3
                    TimelineTile(
                      number: '3',
                      title: 'Diproses',
                      subtitle: 'Sedang Ditangani Petugas',
                      description:
                          dataDiproses?['catatan']?.toString() ??
                          'Belum ada catatan penanganan.',
                      date: formatTanggalRiwayat(
                        dataDiproses?['rwyt_waktu_dibuat'],
                      ),
                      time: formatJamRiwayat(
                        dataDiproses?['rwyt_waktu_dibuat'],
                      ),
                      isCompleted: tahapSekarang >= 2,
                      isLast: false,
                    ),

                    // TAHAP 4
                    TimelineTile(
                      number: '4',
                      title: 'Selesai',
                      subtitle: 'Permasalahan Telah Ditangani',
                      description:
                          dataSelesai?['catatan']?.toString() ??
                          'Laporan belum dinyatakan selesai.',
                      date: formatTanggalRiwayat(
                        dataSelesai?['rwyt_waktu_dibuat'],
                      ),
                      time: formatJamRiwayat(
                        dataSelesai?['rwyt_waktu_dibuat'],
                      ),
                      isCompleted: tahapSekarang >= 3,
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),

            // NOTIFIKASI BAGIAN BAWAH
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFD),
                border: Border(
                  top: BorderSide(color: Color(0xFFEDF1F7)),
                ),
              ),
              child: const Text(
                'Notifikasi status otomatis terkirim via aplikasi & '
                'email mahasiswa.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5877A6),
                  fontSize: 10,
                  height: 1.5,
                ),
              ),
            ),
          ],
          );
        },
        );
          },
        ),
      ),
    );
  }
}

// KOMPONEN SETIAP TAHAP TIMELINE
class TimelineTile extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final String description;
  final String date;
  final String time;
  final bool isCompleted;
  final bool isLast;

  const TimelineTile({
    super.key,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.date,
    required this.time,
    required this.isCompleted,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    const Color teks = Color(0xFF273449);
    const Color abu = Color(0xFF718096);

    final Color warnaIkon = isCompleted
        ? const Color(0xFF00BF8A)
        : const Color(0xFFB8C9E1);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // NOMOR DAN GARIS PENGHUBUNG
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 21,
                  height: 21,
                  decoration: BoxDecoration(
                    color: isCompleted ? warnaIkon : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: warnaIkon,
                      width: isCompleted ? 0 : 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        )
                      : Text(
                          number,
                          style: const TextStyle(
                            color: Color(0xFF8196B5),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: const Color(0xFFD8E1EF),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // KARTU INFORMASI TAHAP
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 13),
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: isCompleted
                      ? const Color(0xFFDCD1FF)
                      : const Color(0xFFEDF1F7),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.015),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // JUDUL DI KIRI, TANGGAL DAN JAM DI UJUNG KANAN
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: isCompleted ? teks : abu,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$date, $time',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color(0xFF9AA8BD),
                          fontSize: 8,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),

                  // SUBJUDUL
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isCompleted ? teks : abu,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // DESKRIPSI
                  Text(
                    description,
                    style: TextStyle(
                      color: isCompleted
                          ? const Color(0xFF64748B)
                          : const Color(0xFF8B98AA),
                      fontSize: 10,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}