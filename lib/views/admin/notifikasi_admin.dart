import 'package:flutter/material.dart';
import '../../services/admin/admin_notifikasi_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'detail_laporan_admin_page.dart';

const Color primaryBlue = Color(0xFF2563EB);
const Color darkText = Color(0xFF17264A);
const Color mutedText = Color(0xFF71809B);
const Color borderColor = Color(0xFFD9E5F6);

class NotifikasiAdminPage extends StatefulWidget {
  const NotifikasiAdminPage({super.key});

  @override
  State<NotifikasiAdminPage> createState() =>
      _NotifikasiAdminPageState();
}

class _NotifikasiAdminPageState extends State<NotifikasiAdminPage> {
  final AdminNotifikasiService _notifikasiService = AdminNotifikasiService();
  final SupabaseClient _supabase = Supabase.instance.client;

  int selectedFilter = 0;

  List<Map<String, dynamic>> notifications = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    muatNotifikasi();
  }

  // Mengambil notifikasi dari Supabase.
  Future<void> muatNotifikasi() async {
    try {
      final data =
          await _notifikasiService.getDaftarNotifikasi();

      if (!mounted) return;

      setState(() {
        notifications = data.map((item) {
          final judul = item['judul']?.toString() ?? '';
          final waktu = DateTime.tryParse(
            item['not_waktu_dibuat']?.toString() ?? '',
          );

          return {
            'id_notifikasi': item['id_notifikasi'],
            'id_laporan': item['id_laporan'],
            'title': judul,
            'description': item['pesan']?.toString() ?? '',
            'time': formatWaktu(waktu),
            'icon': ikonNotifikasi(judul),
            'color': warnaNotifikasi(judul),
            'background': latarNotifikasi(judul),
            'unread': item['baca'] == false,
          };
        }).toList();

        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });

      debugPrint('Gagal memuat notifikasi: $e');
    }
  }

  // Menghitung notifikasi belum dibaca.
  int get unreadCount {
    return notifications
        .where((item) => item['unread'] == true)
        .length;
  }

  // Filter notifikasi.
  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 1) {
      return notifications
          .where((item) => item['unread'] == true)
          .toList();
    }

    return notifications;
  }

  // Menentukan ikon berdasarkan judul.
  IconData ikonNotifikasi(String judul) {
    final teks = judul.toLowerCase();

    if (teks.contains('selesai')) {
      return Icons.check_circle_outline;
    }

    if (teks.contains('verifikasi')) {
      return Icons.verified_user_outlined;
    }

    if (teks.contains('proses')) {
      return Icons.build_outlined;
    }

    return Icons.notifications_active_outlined;
  }

  // Menentukan warna ikon.
  Color warnaNotifikasi(String judul) {
    final teks = judul.toLowerCase();

    if (teks.contains('selesai')) {
      return const Color(0xFF008B68);
    }

    if (teks.contains('verifikasi')) {
      return const Color(0xFFEF7900);
    }

    if (teks.contains('proses')) {
      return const Color(0xFF9333EA);
    }

    return primaryBlue;
  }

  // Menentukan warna latar ikon.
  Color latarNotifikasi(String judul) {
    final teks = judul.toLowerCase();

    if (teks.contains('selesai')) {
      return const Color(0xFFCCF8E8);
    }

    if (teks.contains('verifikasi')) {
      return const Color(0xFFFFF1BD);
    }

    if (teks.contains('proses')) {
      return const Color(0xFFF2E3FF);
    }

    return const Color(0xFFDCEAFF);
  }

  // Format waktu notifikasi.
  String formatWaktu(DateTime? waktu) {
    if (waktu == null) return '-';

    final selisih = DateTime.now().difference(
      waktu.toLocal(),
    );

    if (selisih.isNegative || selisih.inSeconds < 60) {
      return 'Baru saja';
    }

    if (selisih.inMinutes < 60) {
      return '${selisih.inMinutes} menit yang lalu';
    }

    if (selisih.inHours < 24) {
      return '${selisih.inHours} jam yang lalu';
    }

    if (selisih.inDays < 7) {
      return '${selisih.inDays} hari yang lalu';
    }

    return '${waktu.day}/${waktu.month}/${waktu.year}';
  }

  // Menandai semua notifikasi sebagai sudah dibaca.
  Future<void> markAllAsRead() async {
    if (unreadCount == 0) return;

    try {
      await _notifikasiService.tandaiSemuaDibaca();

      await muatNotifikasi();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua notifikasi sudah dibaca'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui notifikasi: $e'),
        ),
      );
    }
  }

  // Membuka detail laporan langsung dari notifikasi.
  Future<void> openDetail(
    Map<String, dynamic> item,
  ) async {
    try {
      // 1. Tandai notifikasi sudah dibaca.
      if (item['unread'] == true) {
        final idNotifikasi =
            (item['id_notifikasi'] as num).toInt();

        await _notifikasiService.tandaiDibaca(idNotifikasi);

        if (!mounted) return;

        setState(() {
          item['unread'] = false;
        });
      }

      // 2. Ambil ID laporan.
      final idLaporan =
          (item['id_laporan'] as num).toInt();

      // 3. Ambil data laporan.
      final laporan = await _supabase
          .from('laporan')
          .select(
            'id_laporan, id_pengguna, id_kategori, judul, '
            'lokasi, lpr_deskripsi, status, lpr_waktu_dibuat',
          )
          .eq('id_laporan', idLaporan)
          .single();

      // 4. Ambil data mahasiswa.
      final pengguna = await _supabase
          .from('pengguna')
          .select('id_pengguna, nama_pengguna, email')
          .eq('id_pengguna', laporan['id_pengguna'])
          .maybeSingle();

      if (pengguna == null) {
        throw Exception(
          'Data mahasiswa pelapor tidak ditemukan.',
        );
      }

      // 5. Format data.
      final id = (laporan['id_laporan'] as num).toInt();

      final namaPelapor =
          pengguna['nama_pengguna']?.toString() ?? '-';

      final emailPelapor =
          pengguna['email']?.toString() ?? '-';

      final judulLaporan =
          laporan['judul']?.toString() ?? '-';

      final waktu =
          laporan['lpr_waktu_dibuat']?.toString() ?? '';

      final tanggal = waktu.isNotEmpty
          ? waktu.split('T').first
          : '-';

      final deskripsi =
          laporan['lpr_deskripsi']?.toString() ?? '-';

      // 6. Siapkan data untuk halaman detail.
      final Map<String, dynamic> dataDetail = {
        // Identitas laporan.
        'id_laporan': id,
        'id': '#CR-$id',

        // Judul laporan.
        'judul': judulLaporan,
        'title': judulLaporan,
        'nama_laporan': judulLaporan,

        // Identitas mahasiswa.
        'nama_pelapor': namaPelapor,
        'pelapor': namaPelapor,
        'nama_pengguna': namaPelapor,
        'email': emailPelapor,

        // Informasi laporan.
        'lokasi': laporan['lokasi']?.toString() ?? '-',
        'kategori': laporan['id_kategori']?.toString() ?? '-',
        'tanggal': tanggal,
        'deskripsi': deskripsi,
        'lpr_deskripsi': deskripsi,
        'status': laporan['status']?.toString() ?? 'Diajukan',
      };

      debugPrint('===== DETAIL NOTIFIKASI ADMIN =====');
      debugPrint('ID: ${dataDetail['id']}');
      debugPrint('Nama: $namaPelapor');
      debugPrint('Email: $emailPelapor');
      debugPrint('Judul: $judulLaporan');
      debugPrint('===================================');

      if (!mounted) return;

      // 7. Buka halaman detail.
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailLaporanAdminPage(
            laporan: dataDetail,
          ),
        ),
      );

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka detail laporan: $e'),
          backgroundColor: Colors.red,
        ),
      );

      debugPrint('Gagal membuka detail laporan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(),
            buildFilters(),
            Expanded(
              child: buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  // Tampilan isi halaman.
  Widget buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: primaryBlue,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 42,
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              const Text(
                'Gagal memuat notifikasi',
                style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: mutedText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });

                  muatNotifikasi();
                },
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.notifications_none,
              size: 48,
              color: mutedText,
            ),
            const SizedBox(height: 10),
            Text(
              selectedFilter == 1
                  ? 'Tidak ada notifikasi belum dibaca'
                  : 'Belum ada notifikasi',
              style: const TextStyle(
                color: mutedText,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: primaryBlue,
      onRefresh: muatNotifikasi,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16,
        ),
        itemCount: filteredNotifications.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return buildNotificationCard(
            filteredNotifications[index],
          );
        },
      ),
    );
  }

  // Header halaman.
  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEDF1F7),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FC),
              shape: BoxShape.circle,
              border: Border.all(color: borderColor),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 19,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF40516D),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifikasi Admin',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Pusat aktivitas & tindak\nlanjut laporan sarpras',
                  style: TextStyle(
                    color: mutedText,
                    fontSize: 11,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          if (!isLoading && unreadCount > 0)
            TextButton(
              onPressed: markAllAsRead,
              style: TextButton.styleFrom(
                foregroundColor: primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 2,
                ),
              ),
              child: const Text(
                'Baca\nSemua',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Filter notifikasi.
  Widget buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          buildFilterChip(
            'Semua',
            notifications.length,
            0,
          ),
          const SizedBox(width: 8),
          buildFilterChip(
            'Belum Dibaca',
            unreadCount,
            1,
          ),
        ],
      ),
    );
  }

  Widget buildFilterChip(
    String label,
    int count,
    int index,
  ) {
    final bool active = selectedFilter == index;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        setState(() {
          selectedFilter = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: active
              ? primaryBlue
              : const Color(0xFFF0F3F8),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: active
                    ? Colors.white
                    : const Color(0xFF50617C),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              constraints: const BoxConstraints(
                minWidth: 17,
                minHeight: 17,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              decoration: BoxDecoration(
                color: active
                    ? Colors.white.withOpacity(0.18)
                    : const Color(0xFFFF3348),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kartu notifikasi.
  Widget buildNotificationCard(
    Map<String, dynamic> item,
  ) {
    final bool unread = item['unread'] == true;

    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: () => openDetail(item),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 11, 11),
        decoration: BoxDecoration(
          color: unread
              ? const Color(0xFFF7FAFF)
              : Colors.white,
          border: Border.all(
            color: unread
                ? const Color(0xFFB9D5FF)
                : borderColor,
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: item['background'] as Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item['icon'] as IconData,
                size: 19,
                color: item['color'] as Color,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: darkText,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (unread) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item['description'] as String,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: mutedText,
                      fontSize: 10.5,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    height: 1,
                    color: Color(0xFFEDF1F7),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: mutedText,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item['time'] as String,
                          style: const TextStyle(
                            color: mutedText,
                            fontSize: 9.5,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => openDetail(item),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
                          minimumSize: const Size(54, 28),
                          tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: primaryBlue,
                        ),
                        child: const Text(
                          'Buka\nDetail',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        size: 17,
                        color: primaryBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
