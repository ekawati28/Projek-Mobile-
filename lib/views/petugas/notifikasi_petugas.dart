import 'package:flutter/material.dart';
import 'detail_tugas_petugas.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotifikasiPetugas(),
    ),
  );
}

const Color blue = Color(0xFF2563EB);
const Color dark = Color(0xFF0F172A);
const Color muted = Color(0xFF64748B);
const Color border = Color(0xFFE2E8F0);

class NotifikasiPetugas extends StatefulWidget {
  const NotifikasiPetugas({super.key});

  @override
  State<NotifikasiPetugas> createState() =>
      _NotifikasiPetugasState();
}

class _NotifikasiPetugasState extends State<NotifikasiPetugas> {
  int filterAktif = 0;

  final List<Map<String, dynamic>> notifikasi = [
    {
      'judul': 'Tugas Baru Diberikan',
      'pesan': 'Admin memberikan tugas penanganan laporan baru.',
      'id': '0941',
      'waktu': '12 menit yang lalu',
      'baca': false,
      'ikon': Icons.assignment_outlined,
      'warna': Color(0xFFDBEAFE),
      'warnaIkon': Color(0xFF2563EB),
    },
    {
      'judul': 'Tugas Perlu Ditindaklanjuti',
      'pesan': 'Terdapat laporan kerusakan fasilitas AC yang perlu ditindaklanjuti.',
      'id': '0941',
      'waktu': '40 menit yang lalu',
      'baca': false,
      'ikon': Icons.warning_amber_rounded,
      'warna': Color(0xFFFFE4E6),
      'warnaIkon': Color(0xFFDC2626),
    },
    {
      'judul': 'Pembaruan Laporan',
      'pesan': 'Terdapat perubahan informasi lokasi dan catatan laporan.',
      'id': '0892',
      'waktu': '2 jam yang lalu',
      'baca': true,
      'ikon': Icons.sync_rounded,
      'warna': Color(0xFFFFF3C4),
      'warnaIkon': Color(0xFFD97706),
    },
    {
      'judul': 'Konfirmasi Penanganan',
      'pesan': 'Informasi tindak lanjut penyelesaian laporan telah diperbarui.',
      'id': '0814',
      'waktu': 'Kemarin, 16:00 WIB',
      'baca': true,
      'ikon': Icons.check_circle_outline_rounded,
      'warna': Color(0xFFD1FAE5),
      'warnaIkon': Color(0xFF059669),
    },
  ];

  int get belumDibaca =>
      notifikasi.where((n) => n['baca'] == false).length;

  List<Map<String, dynamic>> get daftarTampil {
    if (filterAktif == 1) {
      return notifikasi.where((n) => n['baca'] == false).toList();
    }
    return notifikasi;
  }

  void bacaSemua() {
    setState(() {
      for (var item in notifikasi) {
        item['baca'] = true;
      }
    });
  }

  void bukaDetail(Map<String, dynamic> item) {
    setState(() {
      item['baca'] = true;
    });

    final tugas = <String, dynamic>{
      'id': '#CR-2026-${item['id']}',
      'prioritas': 'Normal',
      'status': 'Diajukan',
      'judul': item['judul'],
      'lokasi': 'Lokasi fasilitas',
      'lokasiKampus': 'Kampus',
      'kategori': 'Fasilitas',
      'tanggal': item['waktu'],
      'deskripsi': item['pesan'],
      'petugas': '-',
      'fotoLabel': item['judul'],
      'waktuFoto': item['waktu'],
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailTugasPetugas(tugas: tugas),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            header(),
            tabFilter(),
            const Divider(
              height: 1,
              color: border,
            ),
            Expanded(
              child: daftarNotifikasi(),
            ),
            bottomNav(),
          ],
        ),
      ),
    );
  }

  // HEADER
  Widget header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
              border: Border.all(color: border),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 17,
                color: Color(0xFF334155),
              ),
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifikasi Petugas',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.15,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Penugasan &\npembaruan penanganan sarpras',
                  style: TextStyle(
                    fontSize: 9.5,
                    height: 1.35,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 52,
            child: TextButton(
              onPressed: belumDibaca == 0 ? null : bacaSemua,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.done_all_rounded,
                    size: 12,
                  ),
                  Text(
                    'Baca\nSemua',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      height: 1.1,
                      fontWeight: FontWeight.w600,
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

  // TAB FILTER
  Widget tabFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
      child: Row(
        children: [
          tabItem(0, 'Semua', notifikasi.length),
          const SizedBox(width: 6),
          tabItem(1, 'Belum Dibaca', belumDibaca),
        ],
      ),
    );
  }

  Widget tabItem(int index, String label, int jumlah) {
    final aktif = filterAktif == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            filterAktif = index;
          });
        },
        child: Container(
          height: 25,
          decoration: BoxDecoration(
            color: aktif ? blue : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: aktif ? Colors.white : dark,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: aktif
                      ? Colors.white.withValues(alpha: 0.2)
                      : index == 1 && jumlah > 0
                          ? const Color(0xFFFFE4E6)
                          : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$jumlah',
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                    color: aktif
                        ? Colors.white
                        : index == 1 && jumlah > 0
                            ? const Color(0xFFDC2626)
                            : muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // DAFTAR NOTIFIKASI
  Widget daftarNotifikasi() {
    return Container(
      color: const Color(0xFFFAFCFF),
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          itemCount: daftarTampil.length,
          itemBuilder: (context, index) {
            return kartuNotifikasi(daftarTampil[index]);
          },
        ),
      ),
    );
  }

  // KARTU NOTIFIKASI
  Widget kartuNotifikasi(Map<String, dynamic> item) {
    final bool dibaca = item['baca'];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: dibaca ? Colors.white : const Color(0xFFF8FBFF),
        border: Border.all(
          color: dibaca
              ? const Color(0xFFE2E8F0)
              : const Color(0xFFBFDBFE),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: item['warna'],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item['ikon'],
              color: item['warnaIkon'],
              size: 15,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['judul'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: dark,
                        ),
                      ),
                    ),
                    if (!dibaca)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 3),

                Text(
                  item['pesan'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    height: 1.35,
                    color: muted,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        border: Border.all(
                          color: const Color(0xFFBFDBFE),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '#CR-2026-\n${item['id']}',
                        style: const TextStyle(
                          fontSize: 7.5,
                          height: 1.2,
                          color: blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        item['waktu'],
                        style: const TextStyle(
                          fontSize: 8,
                          color: muted,
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () => bukaDetail(item),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 24),
                        tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Detail Tugas',
                            style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 13,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // NAVIGASI BAWAH
  Widget bottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: border,
            width: 0.8,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              navItem(Icons.bar_chart_rounded, 'Dashboard', true),
              navItem(Icons.assignment_outlined, 'Tugas', false),
              navItem(Icons.history_rounded, 'Riwayat', false),
              navItem(Icons.person_outline_rounded, 'Profil', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(IconData icon, String label, bool aktif) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: aktif ? blue : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 8.5,
                color: aktif ? blue : const Color(0xFF94A3B8),
                fontWeight: aktif ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}