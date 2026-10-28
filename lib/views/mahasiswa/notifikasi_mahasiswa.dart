import 'package:flutter/material.dart';
import '../../services/notifikasi_service.dart';
import '../../models/laporan_model.dart';
import '../../services/laporan_service.dart';
import 'detail_laporan_page.dart';

class NotifikasiMahasiswa extends StatefulWidget {
  const NotifikasiMahasiswa({super.key});

  @override
  State<NotifikasiMahasiswa> createState() => _NotifikasiMahasiswaState();
}

class _NotifikasiMahasiswaState extends State<NotifikasiMahasiswa> {
  int _filterAktif = 0;

  final LaporanService laporanService = LaporanService();
  final Color biru = const Color(0xFF2463FF);

  
  final NotifikasiService notifikasiService = NotifikasiService();

  List<Map<String, dynamic>> _notifikasi = [];
  bool _memuat = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _muatNotifikasi();
  }

  Future<void> _muatNotifikasi() async {
    setState(() {
      _memuat = true;
      _error = null;
    });

    try {
      final data = await notifikasiService.getNotifikasi();

      if (!mounted) return;

      setState(() {
        _notifikasi = data.map((row) {
          final judul = row['judul']?.toString() ?? 'Notifikasi';
          final idLaporan = row['id_laporan'];
          final sudahDibaca = row['baca'] == true;

          final judulLower = judul.toLowerCase();

          final IconData ikon =
              judulLower.contains('selesai')
                  ? Icons.check_circle_outline
                  : judulLower.contains('proses')
                      ? Icons.build_outlined
                      : judulLower.contains('verifikasi')
                          ? Icons.shield_outlined
                          : Icons.notifications_outlined;

          final Color warna =
              judulLower.contains('selesai')
                  ? const Color(0xFFD1FAE5)
                  : judulLower.contains('proses')
                      ? const Color(0xFFF3DFFF)
                      : const Color(0xFFDBEAFE);

          final Color warnaIkon =
              judulLower.contains('selesai')
                  ? const Color(0xFF059669)
                  : judulLower.contains('proses')
                      ? const Color(0xFFAD39E8)
                      : const Color(0xFF2463FF);

          String waktu = '-';

          if (row['not_waktu_dibuat'] != null) {
            final tanggal = DateTime.tryParse(
              row['not_waktu_dibuat'].toString(),
            );

            if (tanggal != null) {
              final t = tanggal.toLocal();
              waktu =
                  '${t.day.toString().padLeft(2, '0')}/'
                  '${t.month.toString().padLeft(2, '0')}/'
                  '${t.year}, '
                  '${t.hour.toString().padLeft(2, '0')}:'
                  '${t.minute.toString().padLeft(2, '0')}';
            }
          }

          return <String, dynamic>{
            'id_notifikasi': row['id_notifikasi'],
            'id_laporan': idLaporan,
            'judul': judul,
            'pesan': row['pesan']?.toString() ?? '',
            'kode': idLaporan == null ? '-' : '#CR-$idLaporan',
            'waktu': waktu,
            'ikon': ikon,
            'warna': warna,
            'warnaIkon': warnaIkon,
            'dibaca': sudahDibaca,
            'lokasi': 'Laporan fasilitas',
            'kategori': 'Fasilitas',
            'deskripsi': row['pesan']?.toString() ?? '',
          };
        }).toList();

        _memuat = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _memuat = false;
      });
    }
  }

  List<Map<String, dynamic>> get _notifikasiTampil {
    if (_filterAktif == 1) {
      return _notifikasi.where((item) => item['dibaca'] == false).toList();
    }

    return _notifikasi;
  }

  int get _jumlahBelumDibaca {
    return _notifikasi.where((item) => item['dibaca'] == false).length;
  }
  
  Future<void> _bacaSemua() async {
    try {
      for (final item in _notifikasi) {
        if (item['dibaca'] == false &&
            item['id_notifikasi'] != null) {
          await notifikasiService.tandaiDibaca(
            (item['id_notifikasi'] as num).toInt(),
          );
        }
      }

      if (!mounted) return;

      await _muatNotifikasi();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menandai notifikasi sebagai dibaca.'),
        ),
      );
    }
  }
  
  
  Future<void> _bukaDetail(Map<String, dynamic> item) async {
    try {
      final idNotifikasi = item['id_notifikasi'];
      final idLaporan = item['id_laporan'];

      if (idLaporan == null) {
        throw Exception('ID laporan tidak ditemukan.');
      }

      // Tandai notifikasi sebagai dibaca.
      if (item['dibaca'] == false && idNotifikasi != null) {
        await notifikasiService.tandaiDibaca(
          (idNotifikasi as num).toInt(),
        );
      }

      if (!mounted) return;

      setState(() {
        item['dibaca'] = true;
      });

      // Ambil data laporan terbaru dari Supabase.
      final detail = await laporanService.getDetailLaporan(
        (idLaporan as num).toInt(),
      );

      if (!mounted) return;

      final laporan = LaporanModel(
        idLaporan: (detail['id_laporan'] as num).toInt(),
        lokasi: detail['lokasi']?.toString() ?? '-',
        deskripsi: detail['lpr_deskripsi']?.toString() ?? '-',
        status: detail['status']?.toString() ?? 'Diajukan',
        waktuDibuat: DateTime.parse(
          detail['lpr_waktu_dibuat'].toString(),
        ),
        namaPelapor: detail['nama_pelapor']?.toString()
            ?? 'Tidak diketahui',
      );

      // Buka halaman detail laporan asli.
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailLaporanPage(
            laporan: laporan,
          ),
        ),
      );

      if (mounted) {
        await _muatNotifikasi();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka detail laporan: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER NOTIFIKASI
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FB),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE1E7F0),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF526078),
                        size: 21,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifikasi Mahasiswa',
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.1,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Pembaruan status laporan fasilitas Anda',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _bacaSemua,
                    child: Text(
                      'Baca\nSemua',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: biru,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFF0F2F6)),

            // FILTER NOTIFIKASI
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 11,
              ),
              child: Row(
                children: [
                  _buatFilter(
                    judul: 'Semua',
                    jumlah: _notifikasi.length,
                    indeks: 0,
                  ),
                  const SizedBox(width: 8),
                  _buatFilter(
                    judul: 'Belum Dibaca',
                    jumlah: _jumlahBelumDibaca,
                    indeks: 1,
                  ),
                ],
              ),
            ),

            // DAFTAR NOTIFIKASI           
            Expanded(
              child: _memuat
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Gagal memuat notifikasi.'),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: _muatNotifikasi,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _notifikasiTampil.isEmpty
                          ? const Center(
                              child: Text(
                                'Tidak ada notifikasi.',
                                style: TextStyle(
                                  color: Color(0xFF718096),
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _muatNotifikasi,
                              child: ListView.builder(
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                  16, 2, 16, 16,
                                ),
                                itemCount: _notifikasiTampil.length,
                                itemBuilder: (context, index) {
                                  final item = _notifikasiTampil[index];
                                  return _buatKartuNotifikasi(item);
                                },
                              ),
                            ),
            )
          ],
        ),
      ),
    );
  }

  // TOMBOL FILTER
  Widget _buatFilter({
    required String judul,
    required int jumlah,
    required int indeks,
  }) {
    final bool aktif = _filterAktif == indeks;

    return InkWell(
      onTap: () {
        setState(() {
          _filterAktif = indeks;
        });
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: aktif ? biru : const Color(0xFFF0F3F8),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              judul,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: aktif ? Colors.white : const Color(0xFF526078),
              ),
            ),
            const SizedBox(width: 7),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color:
                    aktif ? const Color(0xFF1850D8) : const Color(0xFFFF354B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$jumlah',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // KARTU NOTIFIKASI
  Widget _buatKartuNotifikasi(Map<String, dynamic> item) {
    final bool belumDibaca = item['dibaca'] == false;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: belumDibaca ? const Color(0xFFF5FAFF) : Colors.white,
        border: Border.all(
          color: const Color(0xFFD7E6FF),
        ),
        borderRadius: BorderRadius.circular(13),
      ),
      child: InkWell(
        onTap: () => _bukaDetail(item),
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: item['warna'],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item['ikon'],
                      color: item['warnaIkon'],
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['judul'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF26334D),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item['pesan'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.4,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (belumDibaca) ...[
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: biru,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFD3E3FF),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      item['kode'],
                      style: TextStyle(
                        fontSize: 8,
                        color: biru,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Icon(
                    Icons.access_time,
                    size: 11,
                    color: Color(0xFF9AA8BC),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      item['waktu'],
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _bukaDetail(item),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Detail\nLaporan',
                          style: TextStyle(
                            color: biru,
                            fontSize: 10,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          Icons.chevron_right,
                          size: 17,
                          color: biru,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NAVIGASI BAWAH
  Widget _itemNavigasi({
    required IconData ikon,
    required String judul,
    required int halaman,
    bool utama = false,
  }) {
    return InkWell(
      onTap: () {
        if (halaman == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Halaman $judul belum dihubungkan.',
              ),
            ),
          );
        }
      },
      child: SizedBox(
        width: utama ? 82 : 63,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (utama)
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: biru,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: biru.withValues(alpha: 0.25),
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  ikon,
                  color: Colors.white,
                  size: 27,
                ),
              )
            else
              Icon(
                ikon,
                color: const Color(0xFF9AA8BC),
                size: 21,
              ),
            const SizedBox(height: 2),
            Text(
              judul,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontSize: 10,
                color: utama ? biru : const Color(0xFF9AA8BC),
                fontWeight: utama ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



  