
import 'package:flutter/material.dart';
import 'timeline_monitoring_page.dart';
import '../../models/laporan_model.dart';
import '../../services/laporan_service.dart';
import '../../services/foto_service.dart';


class DetailLaporanPage extends StatefulWidget {
  final LaporanModel laporan;

  const DetailLaporanPage({
    super.key,
    required this.laporan,
  });

  @override
  State<DetailLaporanPage> createState() =>
      _DetailLaporanPageState();
}

class _DetailLaporanPageState extends State<DetailLaporanPage> {
  final LaporanService laporanService = LaporanService();

  late Future<Map<String, dynamic>> detailFuture;
  late Future<Map<String, dynamic>?> penugasanFuture;

  @override
  void initState() {
    super.initState();

    detailFuture = laporanService.getDetailLaporan(
      widget.laporan.idLaporan,
    );

    penugasanFuture = laporanService.getPenugasan(
      widget.laporan.idLaporan,
    );
  }

  String formatTanggal(dynamic tanggal) {
    if (tanggal == null) return '-';
    final waktu = DateTime.tryParse(tanggal.toString());

    if (waktu == null) return '-';
    final lokal = waktu.toLocal();

    final hari = lokal.day.toString().padLeft(2, '0');
    final bulan = lokal.month.toString().padLeft(2, '0');
    final jam = lokal.hour.toString().padLeft(2, '0');
    final menit = lokal.minute.toString().padLeft(2, '0');

    return '$hari/$bulan/${lokal.year}, $jam:$menit';
  }

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
        title: Column(
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
              '#CR-${widget.laporan.idLaporan}',
              style: const TextStyle(
                color: biru,
                fontSize: 11,
              ),
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
            child: FutureBuilder<Map<String, dynamic>>(
              future: detailFuture,
              builder: (context, snapshot) {
                final status = snapshot.data?['status']?.toString()
                    ?? widget.laporan.status;

                return Text(
                  status,
                  style: const TextStyle(
                    color: Color(0xFFAD7400),
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      body: FutureBuilder<Map<String, dynamic>>(
        future: detailFuture,
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
                  'Gagal memuat detail laporan: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Data laporan tidak ditemukan.'),
            );
          }

          final detail = snapshot.data!;
          final status = detail['status']?.toString() ?? 'Diajukan';

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kartuProgres(status),
                const SizedBox(height: 20),

                Text(
                  (detail['judul']?.toString().trim().isNotEmpty ?? false)
                      ? detail['judul'].toString()
                      : detail['lpr_deskripsi']?.toString() ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: teks,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    _label(
                      Icons.sell_outlined,
                      detail['nama_kategori']?.toString() ??
                          'Kategori ${detail['id_kategori'] ?? '-'}',
                      true,
                    ),

                    const SizedBox(width: 8),
                    _label(
                      Icons.location_on_outlined,
                      detail['lokasi']?.toString() ?? '-',
                      false,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                _kartuDeskripsi(
                    detail['lpr_deskripsi']?.toString() ?? '-',
                    detail['lpr_waktu_dibuat'],
                    detail['nama_pelapor']?.toString() ?? '-',
                  ),
                const SizedBox(height: 20),

                // Bagian foto dan penugasan tetap seperti desain lama.
                // Foto belum dihubungkan ke Supabase Storage.
                const Text(
                  'Foto Bukti Kerusakan:',
                  style: TextStyle(
                    color: teks,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                
                FutureBuilder<String?>(
                  future: FotoService().getFotoUrlByLaporan(
                    widget.laporan.idLaporan,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                        width: double.infinity,
                        height: 160,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFD),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: garis),
                        ),
                        child: const CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Text('Gagal memuat foto laporan.');
                    }

                    final fotoUrl = snapshot.data;

                    if (fotoUrl == null || fotoUrl.isEmpty) {
                      return const Text('Belum ada foto laporan.');
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.network(
                        fotoUrl,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 160,
                            child: Center(
                              child: Text('Foto tidak dapat ditampilkan.'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),
                FutureBuilder<Map<String, dynamic>?>(
                  future: penugasanFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Text(
                        'Informasi penugasan belum dapat dimuat.',
                      );
                    }

                    return _kartuPenugasan(snapshot.data);
                  },
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimelineMonitoringPage(
                            idLaporan: widget.laporan.idLaporan,
                          ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _kartuProgres(String status) {
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

              final tahapSekarang = [
                'Diajukan',
                'Diverifikasi',
                'Diproses',
                'Selesai',
              ].indexWhere(
                (item) => item.toLowerCase() == status.trim().toLowerCase(),
              );

              final tahapAktif = tahapSekarang < 0 ? 0 : tahapSekarang;
              final aktif = tahap <= tahapAktif;

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

  Widget _kartuDeskripsi(
    String deskripsi,
    dynamic tanggal,
    String namaPelapor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        border: Border.all(color: garis),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
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
            deskripsi,
            style: const TextStyle(
              color: Color(0xFF52647E),
              fontSize: 11,
              height: 1.6,
            ),
          ),
          SizedBox(height: 10),
          Divider(color: garis, height: 1),

          SizedBox(height: 8),
          Text(
            'Dilaporkan: ${formatTanggal(tanggal)}\n'
            'Pelapor: ${namaPelapor}',
            style: const TextStyle(
              color: Color(0xFF8A9BB3),
              fontSize: 9,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuPenugasan(Map<String, dynamic>? penugasan) {
    final sudahDitugaskan = penugasan != null;

    final namaPetugas =
        penugasan?['nama_petugas']?.toString() ?? 'Petugas';
    
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sudahDitugaskan ? namaPetugas : 'Belum ditugaskan',
                  style: TextStyle(
                    color: teks,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  sudahDitugaskan
                      ? 'Ditugaskan pada ${formatTanggal(penugasan['waktu_penugasan'])}'
                      : 'Menunggu Disposisi Administrator',
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
              color: sudahDitugaskan
                ? const Color(0xFFD1FAE5)
                : const Color(0xFFFFF2C9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              sudahDitugaskan
                  ? 'Ditugaskan'
                  : 'Menunggu\nPenugasan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: sudahDitugaskan
                    ? const Color(0xFF059669)
                    : const Color(0xFFAD7400),
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}