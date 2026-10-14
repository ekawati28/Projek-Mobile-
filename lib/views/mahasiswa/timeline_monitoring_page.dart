
import 'package:flutter/material.dart';

class TimelineMonitoringPage extends StatelessWidget {
  const TimelineMonitoringPage({super.key});

  static const Color biru = Color(0xFF315B9D);
  static const Color teks = Color(0xFF273449);
  static const Color abu = Color(0xFF718096);
  static const Color garis = Color(0xFFE1E8F2);
  static const Color latar = Color(0xFFF7F9FC);
  static const Color hijau = Color(0xFF00BF8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
                    child: const Text(
                      '#CR-2026-\n0941',
                      style: TextStyle(
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
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AC di LAP RPL Bermasalah',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: teks,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Kampus III (Jati) • LAP RPL',
                                  style: TextStyle(
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
                              color: const Color(0xFFFFF3CD),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Diajukan',
                              style: TextStyle(
                                color: Color(0xFF9A6700),
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // TAHAP 1
                    const TimelineTile(
                      number: '1',
                      title: 'Diajukan',
                      subtitle: 'Laporan Dikirim Mahasiswa',
                      description:
                          'Laporan telah dikirim oleh mahasiswa '
                          '(Budi Santoso) dan masuk ke antrean sistem.',
                      date: '19 Sep 2026',
                      time: '08:32 WIT',
                      isCompleted: true,
                      isLast: false,
                    ),

                    // TAHAP 2
                    const TimelineTile(
                      number: '2',
                      title: 'Diverifikasi',
                      subtitle: 'Diperiksa Administrator',
                      description:
                          'Laporan telah diperiksa Administrator Biro '
                          'Sarana Prasarana. Keluhan AC di LAP RPL '
                          'dinyatakan valid dan menunggu pemilihan teknisi.',
                      date: '19 Sep 2026',
                      time: '09:15 WIT',
                      isCompleted: false,
                      isLast: false,
                    ),

                    // TAHAP 3
                    const TimelineTile(
                      number: '3',
                      title: 'Diproses',
                      subtitle: 'Sedang Ditangani Petugas',
                      description:
                          'Laporan sedang ditangani oleh petugas (Budi). '
                          'Sedang dilakukan perbaikan AC di lokasi LAP RPL.',
                      date: '19 Sep 2026',
                      time: '10:00 WIT',
                      isCompleted: false,
                      isLast: false,
                    ),

                    // TAHAP 4
                    const TimelineTile(
                      number: '4',
                      title: 'Selesai',
                      subtitle: 'Permasalahan Telah Ditangani',
                      description:
                          'Kapasitor 1.5 PK telah diganti dan freon '
                          'R32 diisi ulang. Uji fungsi pendinginan '
                          'stabil pada suhu 20°C.',
                      date: '19 Sep 2026',
                      time: '11:30 WIT',
                      isCompleted: false,
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
    const Color teks = TimelineMonitoringPage.teks;
    const Color abu = TimelineMonitoringPage.abu;

    final Color warnaIkon = isCompleted
        ? TimelineMonitoringPage.hijau
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