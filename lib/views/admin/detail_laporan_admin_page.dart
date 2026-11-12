
import 'package:flutter/material.dart';
import '../../services/admin/admin_laporan_service.dart';
import '../../services/admin/admin_petugas_service.dart';

class DetailLaporanAdminPage extends StatefulWidget {
  final Map<String, dynamic> laporan;

  const DetailLaporanAdminPage({
    super.key,
    required this.laporan,
  });

  @override
  State<DetailLaporanAdminPage> createState() =>
      _DetailLaporanAdminPageState();
}

class _DetailLaporanAdminPageState
    extends State<DetailLaporanAdminPage> {
  final AdminLaporanService _service = AdminLaporanService();

  final AdminPetugasService _petugasService = AdminPetugasService();

  Map<String, dynamic>? _petugasDitugaskan;

  bool _isLoadingPetugas = true;
  bool _isMenyimpanPenugasan = false;

  late String _status;

  bool _isLoading = false;
  bool _statusBerubah = false;

  List<Map<String, dynamic>> _daftarFoto = [];

  bool _isLoadingFoto = true;
  String? _errorFoto;

  @override
  void initState() {
    super.initState();

    _status = widget.laporan['status']?.toString() ?? 'Diajukan';

    _muatFoto();
    _muatPetugasDitugaskan();
  }

  // Memuat petugas yang sudah ditugaskan.
  Future<void> _muatPetugasDitugaskan() async {
    try {
      final idLaporan =
          int.parse(widget.laporan['id_laporan'].toString());

      final hasil = await _petugasService
          .getPetugasDitugaskan(idLaporan);

      if (!mounted) return;

      setState(() {
        _petugasDitugaskan = hasil;
        _isLoadingPetugas = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingPetugas = false;
      });

      debugPrint('Gagal memuat petugas: $e');
    }
  }

  Future<void> _tampilkanDialogPenugasan() async {
    try {
      final daftarPetugas =
          await _petugasService.getDaftarPetugas();

      if (!mounted) return;

      if (daftarPetugas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Belum ada akun petugas terdaftar.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      Map<String, dynamic>? petugasTerpilih;

      // Pop-up pemilihan petugas.
      petugasTerpilih =
          await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (dialogContext) {
          Map<String, dynamic>? pilihan =
              _petugasDitugaskan;

          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text(
                  'Pilih Petugas Teknisi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: daftarPetugas.isEmpty
                      ? const Text('Belum ada petugas.')
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: daftarPetugas.length,
                          separatorBuilder: (_, __) =>
                              const Divider(),
                          itemBuilder: (context, index) {
                            final petugas =
                                daftarPetugas[index];

                            final terpilih =
                                pilihan?['id_pengguna'] ==
                                petugas['id_pengguna'];

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor:
                                    const Color(0xFFE5EEFF),
                                child: Text(
                                  petugas['nama_pengguna']
                                      .toString()
                                      .isNotEmpty
                                      ? petugas['nama_pengguna']
                                          .toString()[0]
                                          .toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: Color(0xFF1749E8),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                petugas['nama_pengguna']
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${petugas['jabatan']} • ${petugas['keahlian']}',
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                              trailing: Radio<dynamic>(
                                value: petugas['id_pengguna'],
                                groupValue:
                                    pilihan?['id_pengguna'],
                                onChanged: (_) {
                                  setDialogState(() {
                                    pilihan = petugas;
                                  });
                                },
                              ),
                              onTap: () {
                                setDialogState(() {
                                  pilihan = petugas;
                                });
                              },
                            );
                          },
                        ),
                ),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(dialogContext),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: pilihan == null
                        ? null
                        : () {
                            Navigator.pop(
                              dialogContext,
                              pilihan,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF1749E8),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Pilih Petugas'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (petugasTerpilih == null || !mounted) return;

      // Konfirmasi sebelum menyimpan.
      final konfirmasi = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Konfirmasi Penugasan'),
          content: Text(
            'Apakah kamu yakin ingin menugaskan '
            '${petugasTerpilih!['nama_pengguna']} '
            'untuk menangani laporan ini?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1749E8),
                foregroundColor: Colors.white,
              ),
              child: const Text('Konfirmasi'),
            ),
          ],
        ),
      );

      if (konfirmasi != true || !mounted) return;

      setState(() {
        _isMenyimpanPenugasan = true;
      });

      // Simpan penugasan ke Supabase.
      await _petugasService.tugaskanPetugas(
        idLaporan: int.parse(
          widget.laporan['id_laporan'].toString(),
        ),
        idPetugas: (petugasTerpilih['id_pengguna'] as num)
            .toInt(),
      );

      if (!mounted) return;

      setState(() {
        _petugasDitugaskan = petugasTerpilih;
        _isMenyimpanPenugasan = false;
        _statusBerubah = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Petugas berhasil ditugaskan.',
          ),
          backgroundColor: Color(0xFF059669),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isMenyimpanPenugasan = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menugaskan petugas: $e'),
          backgroundColor: Colors.red,
        ),
      );

      debugPrint('Kesalahan penugasan: $e');
    }
  }


  String? get _statusBerikutnya {
    final index =
        AdminLaporanService.urutanStatus.indexOf(_status);

    if (index < 0 ||
        index >= AdminLaporanService.urutanStatus.length - 1) {
      return null;
    }

    return AdminLaporanService.urutanStatus[index + 1];
  }

  // ==========================================
  // MEMUAT FOTO BUKTI LAPORAN
  // ==========================================

  Future<void> _muatFoto() async {
    try {
      final idLaporan =
          int.parse(widget.laporan['id_laporan'].toString());

      final hasil =
          await _service.getFotoLaporan(idLaporan);

      if (!mounted) return;

      setState(() {
        _daftarFoto = hasil;
        _isLoadingFoto = false;
        _errorFoto = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingFoto = false;
        _errorFoto = e.toString();
      });

      debugPrint('Gagal memuat foto laporan: $e');
    }
  }

  // ==========================================
  // MENGUBAH STATUS LAPORAN
  // ==========================================

  Future<void> _ubahStatus() async {
    final berikutnya = _statusBerikutnya;

    if (berikutnya == null) return;

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Verifikasi'),
        content: Text(
          'Apakah kamu yakin ingin mengubah status laporan menjadi $berikutnya?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Lanjutkan'),
          ),
        ],
      ),
    );

    if (konfirmasi != true || !mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final idLaporan =
          int.parse(widget.laporan['id_laporan'].toString());

      final hasil = await _service.ubahStatusLaporan(
        idLaporan: idLaporan,
        statusBaru: berikutnya,
      );

      if (!mounted) return;

      setState(() {
        _status = hasil['status'].toString();
        _isLoading = false;
        _statusBerubah = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Laporan berhasil diverifikasi! Silakan tugaskan petugas.',
          ),
          backgroundColor: Color(0xFF059669),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengubah status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ==========================================
  // WARNA STATUS
  // ==========================================

  Color get _warnaStatus {
    switch (_status) {
      case 'Diajukan':
        return const Color(0xFFFFF2CC);

      case 'Diverifikasi':
        return const Color(0xFFDBEAFE);

      case 'Diproses':
        return const Color(0xFFF3E8FF);

      case 'Selesai':
        return const Color(0xFFDCFCE7);

      default:
        return const Color(0xFFE2E8F0);
    }
  }

  Color get _warnaTeksStatus {
    switch (_status) {
      case 'Diajukan':
        return const Color(0xFFB45309);

      case 'Diverifikasi':
        return const Color(0xFF2563EB);

      case 'Diproses':
        return const Color(0xFF9333EA);

      case 'Selesai':
        return const Color(0xFF15803D);

      default:
        return const Color(0xFF64748B);
    }
  }

  // ==========================================
  // TAMPILAN UTAMA
  // ==========================================
  String _ambilTeks(List<String> keys) {
    for (final key in keys) {
      final value = widget.laporan[key];

      if (value != null) {
        final teks = value.toString().trim();

        if (teks.isNotEmpty && teks != 'null' && teks != '-') {
          return teks;
        }
      }
    }

    return '-';
  }

  @override
  Widget build(BuildContext context) {
    
    final laporan = widget.laporan;

    // Judul laporan.
    final judul = _ambilTeks([
      'judul',
      'title',
      'nama_laporan',
    ]);

    // Nama mahasiswa.
    final pelapor = _ambilTeks([
      'nama_pelapor',
      'pelapor',
      'nama_pengguna',
    ]);

    // Email mahasiswa.
    final email = _ambilTeks([
      'email',
    ]);

    // Informasi laporan.
    final lokasi = _ambilTeks(['lokasi']);
    final kategori = _ambilTeks(['kategori']);
    final tanggal = _ambilTeks(['tanggal']);

    final deskripsi = _ambilTeks([
      'deskripsi',
      'lpr_deskripsi',
    ]);

    final id = _ambilTeks(['id']).startsWith('#CR-')
        ? _ambilTeks(['id'])
        : '#CR-${laporan['id_laporan'] ?? '-'}';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      // ======================================
      // APP BAR
      // ======================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 65,
        leadingWidth: 48,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, _statusBerubah);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF334155),
          ),
        ),
        title: const Text(
          'Detail Verifikasi Laporan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: _warnaStatus,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _status,
                style: TextStyle(
                  color: _warnaTeksStatus,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      // ======================================
      // BODY
      // ======================================

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            color: Colors.white,
            child: Text(
              id,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2563EB),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // DATA MAHASISWA PELAPOR

                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DATA MAHASISWA PELAPOR',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 17,
                              color: Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                pelapor,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 7),

                        Row(
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              size: 15,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const Divider(
                          height: 18,
                          color: Color(0xFFE2E8F0),
                        ),

                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Mahasiswa Kampus III Unkhair',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.verified,
                              size: 13,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Akun Terverifikasi',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF059669),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // JUDUL LAPORAN

                  Text(
                    judul,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // KATEGORI DAN LOKASI

                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: [
                      _infoChip(
                        Icons.sell_outlined,
                        'Kategori: $kategori',
                        const Color(0xFF2563EB),
                        const Color(0xFFEFF6FF),
                      ),

                      _infoChip(
                        Icons.location_on_outlined,
                        lokasi,
                        const Color(0xFFEF4444),
                        const Color(0xFFF1F5F9),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  _infoChip(
                    Icons.calendar_today_outlined,
                    tanggal,
                    const Color(0xFF64748B),
                    const Color(0xFFF1F5F9),
                  ),

                  const SizedBox(height: 10),

                  // DESKRIPSI LAPORAN

                  _card(
                    child: Text(
                      deskripsi,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.7,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // FOTO BUKTI LAPORAN

                  const Text(
                    'Foto Bukti Lampiran:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),

                  const SizedBox(height: 9),

                  if (_isLoadingFoto)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: CircularProgressIndicator(
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    )

                  else if (_errorFoto != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Text(
                        'Gagal memuat foto bukti laporan:\n$_errorFoto',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    )

                  else if (_daftarFoto.isEmpty)
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          'Belum ada foto bukti laporan.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )

                  else
                    Column(
                      children: _daftarFoto.map((foto) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              foto['url_foto'].toString(),
                              width: double.infinity,
                              fit: BoxFit.contain,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) {
                                  return child;
                                }

                                return Container(
                                  height: 180,
                                  color: const Color(0xFFE2E8F0),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (
                                context,
                                error,
                                stackTrace,
                              ) {
                                return Container(
                                  height: 140,
                                  color: const Color(0xFFFEE2E2),
                                  child: const Center(
                                    child: Text(
                                      'Foto gagal ditampilkan.',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 15),

                  // STATUS DAN PETUGAS PENANGGUNG JAWAB

                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person_pin_outlined,
                              size: 17,
                              color: Color(0xFF2563EB),
                            ),

                            const SizedBox(width: 7),

                            const Expanded(
                              child: Text(
                                'Status & Petugas Penanggung Jawab',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),

                            _statusBadge(),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Status Laporan:',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),

                                  Text(
                                    _status,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
                                ],
                              ),

                              const Divider(
                                height: 20,
                                color: Color(0xFFE2E8F0),
                              ),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Petugas Teknisi:',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),

                                  if (_isLoadingPetugas)
                                    const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  else
                                    Flexible(
                                      child: Text(
                                        _petugasDitugaskan?['nama_pengguna']
                                                ?.toString() ??
                                            'Belum ditugaskan',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: _petugasDitugaskan != null
                                              ? const Color(0xFF059669)
                                              : const Color(0xFFD97706),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                        
                        Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: _status == 'Diverifikasi'
                                ? const Color(0xFFE5F0FF)
                                : const Color(0xFFFFF7D6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                _status == 'Diverifikasi'
                                    ? Icons.shield_outlined
                                    : Icons.info_outline,
                                size: 17,
                                color: _status == 'Diverifikasi'
                                    ? const Color(0xFF1749E8)
                                    : const Color(0xFFD97706),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _status == 'Diverifikasi'
                                      ? 'Laporan telah diverifikasi. Silakan tekan tombol "Tugaskan Petugas" untuk memilih teknisi yang bertugas.'
                                      : 'Laporan baru masuk. Periksa keabsahan keluhan fasilitas lalu klik tombol Verifikasi Laporan.',
                                  style: TextStyle(
                                    fontSize: 10,
                                    height: 1.5,
                                    color: _status == 'Diverifikasi'
                                        ? const Color(0xFF1749E8)
                                        : const Color(0xFFB45309),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),

      // ======================================
      // TOMBOL BAGIAN BAWAH
      // ======================================

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Color(0xFFE2E8F0),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _isLoading || _isMenyimpanPenugasan
                  ? null
                  : _status == 'Diajukan'
                      ? _ubahStatus
                      : _status == 'Diverifikasi'
                          ? _tampilkanDialogPenugasan
                          : null,
                icon: (_isLoading || _isMenyimpanPenugasan)
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    _status == 'Diajukan'
                        ? Icons.check_circle_outline
                        : Icons.person_add_alt_1,
                    size: 17,
                  ),
                label: Text(
                  _isLoading
                      ? 'Memproses...'
                      : _isMenyimpanPenugasan
                          ? 'Menyimpan Penugasan...'
                          : _status == 'Diajukan'
                              ? 'Verifikasi Laporan'
                              : _status == 'Diverifikasi'
                                  ? _petugasDitugaskan != null
                                      ? 'Ganti Petugas'
                                      : 'Tugaskan Petugas'
                                  : 'Laporan Selesai',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1749E8),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF94A3B8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  elevation: 3,
                ),
              ),
            ),

              const SizedBox(height: 5),

            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // KOMPONEN KARTU
  // ==========================================

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFDBE5F1),
        ),
      ),
      child: child,
    );
  }

  // ==========================================
  // KOMPONEN CHIP INFORMASI
  // ==========================================

  Widget _infoChip(
    IconData icon,
    String text,
    Color iconColor,
    Color background,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: iconColor,
          ),

          const SizedBox(width: 5),

          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // BADGE STATUS
  // ==========================================

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: _warnaStatus,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: _warnaTeksStatus,
        ),
      ),
    );
  }
}
