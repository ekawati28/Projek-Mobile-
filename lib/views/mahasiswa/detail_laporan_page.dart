
import 'package:flutter/material.dart';
import 'timeline_monitoring_page.dart';

class DetailLaporanPage extends StatelessWidget {
  const DetailLaporanPage({super.key});

  static const Color biru = Color(0xFF2160FF);
  static const Color teks = Color(0xFF263650);
  static const Color abu = Color(0xFF71839F);
  static const Color garis = Color(0xFFDCE5F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: teks),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Laporan',
              style: TextStyle(
                color: teks,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '#CR-2026-0941',
              style: TextStyle(color: biru, fontSize: 11),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2C9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Diajukan',
              style: TextStyle(
                color: Color(0xFFAD7400),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _kartuProgres(),
            const SizedBox(height: 20),

            const Text(
              'AC di LAP RPL Bermasalah',
              style: TextStyle(
                color: teks,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                _label(Icons.sell_outlined, 'AC', true),
                const SizedBox(width: 8),
                _label(Icons.location_on_outlined, 'LAP RPL', false),
              ],
            ),
            const SizedBox(height: 14),

            _kartuDeskripsi(),
            const SizedBox(height: 20),

            const Text(
              'Foto Bukti Kerusakan:',
              style: TextStyle(
                color: teks,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              height: 125,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2B42),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    color: Color(0xFFB9C8DE),
                    size: 42,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'FOTO BUKTI: AC LAP RPL',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Kampus II Unikhar • Terverifikasi oleh Biro\nSarpras',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB9C8DE),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _kartuPenugasan(),
            const SizedBox(height: 20),

            // TOMBOL MENUJU HALAMAN TIMELINE MONITORING
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const TimelineMonitoringPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.monitor_heart_outlined,
                  size: 18,
                ),
                label: const Text(
                  'Lihat Timeline Monitoring',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: biru,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kartuProgres() {
    const tahapan = [
      'Diajukan',
      'Diverifikasi',
      'Diproses',
      'Selesai',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        border: Border.all(color: garis),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PROGRES PENANGANAN FASILITAS',
            style: TextStyle(
              color: abu,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(7, (index) {
              if (index.isOdd) {
                return Expanded(
                  child: Container(
                    height: 2,
                    color: garis,
                    margin: const EdgeInsets.only(bottom: 22),
                  ),
                );
              }

              final tahap = index ~/ 2;
              final aktif = tahap == 0;

              return Column(
                children: [
                  Container(
                    width: 27,
                    height: 27,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: aktif
                          ? const Color(0xFF9817F5)
                          : const Color(0xFFE5EAF2),
                      shape: BoxShape.circle,
                      border: aktif
                          ? Border.all(
                              color: const Color(0xFFF0D9FF),
                              width: 3,
                            )
                          : null,
                    ),
                    child: Text(
                      '${tahap + 1}',
                      style: TextStyle(
                        color: aktif ? Colors.white : abu,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tahapan[tahap],
                    style: TextStyle(
                      color: aktif
                          ? const Color(0xFF9817F5)
                          : abu,
                      fontSize: 8,
                      fontWeight: aktif
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _label(IconData ikon, String tulisan, bool aktif) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: aktif
            ? const Color(0xFFEAF2FF)
            : const Color(0xFFF3F5F8),
        border: Border.all(
          color: aktif
              ? const Color(0xFFBBD3FF)
              : garis,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ikon,
            color: aktif
                ? biru
                : const Color(0xFFFF6262),
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            tulisan,
            style: const TextStyle(
              color: teks,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuDeskripsi() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        border: Border.all(color: garis),
        borderRadius: BorderRadius.circular(13),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deskripsi Permasalahan:',
            style: TextStyle(
              color: teks,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'AC di LAP RPL tidak menyala sejak pagi dan ruangan '
            'menjadi sangat panas saat praktikum berlangsung. '
            'Remote tidak merespons dan terdengar bunyi dengung '
            'dari indoor unit.',
            style: TextStyle(
              color: Color(0xFF52647E),
              fontSize: 11,
              height: 1.6,
            ),
          ),
          SizedBox(height: 10),
          Divider(color: garis, height: 1),
          SizedBox(height: 8),
          Text(
            'Dilaporkan: 19 Sep 2026, Pelapor: Budi Santoso\n'
            '08:32 WIT',
            style: TextStyle(
              color: Color(0xFF8A9BB3),
              fontSize: 9,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuPenugasan() {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5FF),
        border: Border.all(
          color: const Color(0xFFBBD4FF),
        ),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: biru,
              shape: BoxShape.circle,
            ),
            child: const Text(
              'SP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 9),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Belum ditugaskan',
                  style: TextStyle(
                    color: teks,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Menunggu Disposisi Administrator',
                  style: TextStyle(
                    color: biru,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2C9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Menunggu\nPenugasan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFAD7400),
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}