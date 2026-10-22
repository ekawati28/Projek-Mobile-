import 'package:flutter/material.dart';

class LaporanItem {
  final String id;
  final String title;
  final String category;
  final String status;
  final String dayName; // Contoh: "Kam"
  final String dateOnly; // Contoh: "19 Sep 2026"
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  LaporanItem({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.dayName,
    required this.dateOnly,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });
}

class RiwayatLaporanScreen extends StatefulWidget {
  const RiwayatLaporanScreen({super.key});

  @override
  State<RiwayatLaporanScreen> createState() => _RiwayatLaporanScreenState();
}

class _RiwayatLaporanScreenState extends State<RiwayatLaporanScreen> {
  String _activeTab = 'Semua';
  String _searchQuery = '';
  int _selectedNavIndex = 1;

  // Data Laporan Sesuai Gambar Referensi Terbaru
  final List<LaporanItem> _allLaporan = [
    LaporanItem(
      id: '#CR-2026-0941',
      title: 'AC di LAP RPL Bermasalah',
      category: 'AC',
      status: 'Diajukan',
      dayName: 'Kam',
      dateOnly: '19 Sep 2026',
      icon: Icons.air,
      iconBgColor: const Color(0xFFE0F2FE),
      iconColor: const Color(0xFF0284C7),
    ),
    LaporanItem(
      id: '#CR-2026-0883',
      title: 'Kursi ruang kelas rusak',
      category: 'Perabot',
      status: 'Diproses',
      dayName: 'Kam',
      dateOnly: '18 Sep 2026',
      icon: Icons.chair,
      iconBgColor: const Color(0xFFDCFCE7),
      iconColor: const Color(0xFF16A34A),
    ),
    LaporanItem(
      id: '#CR-2026-0814',
      title: 'Lampu kamar mandi mati',
      category: 'Listrik',
      status: 'Selesai',
      dayName: 'Kam',
      dateOnly: '16 Sep 2026',
      icon: Icons.bolt,
      iconBgColor: const Color(0xFFFEF9C3),
      iconColor: const Color(0xFFCA8A04),
    ),
  ];

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Diajukan':
        return const Color(0xFFFEF3C7);
      case 'Diproses':
        return const Color(0xFFF3E8FF);
      case 'Selesai':
        return const Color(0xFFDCFCE7);
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Diajukan':
        return const Color(0xFFB45309);
      case 'Diproses':
        return const Color(0xFF7E22CE);
      case 'Selesai':
        return const Color(0xFF15803D);
      default:
        return Colors.black;
    }
  }

  int _getCount(String status) {
    if (status == 'Semua') return _allLaporan.length;
    return _allLaporan.where((l) => l.status == status).length;
  }

  List<LaporanItem> get _filteredLaporan {
    return _allLaporan.where((item) {
      final matchesStatus =
          (_activeTab == 'Semua') || (item.status == _activeTab);
      final matchesSearch =
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.id.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.black87),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Riwayat Laporan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Daftar laporan fasilitas yang pernah\nkamu buat.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: const InputDecoration(
                        hintText: 'Cari laporan...',
                        hintStyle:
                            TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Semua', 'Diajukan', 'Diproses', 'Selesai']
                          .map((status) {
                        final isSelected = _activeTab == status;
                        final count = _getCount(status);

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Row(
                              children: [
                                Text(
                                  status,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF334155),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF1D4ED8)
                                        : const Color(0xFFE2E8F0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$count',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF475569),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            selected: isSelected,
                            selectedColor: const Color(0xFF2563EB),
                            backgroundColor: const Color(0xFFF1F5F9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide.none,
                            ),
                            showCheckmark: false,
                            onSelected: (selected) {
                              if (selected) setState(() => _activeTab = status);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // List Laporan Card
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredLaporan.length,
                itemBuilder: (context, index) {
                  final item = _filteredLaporan[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: const Color(0xFF93C5FD), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: item.iconBgColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(item.icon,
                                  color: item.iconColor, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF6FF),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          item.id,
                                          style: const TextStyle(
                                            color: Color(0xFF2563EB),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: _getStatusBgColor(item.status),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          item.status,
                                          style: TextStyle(
                                            color: _getStatusTextColor(
                                                item.status),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.category,
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: Color(0xFFF1F5F9), height: 1),
                        const SizedBox(height: 8),

                        // Footer Kartu Sesuai Gambar Referensi Terbaru[cite: 13]
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: Color(0xFF94A3B8)),
                            const SizedBox(width: 2),
                            Text(
                              item.dayName, // Menampilkan "Kam" di sebelah ikon lokasi[cite: 13]
                              style: const TextStyle(
                                  color: Color(0xFF64748B), fontSize: 11),
                            ),
                            const SizedBox(width: 6),
                            const Text('•',
                                style: TextStyle(color: Color(0xFF94A3B8))),
                            const SizedBox(width: 6),
                            const Icon(Icons.calendar_today_outlined,
                                size: 14, color: Color(0xFF94A3B8)),
                            const SizedBox(width: 4),
                            Text(
                              item.dateOnly, // Menampilkan tanggal lengkap "19 Sep 2026"[cite: 13]
                              style: const TextStyle(
                                  color: Color(0xFF64748B), fontSize: 11),
                            ),
                            const Spacer(),

                            // Tombol Lihat Detail
                            InkWell(
                              onTap: () {
                                // Sambungkan ke Halaman Detail buatan temanmu di sini
                              },
                              child: Row(
                                children: const [
                                  Text(
                                    'Lihat Detail',
                                    style: TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Icon(Icons.chevron_right,
                                      size: 16, color: Color(0xFF2563EB)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar dengan Jarak Seimbang
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home_outlined, 'Beranda', 0),
            _buildNavItem(Icons.history, 'Riwayat', 1),
            _buildBuatLaporanItem(),
            _buildNavItem(Icons.person_outline, 'Profil', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedNavIndex == index;
    final color =
        isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuatLaporanItem() {
    return InkWell(
      onTap: () {
        // Aksi ketika tombol Buat Laporan diklik
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Buat Laporan',
            style: TextStyle(
              color: Color(0xFF2563EB),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
