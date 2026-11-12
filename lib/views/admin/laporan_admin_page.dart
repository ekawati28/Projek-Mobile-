import 'package:flutter/material.dart';
import '../../services/admin/admin_laporan_service.dart';
import 'detail_laporan_admin_page.dart';
import '../../widgets/bottom_navbar_admin.dart';
import 'dashboard_admin.dart';
import 'petugas_page.dart';
import 'profil_administrator.dart';

class LaporanAdminPage extends StatefulWidget {
  const LaporanAdminPage({super.key});

  @override
  State<LaporanAdminPage> createState() => _LaporanAdminPageState();
}

class _LaporanAdminPageState extends State<LaporanAdminPage> {
  // Index filter: 0 = Semua, 1 = Diajukan, 2 = Diverifikasi
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final AdminLaporanService _laporanService = AdminLaporanService();

  List<Map<String, dynamic>> _allLaporan = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _muatLaporan();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigasiAdmin(int index) {
    if (index == 1) return;

    Widget halaman;

    switch (index) {
      case 0:
        halaman = const DashboardAdminScreen();
        break;
      case 2:
        halaman = const PetugasPage();
        break;
      case 3:
        halaman = const ProfilAdministrator();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => halaman,
      ),
    );
  }

  Future<void> _muatLaporan() async {
    try {
      final hasil = await _laporanService.getDaftarLaporan();

      if (!mounted) return;

      setState(() {
        _allLaporan = hasil;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Memfilter data berdasarkan tab yang dipilih
    List<Map<String, dynamic>> filteredLaporan =
      _allLaporan.where((item) {
    final status = item['status']?.toString() ?? '';

    if (_selectedFilterIndex == 1) {
      return status == 'Diajukan';
    }

    if (_selectedFilterIndex == 2) {
      return status == 'Diverifikasi';
    }

    if (_selectedFilterIndex == 3) {
      return status == 'Diproses';
    }

    if (_selectedFilterIndex == 4) {
      return status == 'Selesai';
    }

    return true;
  }).where((item) {
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daftar Laporan Kampus',
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
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
                  _buildFilterChip(0, 'Semua'),
                  const SizedBox(width: 8),
                  _buildFilterChip(1, 'Diajukan'),
                  const SizedBox(width: 8),
                  _buildFilterChip(2, 'Diverifikasi'),
                  const SizedBox(width: 8),
                  _buildFilterChip(3, 'Diproses'),
                  const SizedBox(width: 8),
                  _buildFilterChip(4, 'Selesai'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // === LIST LAPORAN ===
            Expanded(
              child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Text(
                          'Gagal memuat laporan:\n$_errorMessage',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : filteredLaporan.isEmpty
                        ? const Center(
                            child: Text('Tidak ada laporan ditemukan.'),
                          )
                        : ListView.separated(
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
      bottomNavigationBar: BottomNavbarAdmin(
        currentIndex: 1,
        onTap: _navigasiAdmin,
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
    final status = item['status']?.toString() ?? '';

    final statusColor = switch (status) {
      'Diajukan' => const Color(0xFFFEF3C7),
      'Diverifikasi' => const Color(0xFFDBEAFE),
      'Diproses' => const Color(0xFFF3E8FF),
      'Selesai' => const Color(0xFFDCFCE7),
      _ => const Color(0xFFE2E8F0),
    };

    final statusTextColor = switch (status) {
      'Diajukan' => const Color(0xFFD97706),
      'Diverifikasi' => const Color(0xFF2563EB),
      'Diproses' => const Color(0xFF9333EA),
      'Selesai' => const Color(0xFF16A34A),
      _ => const Color(0xFF64748B),
    };

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final berubah = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailLaporanAdminPage(
              laporan: item,
            ),
          ),
        );

        if (berubah == true) {
          await _muatLaporan();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['id']?.toString() ?? '-',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2563EB),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item['title']?.toString() ?? '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            
            // BARIS INFORMASI KATEGORI DAN LOKASI
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.sell_outlined,
                        size: 14,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item['kategori']?.toString() ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFFEF4444),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          item['lokasi']?.toString() ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // BARIS INFORMASI PELAPOR DAN TANGGAL
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item['pelapor']?.toString() ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['tanggal']?.toString() ?? '-',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}