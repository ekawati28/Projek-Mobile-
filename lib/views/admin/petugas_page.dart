
import 'dart:ui';

import 'package:flutter/material.dart';

const Color biru = Color(0xFF1743D1);
const Color biruMuda = Color(0xFFE1EDFF);
const Color latar = Color(0xFFF7F9FC);
const Color garis = Color(0xFFDCE5F1);
const Color teks = Color(0xFF14213D);
const Color abu = Color(0xFF71819D);

class PetugasPage extends StatefulWidget {
  const PetugasPage({super.key});

  @override
  State<PetugasPage> createState() => _PetugasPageState();
}

class _PetugasPageState extends State<PetugasPage> {
  final TextEditingController pencarianController =
      TextEditingController();

  final List<Map<String, dynamic>> daftarPetugas = [
    {
      'nama': 'Ahmad',
      'inisial': 'AH',
      'jabatan': 'Teknisi Fasilitas',
      'status': 'Aktif',
      'tugas': 1,
      'keahlian': 'Kelistrikan, Stopkontak',
      'kontak': '0812-3344-5566',
      'beban': '1 Laporan Sedang Ditangani',
    },
    {
      'nama': 'Budi',
      'inisial': 'BD',
      'jabatan': 'Teknisi Fasilitas',
      'status': 'Aktif',
      'tugas': 0,
      'keahlian': 'AC & Pendingin',
      'kontak': '0852-7788-9900',
      'beban': 'Belum Ada Laporan',
    },
    {
      'nama': 'Citra',
      'inisial': 'CT',
      'jabatan': 'Teknisi Fasilitas',
      'status': 'Aktif',
      'tugas': 2,
      'keahlian': 'Sarana Ruang Kuliah',
      'kontak': '0821-6677-8899',
      'beban': '2 Laporan Sedang Ditangani',
    },
    {
      'nama': 'Deni',
      'inisial': 'DN',
      'jabatan': 'Teknisi Fasilitas',
      'status': 'Aktif',
      'tugas': 1,
      'keahlian': 'Sanitasi, Toilet & Air',
      'kontak': '0823-1122-3344',
      'beban': '1 Laporan Sedang Ditangani',
    },
  ];

  List<Map<String, dynamic>> get petugasTerfilter {
    final kata = pencarianController.text.trim().toLowerCase();

    return daftarPetugas.where((petugas) {
      return petugas['nama']
              .toString()
              .toLowerCase()
              .contains(kata) ||
          petugas['keahlian']
              .toString()
              .toLowerCase()
              .contains(kata);
    }).toList();
  }

  @override
  void dispose() {
    pencarianController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header(),

            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFF0F3F8),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  23, 14, 23, 16,
                ),
                children: [
                  _kolomPencarian(),
                  const SizedBox(height: 14),
                  _bannerPenanganan(),
                  const SizedBox(height: 14),

                  if (petugasTerfilter.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'Petugas tidak ditemukan.',
                          style: TextStyle(color: abu),
                        ),
                      ),
                    )
                  else
                    ...petugasTerfilter.map(
                      (petugas) => Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: _kartuPetugas(petugas),
                      ),
                    ),
                ],
              ),
            ),

            _navigasiBawah(),
          ],
        ),
      ),
    );
  }

  // HEADER DAFTAR PETUGAS
  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(23, 17, 23, 17),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Daftar Petugas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: teks,
              ),
            ),
          ),
          const SizedBox(height: 1),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(
                    top: 2, right: 13,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: latar,
                    border: Border.all(color: garis),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: Color(0xFF40516D),
                  ),
                ),
              ),

              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    'Staf Teknisi Sarpras\n\nKampus III',
                    style: TextStyle(
                      color: Color(0xFF506B91),
                      fontSize: 14,
                      height: 1.1,
                    ),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11, vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F6FF),
                  border: Border.all(
                    color: const Color(0xFFBBD5FF),
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.people_alt_outlined,
                      size: 17,
                      color: biru,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${daftarPetugas.length}',
                          style: const TextStyle(
                            color: biru,
                            fontSize: 12,
                            height: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Petugas',
                          style: TextStyle(
                            color: biru,
                            fontSize: 12,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // PENCARIAN PETUGAS
  Widget _kolomPencarian() {
    return Container(
      height: 41,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: latar,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: garis),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Color(0xFF8CA0BD),
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: pencarianController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(
                fontSize: 13,
                color: teks,
              ),
              decoration: const InputDecoration(
                hintText: 'Cari nama, keahlian teknisi...',
                hintStyle: TextStyle(
                  color: Color(0xFF929DB0),
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BANNER BIRU
  Widget _bannerPenanganan() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2050ED),
            Color(0xFF1939B9),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: biru.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'UNIT PENANGANAN\nCEPAT',
                  style: TextStyle(
                    color: Color(0xFFD9E5FF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.35,
                  ),
                ),
              ),
              Container(
                width: 78,
                padding: const EdgeInsets.symmetric(
                  horizontal: 9, vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C58B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Siaga\nPenuh',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'Teknisi Lapangan Siaga Pemeliharaan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Pilih teknisi untuk melihat profil keahlian, '
            'nomor kontak darurat, dan beban tugas berjalan.',
            style: TextStyle(
              color: Color(0xFFDCE6FF),
              fontSize: 12,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  // KARTU PETUGAS: SELURUH KARTU BISA DIKLIK
  Widget _kartuPetugas(Map<String, dynamic> petugas) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _bukaDetail(petugas),
        borderRadius: BorderRadius.circular(17),
        child: Container(
          constraints: const BoxConstraints(minHeight: 96),
          padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFD),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: garis),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: biruMuda,
                  border: Border.all(
                    color: const Color(0xFFBBD5FF),
                  ),
                ),
                child: Center(
                  child: Text(
                    petugas['inisial'],
                    style: const TextStyle(
                      color: biru,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            petugas['nama'],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: teks,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8FFF6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF8CEBC9),
                            ),
                          ),
                          child: Text(
                            petugas['status'],
                            style: const TextStyle(
                              color: Color(0xFF009C70),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      petugas['jabatan'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: biru,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      petugas['keahlian'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: abu,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: garis),
                    ),
                    child: Text(
                      '${petugas['tugas']} Tugas',
                      style: const TextStyle(
                        color: Color(0xFF40516D),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Detail',
                        style: TextStyle(
                          color: biru,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Color(0xFF8CA0BD),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // POPUP PROFIL SESUAI PETUGAS YANG DIPILIH
  void _bukaDetail(Map<String, dynamic> petugas) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0x990D172D),
      builder: (dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  22, 22, 22, 21,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2160FF),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: biru.withValues(alpha: 0.18),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              petugas['inisial'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                petugas['nama'],
                                style: const TextStyle(
                                  color: teks,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                petugas['jabatan'],
                                style: const TextStyle(
                                  color: biru,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8FFF5),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF8CEBC9),
                                  ),
                                ),
                                child: Text(
                                  '• Status: ${petugas['status']}',
                                  style: const TextStyle(
                                    color: Color(0xFF009C70),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 5),

                        InkWell(
                          onTap: () =>
                              Navigator.pop(dialogContext),
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF0F4F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Color(0xFF657995),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 19),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F9FC),
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: garis),
                      ),
                      child: Column(
                        children: [
                          _barisInformasi(
                            ikon: Icons.handyman_outlined,
                            label: 'Bidang\nKeahlian:',
                            isi: petugas['keahlian'],
                          ),
                          const Divider(
                            height: 1,
                            color: Color(0xFFE6ECF4),
                          ),
                          _barisInformasi(
                            ikon: Icons.phone_outlined,
                            label: 'Kontak\nTelepon/WA:',
                            isi: petugas['kontak'],
                            warnaIsi: biru,
                            tebal: true,
                          ),
                          const Divider(
                            height: 1,
                            color: Color(0xFFE6ECF4),
                          ),
                          _barisInformasi(
                            ikon:
                                Icons.home_repair_service_outlined,
                            label: 'Beban\nPekerjaan:',
                            isi: petugas['beban'],
                            tebal: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 21),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFF0F4F9),
                                foregroundColor:
                                    const Color(0xFF354761),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(17),
                                ),
                              ),
                              child: const Text(
                                'Tutup',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                Navigator.pushNamed(
                                  context,
                                  '/laporan',
                                  arguments: petugas,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF1749F5),
                                foregroundColor: Colors.white,
                                elevation: 3,
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(17),
                                ),
                              ),
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Lihat Laporan',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // BARIS INFORMASI POPUP
  Widget _barisInformasi({
    required IconData ikon,
    required String label,
    required String isi,
    Color warnaIsi = teks,
    bool tebal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            ikon,
            size: 14,
            color: const Color(0xFF8DA0BE),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 91,
            child: Text(
              label,
              style: const TextStyle(
                color: abu,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              isi,
              style: TextStyle(
                color: warnaIsi,
                fontSize: 12,
                height: 1.5,
                fontWeight:
                    tebal ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NAVIGASI BAWAH
  Widget _navigasiBawah() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5EAF2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              _itemNavigasi(
                icon: Icons.bar_chart_outlined,
                label: 'Dashboard',
                aktif: false,
              ),
              _itemNavigasi(
                icon: Icons.description_outlined,
                label: 'Laporan',
                aktif: false,
              ),
              _itemNavigasi(
                icon: Icons.people_outline,
                label: 'Petugas',
                aktif: true,
              ),
              _itemNavigasi(
                icon: Icons.person_outline,
                label: 'Profil',
                aktif: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemNavigasi({
    required IconData icon,
    required String label,
    required bool aktif,
  }) {
    final Color warna =
        aktif ? biru : const Color(0xFF8DA0BE);

    return Expanded(
      child: InkWell(
        onTap: () {
          // Navigasi halaman lain belum dihubungkan.
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 23,
              color: warna,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: warna,
                fontSize: 12,
                fontWeight:
                    aktif ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}