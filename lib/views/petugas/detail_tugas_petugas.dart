import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as picker;

const Color _primary = Color(0xFF2563EB);
const Color _background = Color(0xFFF8FAFC);
const Color _textDark = Color(0xFF0F172A);
const Color _textSecondary = Color(0xFF64748B);
const Color _border = Color(0xFFE2E8F0);
const Color _green = Color(0xFF16A34A);

BoxDecoration _petugasCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: _border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.025),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

Color _statusTextColor(String status) {
  switch (status) {
    case 'Diproses':
      return const Color(0xFF7C3AED);
    case 'Selesai':
      return const Color(0xFF15803D);
    default:
      return const Color(0xFFB45309);
  }
}

Color _statusBackgroundColor(String status) {
  switch (status) {
    case 'Diproses':
      return const Color(0xFFF5F3FF);
    case 'Selesai':
      return const Color(0xFFDCFCE7);
    default:
      return const Color(0xFFFEF3C7);
  }
}

Color _priorityColor(String prioritas) {
  switch (prioritas) {
    case 'Tinggi':
      return const Color(0xFFDC2626);
    case 'Sedang':
      return const Color(0xFFEA580C);
    default:
      return const Color(0xFFDC2626);
  }
}

class _CircleBackButton extends StatelessWidget {
  const _CircleBackButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        padding: EdgeInsets.zero,
        icon: const Icon(
          Icons.arrow_back_rounded,
          size: 19,
          color: Color(0xFF334155),
        ),
      ),
    );
  }
}

class DetailTugasPetugas extends StatefulWidget {
  final Map<String, dynamic> tugas;

  const DetailTugasPetugas({
    super.key,
    required this.tugas,
  });

  @override
  State<DetailTugasPetugas> createState() => _DetailTugasPetugasState();
}

class _DetailTugasPetugasState extends State<DetailTugasPetugas> {
  String get _id => widget.tugas['id']?.toString() ?? '';

  String get _prioritas => widget.tugas['prioritas']?.toString() ?? 'Normal';

  String get _status => widget.tugas['status']?.toString() ?? 'Diajukan';

  String get _judul => widget.tugas['judul']?.toString() ?? '';

  String get _lokasi => widget.tugas['lokasi']?.toString() ?? '';

  String get _lokasiKampus =>
      widget.tugas['lokasiKampus']?.toString() ?? 'Kampus III';

  String get _kategori => widget.tugas['kategori']?.toString() ?? '';

  String get _tanggal => widget.tugas['tanggal']?.toString() ?? '';

  String get _petugas => widget.tugas['petugas']?.toString() ?? 'Budi';

  String get _deskripsi => widget.tugas['deskripsi']?.toString() ?? '';

  String get _fotoLabel => widget.tugas['fotoLabel']?.toString() ?? _judul;

  String get _waktuFoto => widget.tugas['waktuFoto']?.toString() ?? _tanggal;

  Future<void> _mulaiPenanganan() async {
    if (_status == 'Selesai') return;

    if (_status != 'Diproses') {
      setState(() {
        widget.tugas['status'] = 'Diproses';
      });
    }

    final selesai = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PenangananLaporanPage(tugas: widget.tugas),
      ),
    );

    if (!mounted) return;

    if (selesai == true) {
      widget.tugas['status'] = 'Selesai';
      Navigator.pop(context);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Container(
              height: 1,
              color: const Color(0xFFF1F5F9),
            ),
            Expanded(
              child: Container(
                color: _background,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPriorityBanner(),
                      const SizedBox(height: 10),
                      Text(
                        _judul,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildInfoCard(),
                      const SizedBox(height: 14),
                      _buildDescriptionCard(),
                      const SizedBox(height: 16),
                      _buildPhotoHeader(),
                      const SizedBox(height: 10),
                      _buildPhotoCard(),
                      const SizedBox(height: 14),
                      _buildWarningCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        children: [
          SizedBox(
            height: 42,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: _CircleBackButton(),
                ),
                const Text(
                  'Detail Tugas',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildStatusPill(_status),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                _id,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: _primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _statusBackgroundColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: _statusTextColor(status),
        ),
      ),
    );
  }

  Widget _buildPriorityBanner() {
    final color = _priorityColor(_prioritas);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        'Prioritas $_prioritas • Tugas $_status',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _petugasCardDecoration(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInfoInline(
                  Icons.local_offer_outlined,
                  'Kategori:',
                  _kategori,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildInfoInline(
                  Icons.location_on_outlined,
                  'Lokasi:',
                  _lokasi,
                  iconColor: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInfoInline(
                  Icons.calendar_today_outlined,
                  'Tanggal:',
                  _tanggal,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildInfoInline(
                  Icons.info_outline_rounded,
                  'Status:',
                  _status,
                  valueColor: _primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 17,
                color: _textSecondary,
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: Text(
                  'Petugas Ditugaskan:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _textSecondary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFBFDBFE),
                  ),
                ),
                child: Text(
                  _petugas,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoInline(
    IconData icon,
    String label,
    String value, {
    Color iconColor = _textSecondary,
    Color valueColor = _textDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label ',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _textSecondary,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _petugasCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsi Masalah:',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _deskripsi,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.7,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoHeader() {
    return const Row(
      children: [
        Expanded(
          child: Text(
            'Foto Laporan Masalah:',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
        ),
        Text(
          'Bukti Mahasiswa',
          style: TextStyle(
            fontSize: 11.5,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Container(
                width: 26,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF94A3B8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'FOTO BUKTI: $_fotoLabel',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$_lokasi $_lokasiKampus • $_waktuFoto',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9.5,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFFDE68A),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 18,
            color: Color(0xFFD97706),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Bawalah peralatan inspeksi teknis sarpra sebelum menuju ke '
              '$_lokasi.',
              style: const TextStyle(
                fontSize: 11.5,
                height: 1.5,
                color: Color(0xFFB45309),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final bool selesai = _status == 'Selesai';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: selesai ? null : _mulaiPenanganan,
            icon: Icon(
              selesai
                  ? Icons.check_circle_outline_rounded
                  : Icons.play_arrow_rounded,
              size: 20,
            ),
            label: Text(
              selesai ? 'Tugas Telah Selesai' : 'Mulai Penanganan',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFCBD5E1),
              disabledForegroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PenangananLaporanPage extends StatefulWidget {
  final Map<String, dynamic> tugas;

  const PenangananLaporanPage({
    super.key,
    required this.tugas,
  });

  @override
  State<PenangananLaporanPage> createState() => _PenangananLaporanPageState();
}

class _PenangananLaporanPageState extends State<PenangananLaporanPage> {
  final picker.ImagePicker _imagePicker = picker.ImagePicker();
  final TextEditingController _catatanController = TextEditingController();

  late final List<bool> _checklist;
  Uint8List? _fotoBytes;
  int _statusIndex = 0;

  String get _id => widget.tugas['id']?.toString() ?? '';

  String get _lokasi => widget.tugas['lokasi']?.toString() ?? '';

  String get _kategori => widget.tugas['kategori']?.toString() ?? '';

  String get _petugas => widget.tugas['petugas']?.toString() ?? 'Budi';

  String get _fotoLabel => widget.tugas['fotoLabel']?.toString() ?? _lokasi;

  String get _waktuFotoSesudah =>
      widget.tugas['waktuFotoSesudah']?.toString() ?? '11:25 WIT';

  String get _statusLabel => _statusIndex == 0 ? 'Diproses' : 'Siap Selesai';

  Color get _statusAccent =>
      _statusIndex == 0 ? const Color(0xFF7C3AED) : _green;

  @override
  void initState() {
    super.initState();

    _catatanController.text = widget.tugas['catatanSelesai']?.toString() ?? '';
    _checklist = List<bool>.filled(4, true);
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _gantiFoto() async {
    final source = await showModalBottomSheet<picker.ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_camera_outlined,
                    color: _primary,
                  ),
                  title: const Text(
                    'Ambil dari Kamera',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext, picker.ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: _primary,
                  ),
                  title: const Text(
                    'Pilih dari Galeri',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext, picker.ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.close_rounded,
                    color: _textSecondary,
                  ),
                  title: const Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _textSecondary,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null || !mounted) return;

    try {
      final hasil = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (hasil == null) return;

      final bytes = await hasil.readAsBytes();

      if (!mounted) return;

      setState(() {
        _fotoBytes = bytes;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Foto tidak dapat diambil. Periksa izin kamera atau galeri.',
          ),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
    }
  }

  Future<void> _selesaikan() async {
    if (_catatanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan penyelesaian teknis wajib diisi.'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Selesaikan Penanganan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          content: const Text(
            'Pastikan seluruh pekerjaan teknis telah selesai dan foto '
            'dokumentasi sudah sesuai. Laporan akan ditutup dan tidak dapat '
            'diubah.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: Color(0xFF475569),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Batal',
                style: TextStyle(color: _textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Ya, Selesaikan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true || !mounted) return;

    final selesai = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => LaporanSelesaiPage(
          tugas: widget.tugas,
          catatan: _catatanController.text.trim(),
          fotoSesudah: _fotoBytes,
        ),
      ),
    );

    if (!mounted) return;

    if (selesai == true) {
      widget.tugas['status'] = 'Selesai';
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Container(
              height: 1,
              color: const Color(0xFFF1F5F9),
            ),
            Expanded(
              child: Container(
                color: _background,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Perbarui Status Penanganan:'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildStatusOption(0),
                          const SizedBox(width: 10),
                          _buildStatusOption(1),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildStatusInfo(),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Daftar Pengerjaan Teknis:'),
                      const SizedBox(height: 10),
                      _buildChecklistCard(),
                      const SizedBox(height: 16),
                      _buildRequiredLabel('Catatan Penyelesaian Teknis'),
                      const SizedBox(height: 8),
                      _buildNotesField(),
                      const SizedBox(height: 16),
                      _buildPhotoHeader(),
                      const SizedBox(height: 8),
                      _buildPhotoResultCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeader() {
    final accent = _statusAccent;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CircleBackButton(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Penanganan\nLaporan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_id • $_lokasi',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: _primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Status:\n$_statusLabel',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                height: 1.3,
                fontWeight: FontWeight.w600,
                color: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.bold,
        color: _textDark,
      ),
    );
  }

  Widget _buildStatusOption(int index) {
    final bool aktif = _statusIndex == index;
    final gradient = index == 0
        ? const [Color(0xFF7C3AED), Color(0xFFA855F7)]
        : const [_green, Color(0xFF22C55E)];
    final icon =
        index == 0 ? Icons.build_rounded : Icons.check_circle_outline_rounded;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _statusIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            gradient: aktif
                ? LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: aktif ? null : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: aktif ? Colors.transparent : _border,
            ),
            boxShadow: aktif
                ? [
                    BoxShadow(
                      color: gradient.last.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: aktif ? Colors.white : const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  index == 0 ? '1. Sedang\nDiproses' : '2. Siap\nSelesai',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                    color: aktif ? Colors.white : const Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusInfo() {
    final accent = _statusAccent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _statusIndex == 0
                ? Icons.build_rounded
                : Icons.check_circle_outline_rounded,
            size: 20,
            color: accent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status terpilih: "$_statusLabel".',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mahasiswa & Admin dapat melihat pembaruan ini secara '
                  'real-time.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistCard() {
    final items = [
      'Pemeriksaan kondisi fisik fasilitas $_kategori di $_lokasi',
      'Penggantian suku cadang atau perbaikan komponen rusak',
      'Pengujian fungsionalitas fasilitas hingga bekerja optimal',
      'Pembersihan area kerja setelah penanganan tuntas',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: _petugasCardDecoration(),
      child: Column(
        children: List.generate(items.length, (index) {
          return InkWell(
            onTap: () {
              setState(() {
                _checklist[index] = !_checklist[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: _checklist[index] ? _primary : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: _checklist[index]
                            ? _primary
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: _checklist[index]
                        ? const Icon(
                            Icons.check_rounded,
                            size: 13,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      items[index],
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRequiredLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
          height: 1.35,
          color: _textDark,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Color(0xFFDC2626)),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    return TextField(
      controller: _catatanController,
      minLines: 4,
      maxLines: 5,
      textAlignVertical: TextAlignVertical.top,
      style: const TextStyle(
        fontSize: 12.5,
        height: 1.5,
        color: Color(0xFF334155),
      ),
      decoration: InputDecoration(
        hintText: 'Tuliskan catatan penyelesaian teknis...',
        hintStyle: const TextStyle(
          fontSize: 12,
          color: Color(0xFF94A3B8),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 1.2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
      ),
    );
  }

  Widget _buildPhotoHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildRequiredLabel(
            'Foto Setelah Perbaikan\n(Wajib)',
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: _gantiFoto,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Ganti Foto',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: _primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoResultCard() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_fotoBytes != null)
            Image.memory(
              _fotoBytes!,
              fit: BoxFit.cover,
            ),
          if (_fotoBytes != null)
            Container(
              color: Colors.black.withValues(alpha: 0.45),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'NORMAL (OK)',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'FOTO HASIL: ${_fotoLabel.toUpperCase()} NORMAL',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4ADE80),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_waktuFotoSesudah • Teknis: $_petugas',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _selesaikan,
            icon: const Icon(
              Icons.check_circle_outline_rounded,
              size: 20,
            ),
            label: const Text(
              'Selesaikan Laporan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LaporanSelesaiPage extends StatelessWidget {
  final Map<String, dynamic> tugas;
  final String catatan;
  final Uint8List? fotoSesudah;

  const LaporanSelesaiPage({
    super.key,
    required this.tugas,
    required this.catatan,
    this.fotoSesudah,
  });

  String get _id => tugas['id']?.toString() ?? '';

  String get _judul => tugas['judul']?.toString() ?? '';

  String get _lokasi => tugas['lokasi']?.toString() ?? '';

  String get _lokasiKampus => tugas['lokasiKampus']?.toString() ?? 'Kampus III';

  String get _petugas => tugas['petugas']?.toString() ?? 'Budi';

  String get _waktuFotoSebelum =>
      tugas['waktuFotoSebelum']?.toString() ?? '08:30 WIT';

  String get _waktuFotoSesudah =>
      tugas['waktuFotoSesudah']?.toString() ?? '11:25 WIT';

  String get _waktuSelesai =>
      tugas['waktuSelesai']?.toString() ?? '19 Sep 2026, 11:30 WIT';

  void _tampilkanRiwayat(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.history_rounded,
                        size: 19,
                        color: _primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Riwayat Tugas Petugas',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _id,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _primary,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Selesai',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _judul,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Diselesaikan: $_waktuSelesai',
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: _background,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 34,
                    color: _green,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'STATUS: SELESAI',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Laporan Selesai\nDitangani!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Tiket ',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: _textSecondary,
                        ),
                      ),
                      TextSpan(
                        text: _id,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: _primary,
                        ),
                      ),
                      const TextSpan(
                        text: ' resmi ditutup',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                _buildSummaryCard(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _judul,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 15,
                color: Color(0xFFEF4444),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  '$_lokasiKampus • $_lokasi',
                  style: const TextStyle(
                    fontSize: 11,
                    color: _textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Dokumentasi Fisik Perbaikan:',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildPhotoDoc(
                  label: 'SEBELUM',
                  labelColor: const Color(0xFF94A3B8),
                  innerText: 'Rusak',
                  innerColor: const Color(0xFFF87171),
                  time: _waktuFotoSebelum,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildPhotoDoc(
                  label: 'SESUDAH (OK)',
                  labelColor: const Color(0xFF4ADE80),
                  innerText: 'Normal (OK)',
                  innerColor: const Color(0xFF4ADE80),
                  time: _waktuFotoSesudah,
                  fotoBytes: fotoSesudah,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catatan Penyelesaian Teknis:',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '"$catatan"',
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.55,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: _border),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Waktu Selesai:',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: _textSecondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _waktuSelesai,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Petugas Teknis:',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: _textSecondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _petugas,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _primary,
                      ),
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

  Widget _buildPhotoDoc({
    required String label,
    required Color labelColor,
    required String innerText,
    required Color innerColor,
    required String time,
    Uint8List? fotoBytes,
  }) {
    return Container(
      height: 112,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (fotoBytes != null)
            Image.memory(
              fotoBytes,
              fit: BoxFit.cover,
            ),
          if (fotoBytes != null)
            Container(
              color: Colors.black.withValues(alpha: 0.55),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                    color: labelColor,
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(
                        alpha: fotoBytes != null ? 0.70 : 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      innerText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: innerColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 8,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: _background,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.home_outlined, size: 19),
                label: const Text(
                  'Kembali ke Dasbor Tugas',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () {
                  _tampilkanRiwayat(context);
                },
                icon: const Icon(
                  Icons.history_rounded,
                  size: 18,
                  color: Color(0xFF334155),
                ),
                label: const Text(
                  'Lihat Riwayat Tugas Petugas',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: _border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
