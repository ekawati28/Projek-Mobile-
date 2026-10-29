import 'package:flutter/material.dart';

class LaporanAdminPage extends StatefulWidget {
  const LaporanAdminPage({super.key});

  @override
  State<LaporanAdminPage> createState() => _LaporanAdminPageState();
}

class _LaporanAdminPageState extends State<LaporanAdminPage> {
  // Index filter: 0 = Semua, 1 = Diajukan, 2 = Diverifikasi
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  // Data Dummy Laporan
  final List<Map<String, dynamic>> _allLaporan = [
    {
      'id': '#CR-2026-0041',
      'title': 'AC di LAP RPL Bermasalah',
      'status': 'Diajukan',
      'statusColor': const Color(0xFFFEF3C7),
      'statusTextColor': const Color(0xFFD97706),
      'kategori': 'AC',
      'lokasi': 'LAP RPL',
      'pelapor': 'Budi Santoso',
      'tanggal': '19 Sep 2026',
    },
    {
      'id': '#CR-2026-0040',
      'title': 'Stopkontak Korslet di LAP JAK',
      'status': 'Diajukan',
      'statusColor': const Color(0xFFFEF3C7),
      'statusTextColor': const Color(0xFFD97706),
      'kategori': 'Listrik',
      'lokasi': 'LAP JAK',
      'pelapor': 'Sarah Alkatiri',
      'tanggal': '19 Sep 2026',
    },
    {
      'id': '#CR-2026-0892',
      'title': 'Lampu JT3 Mati',
      'status': 'Diverifikasi',
      'statusColor': const Color(0xFFDBEAFE),
      'statusTextColor': const Color(0xFF2563EB),
      'kategori': 'Listrik',
      'lokasi': 'JT3',
      'pelapor': 'Nurul Hidayah',
      'tanggal': '18 Sep 2026',
    },
    {
      'id': '#CR-2026-0883',
      'title': 'Kursi ruang kelas rusak',
      'status': 'Diproses',
      'statusColor': const Color(0xFFF3E8FF),
      'statusTextColor': const Color(0xFF9333EA),
      'kategori': 'Perabot',
      'lokasi': 'J13',
      'pelapor': 'Budi Santoso',
      'tanggal': '18 Sep 2026',
    },
    {
      'id': '#CR-2026-0814',
      'title': 'Lampu kamar mandi mati',
      'status': 'Selesai',
      'statusColor': const Color(0xFFDCFCE7),
      'statusTextColor': const Color(0xFF16A34A),
      'kategori': 'Fasilitas',
      'lokasi': 'Gedung A',
      'pelapor': 'Ahmad Fausi',
      'tanggal': '17 Sep 2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Memfilter data berdasarkan tab yang dipilih
    List<Map<String, dynamic>> filteredLaporan = _allLaporan.where((item) {
      if (_selectedFilterIndex == 1) return item['status'] == 'Diajukan';
      if (_selectedFilterIndex == 2) return item['status'] == 'Diverifikasi';
      return true; // Index 0 = Semua
    }).where((item) {
      // Filter pencarian
      final query = _searchController.text.toLowerCase();
      return item['title'].toString().toLowerCase().contains(query) ||
          item['id'].toString().toLowerCase().contains(query) ||
          item['lokasi'].toString().toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // === HEADER PAGE ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Daftar Laporan\nKampus',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Biro Sarana & Prasarana',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_outlined,
                            color: Colors.black87),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // === SEARCH BAR ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari nomor tiket, lokasi, fasilitas...',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                  prefixIcon: const Icon(Icons.search,
                      size: 20, color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2563EB)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // === TAB FILTER CHIPS ===
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterChip(0, 'Semua (6)'),
                  const SizedBox(width: 8),
                  _buildFilterChip(1, 'Diajukan (2)'),
                  const SizedBox(width: 8),
                  _buildFilterChip(2, 'Diverifikasi'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // === LIST LAPORAN ===
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredLaporan.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = filteredLaporan[index];
                  return _buildLaporanCard(item);
                },
              ),
            ),
          ],
        ),
      ),

      // === NAVIGATION BAR BAWAH ===
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Menu Laporan Aktif
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Petugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // Helper Filter Chip (Tombol Filter)
  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1D4ED8) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1D4ED8)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  // Helper Kartu Item Laporan
  Widget _buildLaporanCard(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row Header Kartu (ID Tiket & Badge Status)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['id'],
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: item['statusColor'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item['status'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: item['statusTextColor'],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Judul Laporan
          Text(
            item['title'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // Details: Kategori & Lokasi
          Row(
            children: [
              const Icon(Icons.sell_outlined,
                  size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(
                item['kategori'],
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.location_on_outlined,
                  size: 14, color: Color(0xFFEF4444)),
              const SizedBox(width: 4),
              Text(
                item['lokasi'],
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Details: Pelapor & Tanggal
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(
                item['pelapor'],
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.calendar_today_outlined,
                  size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(
                item['tanggal'],
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}