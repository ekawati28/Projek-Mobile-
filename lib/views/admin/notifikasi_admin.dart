import 'package:flutter/material.dart';

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
  int selectedFilter = 0;

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Laporan Baru Masuk',
      'description':
          'Mahasiswa mengirimkan laporan kerusakan fasilitas...',
      'time': '5 menit yang lalu',
      'icon': Icons.send_outlined,
      'color': const Color(0xFF2563EB),
      'background': const Color(0xFFDCEAFF),
      'unread': true,
    },
    {
      'title': 'Laporan Menunggu Verifikasi',
      'description':
          'Terdapat laporan baru yang perlu diperiksa dan...',
      'time': '15 menit yang lalu',
      'icon': Icons.warning_amber_rounded,
      'color': const Color(0xFFEF7900),
      'background': const Color(0xFFFFF1BD),
      'unread': true,
    },
    {
      'title': 'Laporan Selesai Ditangani',
      'description':
          'Petugas telah memperbarui status laporan menjadi...',
      'time': '1 jam yang lalu',
      'icon': Icons.check_circle_outline,
      'color': const Color(0xFF008B68),
      'background': const Color(0xFFCCF8E8),
      'unread': true,
    },
    {
      'title': 'Laporan Telah Diverifikasi',
      'description':
          'Laporan #CR-2026-0892 (Lampu JT3 Mati) telah...',
      'time': '2 jam yang lalu',
      'icon': Icons.verified_user_outlined,
      'color': const Color(0xFF2563EB),
      'background': const Color(0xFFDCEAFF),
      'unread': false,
    },
    {
      'title': 'Pembaruan Penanganan Laporan',
      'description':
          'Teknisi sedang memproses perbaikan fasilitas...',
      'time': '4 jam yang lalu',
      'icon': Icons.build_outlined,
      'color': const Color(0xFF9333EA),
      'background': const Color(0xFFF2E3FF),
      'unread': false,
    },
  ];

  int get unreadCount =>
      notifications.where((item) => item['unread'] == true).length;

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 1) {
      return notifications
          .where((item) => item['unread'] == true)
          .toList();
    }
    return notifications;
  }

  void markAllAsRead() {
    setState(() {
      for (final item in notifications) {
        item['unread'] = false;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi sudah dibaca'),
      ),
    );
  }

  void openDetail(Map<String, dynamic> item) {
    setState(() {
      item['unread'] = false;
    });

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: item['background'] as Color,
                    child: Icon(
                      item['icon'] as IconData,
                      color: item['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                (item['description'] as String).replaceAll('...', '.'),
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: mutedText,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 15,
                    color: mutedText,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item['time'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: mutedText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        );
      },
    );
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
              child: filteredNotifications.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada notifikasi belum dibaca',
                        style: TextStyle(color: mutedText),
                      ),
                    )
                  : ListView.separated(
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEDF1F7)),
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
          TextButton(
            onPressed: markAllAsRead,
            style: TextButton.styleFrom(
              foregroundColor: primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 2),
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

  Widget buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          buildFilterChip('Semua', notifications.length, 0),
          const SizedBox(width: 8),
          buildFilterChip('Belum Dibaca', unreadCount, 1),
        ],
      ),
    );
  }

  Widget buildFilterChip(String label, int count, int index) {
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
              padding: const EdgeInsets.symmetric(horizontal: 4),
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

  Widget buildNotificationCard(Map<String, dynamic> item) {
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

  Widget buildBottomNavigation() {
    const labels = [
      'Dashboard',
      'Laporan',
      'Petugas',
      'Profil',
    ];

    const icons = [
      Icons.bar_chart_rounded,
      Icons.description_outlined,
      Icons.groups_outlined,
      Icons.person_outline,
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFEDF1F7)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(labels.length, (index) {
              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (index == 0) {
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Halaman ${labels[index]} perlu dihubungkan.',
                          ),
                        ),
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[index],
                        size: 21,
                        color: index == 0
                            ? primaryBlue
                            : const Color(0xFF8A9AB5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        labels[index],
                        style: TextStyle(
                          color: index == 0
                              ? primaryBlue
                              : const Color(0xFF8A9AB5),
                          fontSize: 10,
                          fontWeight: index == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}