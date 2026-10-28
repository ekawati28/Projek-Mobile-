
import 'package:flutter/material.dart';

import '../../controllers/riwayat_controller.dart';
import '../../models/laporan_item_model.dart';
import '../../widgets/bottom_navbar.dart';
import 'detail_laporan_page.dart';

class RiwayatLaporanScreen extends StatefulWidget {
  final ValueChanged<int>? onNavTap;

  const RiwayatLaporanScreen({
    super.key,
    this.onNavTap,
  });

  @override
  State<RiwayatLaporanScreen> createState() =>
      _RiwayatLaporanScreenState();
}

class _RiwayatLaporanScreenState
    extends State<RiwayatLaporanScreen> {
  final RiwayatController riwayatController =
      RiwayatController();

  late Future<List<LaporanItem>> riwayatFuture;

  String _activeTab = 'Semua';
  String _searchQuery = '';

  final List<String> _tabs = [
    'Semua',
    'Diajukan',
    'Diverifikasi',
    'Diproses',
    'Selesai',
  ];

  @override
  void initState() {
    super.initState();
    _muatRiwayat();
  }

  void _muatRiwayat() {
    riwayatFuture =
        riwayatController.getRiwayatLaporan();
  }

  Future<void> _refreshRiwayat() async {
    setState(() {
      _muatRiwayat();
    });

    try {
      await riwayatFuture;
    } catch (_) {
      // Pesan kegagalan ditampilkan FutureBuilder.
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Diajukan':
        return const Color(0xFFFEF3C7);
      case 'Diverifikasi':
        return const Color(0xFFDBEAFE);
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
      case 'Diverifikasi':
        return const Color(0xFF1D4ED8);
      case 'Diproses':
        return const Color(0xFF7E22CE);
      case 'Selesai':
        return const Color(0xFF15803D);
      default:
        return Colors.grey.shade700;
    }
  }

  void _bukaDetail(LaporanItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailLaporanPage(
          laporan: item.laporan,
        ),
      ),
    ).then((_) {
      if (mounted) {
        _refreshRiwayat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: SafeArea(
        child: FutureBuilder<List<LaporanItem>>(
          future: riwayatFuture,
          builder: (context, snapshot) {
            final semuaLaporan =
                snapshot.data ?? <LaporanItem>[];

            final daftar = riwayatController.filterLaporan(
              laporan: semuaLaporan,
              status: _activeTab,
              pencarian: _searchQuery,
            );

            return Column(
              children: [
                // HEADER DAN FILTER
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black87,
                              ),
                              onPressed: () {
                                if (widget.onNavTap != null) {
                                  widget.onNavTap!(0);
                                } else {
                                  Navigator.maybePop(context);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
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
                                  'Daftar laporan fasilitas yang pernah kamu buat.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // PENCARIAN
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius:
                              BorderRadius.circular(24),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Cari laporan...',
                            hintStyle: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF94A3B8),
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // FILTER STATUS
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _tabs.map((status) {
                            final isSelected =
                                _activeTab == status;

                            final count =
                                riwayatController.hitungStatus(
                              semuaLaporan,
                              status,
                            );

                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                              ),
                              child: ChoiceChip(
                                selected: isSelected,
                                selectedColor:
                                    const Color(0xFF2563EB),
                                backgroundColor:
                                    const Color(0xFFF1F5F9),
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  side: BorderSide.none,
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _activeTab = status;
                                    });
                                  }
                                },
                                label: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    Text(
                                      status,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(
                                                0xFF334155,
                                              ),
                                        fontWeight:
                                            FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(
                                                0xFF1D4ED8,
                                              )
                                            : const Color(
                                                0xFFE2E8F0,
                                              ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '$count',
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : const Color(
                                                  0xFF475569,
                                                ),
                                          fontSize: 10,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // DAFTAR LAPORAN
                Expanded(
                  child: _buildKontenRiwayat(
                    snapshot,
                    daftar,
                  ),
                ),
              ],
            );
          },
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          widget.onNavTap?.call(index);
        },
      ),
    );
  }

  Widget _buildKontenRiwayat(
    AsyncSnapshot<List<LaporanItem>> snapshot,
    List<LaporanItem> daftar,
  ) {
    if (snapshot.connectionState ==
        ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 36,
              ),
              const SizedBox(height: 12),
              const Text(
                'Gagal memuat riwayat laporan.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _refreshRiwayat,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (daftar.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isNotEmpty ||
                  _activeTab != 'Semua'
              ? 'Tidak ada laporan yang sesuai.'
              : 'Belum ada laporan.',
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 13,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshRiwayat,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        itemCount: daftar.length,
        itemBuilder: (context, index) {
          final item = daftar[index];
          return _buildKartuLaporan(item);
        },
      ),
    );
  }

  Widget _buildKartuLaporan(LaporanItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF93C5FD),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // IKON LAPORAN
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF0284C7),
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // ID LAPORAN
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFEFF6FF),
                            borderRadius:
                                BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.id,
                            style: const TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),

                        const Spacer(),

                        // STATUS LAPORAN
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusBgColor(
                              item.status,
                            ),
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.status,
                            style: TextStyle(
                              color: _getStatusTextColor(
                                item.status,
                              ),
                              fontWeight:
                                  FontWeight.bold,
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

                    // KATEGORI LAPORAN
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius:
                            BorderRadius.circular(4),
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
          const Divider(
            color: Color(0xFFF1F5F9),
            height: 1,
          ),
          const SizedBox(height: 8),

          // FOOTER KARTU
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 2),
              Text(
                item.dayName,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '•',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 4),
              Text(
                item.dateOnly,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11,
                ),
              ),

              const Spacer(),

              // TOMBOL DETAIL LAPORAN
              InkWell(
                onTap: () => _bukaDetail(item),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lihat Detail',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Color(0xFF2563EB),
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
}
