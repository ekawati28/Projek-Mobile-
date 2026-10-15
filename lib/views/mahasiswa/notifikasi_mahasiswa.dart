import 'package:flutter/material.dart';

class NotifikasiMahasiswa extends StatefulWidget {
  const NotifikasiMahasiswa({super.key});

  @override
  State<NotifikasiMahasiswa> createState() => _NotifikasiMahasiswaState();
}

class _NotifikasiMahasiswaState extends State<NotifikasiMahasiswa> {
  int _filterAktif = 0;

  final Color biru = const Color(0xFF2463FF);

  final List<Map<String, dynamic>> _notifikasi = [
    {
      'judul': 'Laporan Sedang Diproses',
      'pesan': 'Petugas teknisi sedang menangani permasalahan fasilitas.',
      'kode': '#CR-2026-0941',
      'waktu': '10 menit yang lalu',
      'ikon': Icons.build_outlined,
      'warna': const Color(0xFFF3DFFF),
      'warnaIkon': const Color(0xFFAD39E8),
      'dibaca': false,
      'lokasi': 'LAP RPL',
      'kategori': 'AC',
      'deskripsi':
          'AC di LAP RPL tidak menyala sejak pagi dan ruangan menjadi sangat panas saat praktikum berlangsung. Remote tidak merespons dan terdengar bunyi dari indoor unit.',
    },
    {
      'judul': 'Laporan Telah Diverifikasi',
      'pesan':
          'Laporan sarpras Anda di LAP RPL sudah diperiksa dan diverifikasi.',
      'kode': '#CR-2026-0941',
      'waktu': '30 menit yang lalu',
      'ikon': Icons.shield_outlined,
      'warna': const Color(0xFFFFF1BF),
      'warnaIkon': const Color(0xFFCF7900),
      'dibaca': false,
      'lokasi': 'LAP RPL',
      'kategori': 'AC',
      'deskripsi':
          'Laporan kerusakan AC telah diperiksa dan diverifikasi oleh administrator.',
    },
    {
      'judul': 'Laporan Berhasil Dikirim',
      'pesan': 'Laporan fasilitas berhasil dikirim.',
      'kode': '#CR-2026-0941',
      'waktu': '1 jam yang lalu',
      'ikon': Icons.send_outlined,
      'warna': const Color(0xFFDBEAFE),
      'warnaIkon': Color(0xFF2463FF),
      'dibaca': true,
      'lokasi': 'LAP RPL',
      'kategori': 'AC',
      'deskripsi':
          'Laporan kerusakan fasilitas berhasil dikirim dan menunggu verifikasi administrator.',
    },
    {
      'judul': 'Laporan Selesai',
      'pesan': 'Permasalahan fasilitas Lampu LED JT3 telah ditangani.',
      'kode': '#CR-2026-0892',
      'waktu': 'Kemarin, 14:20 WIT',
      'ikon': Icons.check_circle_outline,
      'warna': const Color(0xFFD1FAE5),
      'warnaIkon': Color(0xFF059669),
      'dibaca': true,
      'lokasi': 'JT3',
      'kategori': 'Lampu',
      'deskripsi':
          'Permasalahan lampu LED di JT3 telah ditangani. Lampu sudah dapat digunakan kembali.',
    },
    {
      'judul': 'Laporan Selesai',
      'pesan': 'Permasalahan keran air di Toilet Lantai 1 telah ditangani.',
      'kode': '#CR-2026-0814',
      'waktu': '15 Sep 2026, 11:30 WIT',
      'ikon': Icons.check_circle_outline,
      'warna': const Color(0xFFD1FAE5),
      'warnaIkon': Color(0xFF059669),
      'dibaca': true,
      'lokasi': 'Toilet Lantai 1',
      'kategori': 'Keran air',
      'deskripsi':
          'Permasalahan keran air di Toilet Lantai 1 telah ditangani dan fasilitas dapat digunakan kembali.',
    },
  ];

  List<Map<String, dynamic>> get _notifikasiTampil {
    if (_filterAktif == 1) {
      return _notifikasi.where((item) => item['dibaca'] == false).toList();
    }

    return _notifikasi;
  }

  int get _jumlahBelumDibaca {
    return _notifikasi.where((item) => item['dibaca'] == false).length;
  }

  void _bacaSemua() {
    setState(() {
      for (final item in _notifikasi) {
        item['dibaca'] = true;
      }
    });
  }

  void _bukaDetail(Map<String, dynamic> item) {
    setState(() {
      item['dibaca'] = true;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailLaporanPage(item: item),
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
              child: _notifikasiTampil.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada notifikasi belum dibaca.',
                        style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 13,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 2, 16, 16),
                      itemCount: _notifikasiTampil.length,
                      itemBuilder: (context, index) {
                        final item = _notifikasiTampil[index];
                        return _buatKartuNotifikasi(item);
                      },
                    ),
            ),
          ],
        ),
      ),

      // NAVIGASI BAWAH
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE9EDF4)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _itemNavigasi(
                  ikon: Icons.home_outlined,
                  judul: 'Beranda',
                  halaman: 0,
                ),
                _itemNavigasi(
                  ikon: Icons.history,
                  judul: 'Riwayat',
                  halaman: 1,
                ),
                _itemNavigasi(
                  ikon: Icons.add_circle,
                  judul: 'Buat Laporan',
                  halaman: 2,
                  utama: true,
                ),
                _itemNavigasi(
                  ikon: Icons.person_outline,
                  judul: 'Profil',
                  halaman: 3,
                ),
              ],
            ),
          ),
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

// HALAMAN DETAIL LAPORAN
class DetailLaporanPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const DetailLaporanPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    const biru = Color(0xFF2463FF);

    final String judul = item['judul'] ?? 'Detail Laporan';
    final String kode = item['kode'] ?? '-';
    final String pesan = item['pesan'] ?? '-';
    final String lokasi = item['lokasi'] ?? 'Fasilitas Kampus III';
    final String kategori = item['kategori'] ?? 'Fasilitas';
    final String deskripsi = item['deskripsi'] ?? pesan;

    final bool selesai = judul.toLowerCase().contains('selesai');
    final bool diproses = judul.toLowerCase().contains('diproses');
    final bool diverifikasi = judul.toLowerCase().contains('diverifikasi');
    final bool berhasilDikirim =
        judul.toLowerCase().contains('berhasil dikirim');

    final int tahap = selesai
        ? 3
        : diproses
            ? 2
            : diverifikasi
                ? 1
                : 0;

    final String status = selesai
        ? 'Selesai'
        : diproses
            ? 'Diproses'
            : diverifikasi
                ? 'Diverifikasi'
                : 'Diajukan';

    final Color warnaStatus = selesai
        ? const Color(0xFF059669)
        : diproses
            ? const Color(0xFFAD39E8)
            : diverifikasi
                ? const Color(0xFFCF7900)
                : biru;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER DETAIL
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF5F7FB),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detail Laporan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Text(
                          kode,
                          style: const TextStyle(
                            fontSize: 11,
                            color: biru,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: warnaStatus.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: warnaStatus,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFE9EDF4)),

            // KONTEN DETAIL BISA DI-SCROLL
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  // PROGRES PENANGANAN
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFD),
                      border: Border.all(
                        color: const Color(0xFFE1E7F0),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PROGRES PENANGANAN FASILITAS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF718096),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: List.generate(4, (index) {
                            const tahapNama = [
                              'Diajukan',
                              'Diverifikasi',
                              'Diproses',
                              'Selesai',
                            ];

                            final bool sudahLewat = index <= tahap;

                            return Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: sudahLewat
                                          ? warnaStatus
                                          : const Color(0xFFE1E7F0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: sudahLewat
                                              ? Colors.white
                                              : const Color(0xFF718096),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    tahapNama[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: sudahLewat
                                          ? warnaStatus
                                          : const Color(0xFF718096),
                                      fontWeight: sudahLewat
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    selesai
                        ? 'Permasalahan Fasilitas Selesai Ditangani'
                        : diproses
                            ? 'Laporan Sedang Diproses'
                            : diverifikasi
                                ? 'Laporan Telah Diverifikasi'
                                : berhasilDikirim
                                    ? 'Laporan Berhasil Dikirim'
                                    : 'Laporan Menunggu Penanganan',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _labelDetail(Icons.sell_outlined, kategori),
                      _labelDetail(Icons.location_on_outlined, lokasi),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // DESKRIPSI PERMASALAHAN
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFD),
                      border: Border.all(
                        color: const Color(0xFFE1E7F0),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Deskripsi Permasalahan:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          deskripsi,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            color: Color(0xFF526078),
                          ),
                        ),
                        const Divider(height: 24),
                        Text(
                          'Dilaporkan: ${item['waktu'] ?? '-'}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF718096),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Kode laporan: $kode',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Foto Bukti Kerusakan:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF374151),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // FOTO CONTOH, BUKAN FOTO ASLI DARI DATABASE
                  Container(
                    height: 135,
                    decoration: BoxDecoration(
                      color: const Color(0xFF202C42),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 38,
                          color: Colors.white70,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'FOTO BUKTI LAPORAN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Foto asli akan ditampilkan setelah terhubung ke data laporan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // STATUS TINDAK LANJUT
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F6FF),
                      border: Border.all(
                        color: const Color(0xFFCEE0FF),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: biru,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selesai
                                    ? 'Laporan telah selesai'
                                    : 'Status penanganan: $status',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xFF26334D),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                selesai
                                    ? 'Permasalahan dinyatakan selesai berdasarkan status laporan.'
                                    : 'Informasi petugas dan disposisi akan tersedia setelah data penugasan terhubung.',
                                style: const TextStyle(
                                  fontSize: 11,
                                  height: 1.5,
                                  color: Color(0xFF526078),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // TIMELINE MONITORING
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Timeline Monitoring'),
                            content: Text(
                              'Status laporan saat ini: $status.\n\n'
                              'Riwayat waktu perubahan status akan tersedia '
                              'setelah data laporan terhubung ke database.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Tutup'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.monitor_heart_outlined),
                      label: const Text('Lihat Timeline Monitoring'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: biru,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _labelDetail(IconData ikon, String teks) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ikon,
            size: 14,
            color: const Color(0xFF2463FF),
          ),
          const SizedBox(width: 5),
          Text(
            teks,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}
