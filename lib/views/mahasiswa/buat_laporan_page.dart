import 'package:flutter/material.dart';
import '../../services/laporan_service.dart';
import '../../widgets/bottom_navbar.dart';
import 'riwayat_laporan_page.dart';
import 'profile_page.dart';
import '../../models/laporan_model.dart';
import 'detail_laporan_page.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../../services/submit_laporan_service.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengaduan Sarpras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2563EB),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const BuatLaporanScreen(),
    );
  }
}

// ============================================================
// SCREEN 1: BUAT LAPORAN
// ============================================================
class BuatLaporanScreen extends StatefulWidget {
  final ValueChanged<int>? onNavTap;

  const BuatLaporanScreen({
    super.key,
    this.onNavTap,
  });

  @override
  State<BuatLaporanScreen> createState() => _BuatLaporanScreenState();
}

class _BuatLaporanScreenState extends State<BuatLaporanScreen> {
  String selectedKategori = 'AC';
  String selectedLokasi = 'LAB RPL';
  String selectedLokasiSub = 'Kampus III Unkhair Jati';

  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  int _currentIndex = 2;

  void _handleNavTap(int index) {
    widget.onNavTap?.call(index);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildBuatLaporanContent(),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          widget.onNavTap?.call(index);
        },
      ),
    );
  }

  Widget _buildBerandaContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('Halaman Beranda', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 8),
          Text('Selamat datang di Pengaduan Sarpras', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildRiwayatContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('Halaman Riwayat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 8),
          Text('Belum ada riwayat laporan', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildBuatLaporanContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () { if (Navigator.canPop(context)) Navigator.pop(context); },
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: const Color(0xFFF3F4F6), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1F2937), size: 20),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Buat Laporan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  SizedBox(height: 2),
                  Text('Formulir Pengaduan Sarpras', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFBFDBFE), width: 1)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 28, height: 28, decoration: BoxDecoration(color: const Color(0xFFDBEAFE), shape: BoxShape.circle), child: const Icon(Icons.info_outline, color: Color(0xFF2563EB), size: 18)),
                const SizedBox(width: 12),
                const Expanded(child: Text('Laporkan fasilitas kampus yang rusak secara akurat agar petugas dapat segera melakukan perbaikan.', style: TextStyle(fontSize: 14, color: Color(0xFF1E3A5F), height: 1.5))),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text('1. Pilih Kategori Fasilitas *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 39, 17, 17))),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PilihKategoriScreen(selectedKategori: selectedKategori))).then((value) {
                if (value != null) setState(() { selectedKategori = value; });
              });
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)),
              child: Row(
                children: [
                  Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.grid_view_rounded, color: Color(0xFF2563EB), size: 24)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Kategori: $selectedKategori', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      const SizedBox(height: 2),
                      const Text('Ketuk untuk mengganti kategori', style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
                    ]),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 24),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('2. Pilih Lokasi Fasilitas *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PilihLokasiScreen(selectedLokasi: selectedLokasi))).then((value) {
                if (value != null) {
                  setState(() {
                    selectedLokasi = value['lokasi'] ?? selectedLokasi;
                    selectedLokasiSub = value['sub'] ?? selectedLokasiSub;
                  });
                }
              });
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)),
              child: Row(
                children: [
                  Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.location_on_outlined, color: Color(0xFF2563EB), size: 24)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Lokasi: $selectedLokasi', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      const SizedBox(height: 2),
                      Text(selectedLokasiSub, style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
                    ]),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 24),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            '3. Judul Laporan *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
              ),
            ),
            child: TextField(
              controller: _judulController,
              maxLength: 100,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Contoh: AC Ruang Lab RPL Rusak',
                counterText: '',
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Text('4. Deskripsi Kerusakan *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 12),
          Container(
            width: double.infinity, constraints: const BoxConstraints(minHeight: 120), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)),
            child: TextField(
              controller: _deskripsiController, maxLines: null, minLines: 3,
              decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero, hintText: 'Tuliskan deskripsi kerusakan...', hintStyle: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF))),
              style: const TextStyle(fontSize: 14, color: Color(0xFF374151), height: 1.6),
            ),
          ),
          const SizedBox(height: 24),
          const Text('5. Lampirkan Foto Bukti *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {}, behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity, height: 160, padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFD1D5DB), width: 1.5, style: BorderStyle.solid)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 52, height: 52, decoration: BoxDecoration(color: const Color(0xFFEFF6FF), shape: BoxShape.circle), child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF2563EB), size: 26)),
                  const SizedBox(height: 12),
                  const Text('Unggah Foto Kerusakan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  const SizedBox(height: 4),
                  Text('Format JPG/PNG (Maks. 5MB)', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () async {
                final judul = _judulController.text.trim();
                final deskripsi = _deskripsiController.text.trim();

                if (judul.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Judul laporan harus diisi!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (deskripsi.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Deskripsi kerusakan harus diisi!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final laporanBerhasil = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute<bool>(
                    builder: (context) => DeskripsiFotoScreen(
                      judul: judul,
                      kategori: selectedKategori,
                      lokasi: selectedLokasi,
                      deskripsiAwal: deskripsi,
                    ),
                  ),
                );

                if (!mounted) return;

                if (laporanBerhasil == true) {
                  Navigator.pop(context, true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 4, shadowColor: const Color(0xFF2563EB).withOpacity(0.3),
              ),
              child: const Text('Lanjutkan Upload Foto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfilContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('Halaman Profil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 8),
          Text('Informasi pengguna', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          // Kembali ke Dashboard sebelumnya
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          return;
        }

        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF), size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: isActive ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF), fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildNavCenterItem() {
    return GestureDetector(
      onTap: () { setState(() { _currentIndex = 2; }); },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: const Color(0xFF2563EB), shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 4),
          const Text('Buat Laporan', style: TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }
}

// ============================================================
// SCREEN 2: PILIH KATEGORI
// ============================================================
class PilihKategoriScreen extends StatefulWidget {
  final String selectedKategori;
  const PilihKategoriScreen({super.key, required this.selectedKategori});

  @override
  State<PilihKategoriScreen> createState() => _PilihKategoriScreenState();
}

class _PilihKategoriScreenState extends State<PilihKategoriScreen> {
  late String selectedKategori;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allCategories = [
    {'name': 'Listrik', 'subtitle': 'Lampu, saklar,...', 'icon': Icons.bolt, 'iconBg': const Color(0xFFFFF7ED), 'iconColor': const Color(0xFFF59E0B)},
    {'name': 'AC', 'subtitle': 'Pendingin...', 'icon': Icons.air, 'iconBg': const Color(0xFFEFF6FF), 'iconColor': const Color(0xFF2563EB)},
    {'name': 'Meja/Kursi', 'subtitle': 'Kursi kuliah,...', 'icon': Icons.chair, 'iconBg': const Color(0xFFECFDF5), 'iconColor': const Color(0xFF10B981)},
    {'name': 'Toilet', 'subtitle': 'Kran air,...', 'icon': Icons.bathtub_outlined, 'iconBg': const Color(0xFFECFEFF), 'iconColor': const Color(0xFF06B6D4)},
    {'name': 'Kebersihan', 'subtitle': 'Sampah, lumut...', 'icon': Icons.auto_awesome, 'iconBg': const Color(0xFFF5F3FF), 'iconColor': const Color(0xFF8B5CF6)},
    {'name': 'Fasilitas Lainnya', 'subtitle': 'Pintu, jendela,...', 'icon': Icons.build, 'iconBg': const Color(0xFFFEE2E2), 'iconColor': const Color(0xFFEF4444)},
  ];

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchQuery.isEmpty) return _allCategories;
    return _allCategories.where((category) {
      final name = category['name'].toString().toLowerCase();
      final subtitle = category['subtitle'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || subtitle.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    selectedKategori = widget.selectedKategori;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), shape: BoxShape.circle), child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1F2937), size: 20))),
                  const SizedBox(width: 12),
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Pilih Kategori', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))), SizedBox(height: 2), Text('Langkah 1 dari 3', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)))]),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity, height: 48, padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[400], size: 20),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: _searchController, onChanged: (value) { setState(() { _searchQuery = value; }); }, decoration: const InputDecoration(hintText: 'Cari jenis fasilitas...', hintStyle: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero))),
                    if (_searchQuery.isNotEmpty) GestureDetector(onTap: () { _searchController.clear(); setState(() { _searchQuery = ''; }); }, child: Icon(Icons.clear, color: Colors.grey[400], size: 20)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    if (_filteredCategories.isEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Column(children: [Icon(Icons.search_off, size: 48, color: Colors.grey[400]), const SizedBox(height: 12), Text('Tidak ada kategori ditemukan', style: TextStyle(fontSize: 14, color: Colors.grey[500])), const SizedBox(height: 4), Text('Coba kata kunci lain', style: TextStyle(fontSize: 12, color: Colors.grey[400]))])),
                    GridView.builder(
                      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 1.15),
                      itemCount: _filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = _filteredCategories[index];
                        final isSelected = selectedKategori == category['name'];
                        return GestureDetector(
                          onTap: () { setState(() { selectedKategori = category['name']; }); },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB), width: isSelected ? 2 : 1), boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))] : null),
                            child: Stack(
                              children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Container(width: 52, height: 52, decoration: BoxDecoration(color: category['iconBg'], borderRadius: BorderRadius.circular(12)), child: Icon(category['icon'], color: category['iconColor'], size: 26)),
                                  const Spacer(),
                                  Text(category['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                                  const SizedBox(height: 2),
                                  Text(category['subtitle'], style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                                ]),
                                if (isSelected) Positioned(top: 0, right: 0, child: Container(width: 24, height: 24, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF2563EB), width: 2)), child: const Icon(Icons.check, color: Color(0xFF2563EB), size: 14))),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('Kategori dipilih:', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFBFDBFE), width: 1)), child: Text(selectedKategori, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)))),
                      ]),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () { Navigator.pop(context, selectedKategori); },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 4, shadowColor: const Color(0xFF2563EB).withOpacity(0.3)),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Pilih Kategori', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), SizedBox(width: 8), Icon(Icons.check, size: 20)]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// ============================================================
// SCREEN 3: PILIH LOKASI
// ============================================================
class PilihLokasiScreen extends StatefulWidget {
  final String selectedLokasi;
  const PilihLokasiScreen({super.key, required this.selectedLokasi});

  @override
  State<PilihLokasiScreen> createState() => _PilihLokasiScreenState();
}

class _PilihLokasiScreenState extends State<PilihLokasiScreen> {
  late String selectedLokasi;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _allLokasi = ['JT1', 'JT2', 'JT3', 'JT4', 'JT5', 'JT6', 'JT7', 'JT8', 'LAB RPL', 'LAB JAR', 'Ruang Dosen', 'Aula'];

  List<String> get _filteredLokasi {
    if (_searchQuery.isEmpty) return _allLokasi;
    return _allLokasi.where((lokasi) => lokasi.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  void initState() {
    super.initState();
    selectedLokasi = widget.selectedLokasi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), shape: BoxShape.circle), child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1F2937), size: 20))),
                  const SizedBox(width: 12),
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Pilih Lokasi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))), SizedBox(height: 2), Text('Langkah 2 dari 3', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)))]),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity, padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFBFDBFE), width: 1)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          const Icon(Icons.account_balance, color: Color(0xFF2563EB), size: 20),
                          const SizedBox(width: 8),
                          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('AREA KAMPUS III', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB), letterSpacing: 0.5)), Text('UNKHAIR JATI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827)))])),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(20)), child: const Text('Khusus\nKampus III', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold, height: 1.3), textAlign: TextAlign.center)),
                        ]),
                        const SizedBox(height: 12),
                        Row(children: [
                          const Text('Lokasi Terpilih:', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                          const SizedBox(width: 8),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 16), const SizedBox(width: 4), Text(selectedLokasi, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827)))])),
                        ]),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity, height: 48, padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey[400], size: 20),
                          const SizedBox(width: 10),
                          Expanded(child: TextField(controller: _searchController, onChanged: (value) { setState(() { _searchQuery = value; }); }, decoration: const InputDecoration(hintText: 'Cari lokasi di Kampus III...', hintStyle: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero))),
                          if (_searchQuery.isNotEmpty) GestureDetector(onTap: () { _searchController.clear(); setState(() { _searchQuery = ''; }); }, child: Icon(Icons.clear, color: Colors.grey[400], size: 20)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Expanded(child: Text('Pilihan Lokasi Kampus III (${_filteredLokasi.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)))),
                      Text('Pilih salah\nsatu', style: TextStyle(fontSize: 12, color: Colors.grey[500], height: 1.3), textAlign: TextAlign.right),
                    ]),
                    const SizedBox(height: 12),
                    if (_filteredLokasi.isEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Column(children: [Icon(Icons.search_off, size: 48, color: Colors.grey[400]), const SizedBox(height: 12), Text('Tidak ada lokasi ditemukan', style: TextStyle(fontSize: 14, color: Colors.grey[500])), const SizedBox(height: 4), Text('Coba kata kunci lain', style: TextStyle(fontSize: 12, color: Colors.grey[400]))])),
                    ..._filteredLokasi.map((lokasi) {
                      final isSelected = selectedLokasi == lokasi;
                      return GestureDetector(
                        onTap: () { setState(() { selectedLokasi = lokasi; }); },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB), width: 1)),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_outlined, color: isSelected ? const Color(0xFF2563EB) : Colors.grey[400], size: 22),
                              const SizedBox(width: 12),
                              Expanded(child: Text(lokasi, style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: const Color(0xFF111827)))),
                              Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFD1D5DB), width: 2), color: isSelected ? const Color(0xFF2563EB) : Colors.white), child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () { Navigator.pop(context, {'lokasi': selectedLokasi, 'sub': 'Kampus III Unkhair Jati'}); },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 4, shadowColor: const Color(0xFF2563EB).withOpacity(0.3)),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Lanjut ke Deskripsi & Foto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 20)]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// ============================================================
// SCREEN 4: DESKRIPSI & FOTO
// ============================================================
class DeskripsiFotoScreen extends StatefulWidget {
  final String judul;
  final String kategori;
  final String lokasi;
  final String deskripsiAwal;

  const DeskripsiFotoScreen({
    super.key,
    required this.judul,
    required this.kategori,
    required this.lokasi,
    required this.deskripsiAwal,
  });

  @override
  State<DeskripsiFotoScreen> createState() =>
      _DeskripsiFotoScreenState();
}

class _DeskripsiFotoScreenState extends State<DeskripsiFotoScreen> {
  final LaporanService laporanService = LaporanService();

  bool isLoading = false;

  Future<void> kirimLaporan() async {
    if (isLoading) return;

    final judul = widget.judul.trim();
    final deskripsi = _deskripsiController.text.trim();

    if (judul.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul laporan harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (deskripsi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deskripsi permasalahan harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (fotoBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan lampirkan foto kerusakan.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final idKategori =
          await laporanService.getIdKategori(widget.kategori);

      final idLaporan = await submitLaporanService.submit(
        judul: judul,
        idKategori: idKategori,
        lokasi: widget.lokasi,
        deskripsi: deskripsi,
        foto: fotoBytes!,
        namaFile: fotoName ?? 'foto_laporan.jpg',
      );

      if (!mounted) return;

      // Buka halaman berhasil tanpa mengganti halaman ini
      await Navigator.push<bool>(
        context,
        MaterialPageRoute<bool>(
          builder: (context) => LaporanBerhasilScreen(
            idLaporan: idLaporan,
            nomorTiket: '#CR-$idLaporan',
            kategori: widget.kategori,
            lokasi: widget.lokasi,
            waktu: DateTime.now().toLocal().toString(),
          ),
        ),
      );

      if (!mounted) return;

      // Laporan sudah tersimpan, teruskan true ke BuatLaporanScreen
      Navigator.pop(context, true);

    } catch (e) {
      if (!mounted) return;

      debugPrint('Error kirim laporan: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengirim laporan. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  
  late final TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();

    _deskripsiController = TextEditingController(
      text: widget.deskripsiAwal,
    );
  }
  
  
  bool fotoUploaded = false;
  Uint8List? fotoBytes;
  String? fotoName;
  ImageSource? sumberFotoTerpilih;
  String? fotoSize;
  String? fotoTimestamp;

  final ImagePicker _imagePicker = ImagePicker();
  CameraController? _cameraController;
  bool _kameraSiap = false;
  bool _sedangMengambilFoto = false;
  final SubmitLaporanService submitLaporanService =
      SubmitLaporanService();

  @override
  Widget build(BuildContext context) {
    final bool kameraTerpilih =
        sumberFotoTerpilih == ImageSource.camera;

    final bool galeriTerpilih =
        sumberFotoTerpilih == ImageSource.gallery;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1F2937), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Deskripsi & Foto', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      SizedBox(height: 2),
                      Text('Langkah 3 dari 3', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Card Kategori
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Kategori:', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFBFDBFE), width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.filter_list, color: Color(0xFF2563EB), size: 16),
                                const SizedBox(width: 4),
                                Text(widget.kategori, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 2. Card Lokasi
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Lokasi:', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 18),
                              const SizedBox(width: 4),
                              Text(widget.lokasi, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Deskripsi Permasalahan
                    const Text(
                      'Deskripsi Permasalahan *',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 140),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: Stack(
                        children: [
                          TextField(
                            controller: _deskripsiController,
                            maxLines: null,
                            maxLength: 500,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(right: 30),
                              hintText: 'Tuliskan deskripsi kerusakan...',
                              hintStyle: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                              counterText: '',
                            ),
                            style: const TextStyle(fontSize: 14, color: Color(0xFF374151), height: 1.6),
                            onChanged: (_) => setState(() {}),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(Icons.edit, color: Colors.grey[400], size: 18),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${_deskripsiController.text.length}/500 karakter',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. Lampirkan Foto Bukti
                    const Text(
                      'Lampirkan Foto Bukti Kerusakan *',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                    ),
                    const SizedBox(height: 12),
                    
                    // Dua Tombol: Ambil Foto & Pilih dari Galeri
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _ambilFoto,
                            child: Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                              color: kameraTerpilih
                                  ? const Color(0xFFEFF6FF)
                                  : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: kameraTerpilih
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFFE5E7EB),
                                width: kameraTerpilih ? 2 : 1,
                              ),
                            ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 28, height: 28,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                                    child: const Icon(Icons.camera_alt, color: Color(0xFF2563EB), size: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  const Flexible(
                                    child: Text('Ambil Foto', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)), textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: _pilihDariGaleri,
                            child: Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                              color: galeriTerpilih
                                  ? const Color(0xFFEFF6FF)
                                  : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: galeriTerpilih
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFFE5E7EB),
                                width: galeriTerpilih ? 2 : 1,
                              ),
                            ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 28, height: 28,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)),
                                    child: Icon(Icons.image_outlined, color: Colors.grey[600], size: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text('Pilih dari Galeri', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[700]), textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 5. Preview Foto
                    if (fotoUploaded)
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                fotoBytes!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),

                            // badge timestamp di pojok kiri bawah
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  fotoTimestamp ?? '',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ), 
                            ),

                            // Tombol hapus (X Merah) di pojok kanan atas
                            Positioned(
                              top: 12, right: 12,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    fotoUploaded = false;
                                    fotoBytes = null;
                                    fotoName = null;
                                    fotoSize = null;
                                    fotoTimestamp = null;
                                  });
                                },
                                child: Container(
                                  width: 32, height: 32,
                                  decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // 6. Tombol Kirim Laporan
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  // ✅ DIPERBARUI: Navigasi ke halaman Laporan Berhasil
                  onPressed: isLoading ? null : kirimLaporan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                    shadowColor: const Color(0xFF2563EB).withOpacity(0.3),
                  ),
                  child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Kirim Laporan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _ambilFoto() async {
    if (_sedangMengambilFoto) return;

    setState(() {
      _sedangMengambilFoto = true;
    });

    CameraController? controller;

    try {
      final cameras = await availableCameras();
      debugPrint('Daftar kamera: $cameras');

      if (cameras.isEmpty) {
        throw Exception('Kamera tidak ditemukan.');
      }

      // Gunakan kamera yang terdeteksi oleh perangkat.
      final kamera = cameras.first;

      controller = CameraController(
        kamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) return;

      _cameraController = controller;
      _kameraSiap = true;

      final hasil = await Navigator.push<XFile>(
        context,
        MaterialPageRoute<XFile>(
          builder: (cameraContext) => Scaffold(
            appBar: AppBar(
              title: const Text('Ambil Foto'),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Center(
                    child: CameraPreview(controller!),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        if (!controller!.value.isInitialized ||
                            controller.value.isTakingPicture) {
                          return;
                        }

                        final foto =
                            await controller.takePicture();

                        if (cameraContext.mounted) {
                          Navigator.pop(cameraContext, foto);
                        }
                      } catch (e) {
                        debugPrint('Gagal mengambil foto: $e');

                        if (cameraContext.mounted) {
                          ScaffoldMessenger.of(cameraContext)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                'Gagal mengambil foto: $e',
                              ),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Ambil Foto'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      if (hasil == null || !mounted) return;

      final bytes = await hasil.readAsBytes();

      if (bytes.length > 5 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ukuran foto maksimal 5 MB.'),
          ),
        );
        return;
      }

      setState(() {
        fotoBytes = bytes;
        fotoUploaded = true;
        sumberFotoTerpilih = ImageSource.camera;
        fotoName = hasil.name;
        fotoSize =
            '${(bytes.lengthInBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
        fotoTimestamp =
            DateTime.now().toString().substring(0, 16);
      });
    } catch (e, stackTrace) {
      debugPrint('Gagal membuka kamera: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kamera gagal dibuka: $e'),
          ),
        );
      }
    } finally {
      await controller?.dispose();

      if (identical(_cameraController, controller)) {
        _cameraController = null;
      }

      if (mounted) {
        setState(() {
          _kameraSiap = false;
          _sedangMengambilFoto = false;
        });
      }
    }
  }

  Future<void> _pilihDariGaleri() async {
    await _pilihFoto(ImageSource.gallery);
  }

  Future<void> _pilihFoto(ImageSource source) async {
    try {
      final XFile? hasil = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (hasil == null) return;

      final bytes = await hasil.readAsBytes();

      if (bytes.length > 5 * 1024 * 1024) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ukuran foto maksimal 5 MB.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!mounted) return;

      setState(() {
        fotoBytes = bytes;
        fotoUploaded = true;
        sumberFotoTerpilih = source;
        fotoName = hasil.name;
        fotoSize =
            '${(bytes.lengthInBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
        fotoTimestamp = DateTime.now().toString().substring(0, 16);
      });
    } catch (e) {
      debugPrint('Gagal memilih foto: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil foto. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _deskripsiController.dispose();
    super.dispose();
  }
}

// ============================================================
// SCREEN 5: LAPORAN BERHASIL DIKIRIM (DESAIN BARU DITAMBAHKAN DI SINI)
// ============================================================
class LaporanBerhasilScreen extends StatelessWidget {
  final int idLaporan;
  final String nomorTiket;
  final String kategori;
  final String lokasi;
  final String waktu;

  const LaporanBerhasilScreen({
    super.key,
    required this.idLaporan,
    required this.nomorTiket,
    required this.kategori,
    required this.lokasi,
    required this.waktu,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // Icon Check Hijau Besar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF059669),
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),

              // Judul
              const Text(
                'Laporan Berhasil Dikirim!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'Terima kasih atas kepedulian Anda terhadap fasilitas kampus Universitas Khairun.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Card Nomor Tiket
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nomor Tiket:',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          nomorTiket,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nomor tiket disalin!'),
                            backgroundColor: Color(0xFF10B981),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                        ),
                        child: const Icon(
                          Icons.copy,
                          color: Color(0xFF6B7280),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card Ringkasan Laporan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ringkasan Laporan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFFCD34D),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Status: Diajukan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.category_outlined, color: Color(0xFF6B7280), size: 18),
                        const SizedBox(width: 8),
                        const Text('Kategori:', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                        const Spacer(),
                        Text(kategori, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Color(0xFF6B7280), size: 18),
                        const SizedBox(width: 8),
                        const Text('Lokasi:', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                        const Spacer(),
                        Text(lokasi, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Color(0xFF6B7280), size: 18),
                        const SizedBox(width: 8),
                        const Text('Waktu:', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                        const Spacer(),
                        Text(waktu, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFCD34D), width: 1),
                      ),
                      child: const Text(
                        'Laporan Anda segera diverifikasi oleh Administrator Biro Sarana Prasarana sebelum ditugaskan ke teknisi.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF92400E),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Lihat Detail Laporan
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final data = await LaporanService()
                          .getDetailLaporan(idLaporan);

                      if (!context.mounted) return;

                      final laporan = LaporanModel(
                        idLaporan: idLaporan,
                        lokasi: data['lokasi']?.toString() ?? lokasi,
                        deskripsi:
                            data['lpr_deskripsi']?.toString() ?? '',
                        status: data['status']?.toString() ?? 'Diajukan',
                        waktuDibuat: DateTime.tryParse(
                              data['lpr_waktu_dibuat']?.toString() ?? '',
                            ) ??
                            DateTime.now(),
                        namaPelapor:
                            data['nama_pelapor']?.toString() ??
                                'Tidak diketahui',
                      );

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailLaporanPage(
                            laporan: laporan,
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Gagal membuka detail laporan. Silakan coba lagi.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );

                      debugPrint('Gagal membuka detail laporan: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                    shadowColor: const Color(0xFF2563EB).withOpacity(0.3),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.description, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Lihat Detail Laporan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tombol Kembali ke Beranda
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF111827),
                    side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_outlined, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Kembali ke Beranda',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
