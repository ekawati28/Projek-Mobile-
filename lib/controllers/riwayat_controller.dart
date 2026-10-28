
import '../models/laporan_item_model.dart';
import '../models/laporan_model.dart';
import '../services/riwayat_service.dart';

class RiwayatController {
  final RiwayatService riwayatService = RiwayatService();

  Future<List<LaporanItem>> getRiwayatLaporan() async {
    final data = await riwayatService.getRiwayatLaporan();

    return data.map((json) {
      final tanggal = DateTime.tryParse(
        json['lpr_waktu_dibuat']?.toString() ?? '',
      )?.toLocal();

      const namaBulan = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
      ];

      const namaHari = [
        'Sen', 'Sel', 'Rab', 'Kam',
        'Jum', 'Sab', 'Min',
      ];

      final dataKategori = json['kategori'];
      final namaKategori = dataKategori is Map
          ? dataKategori['nama_kategori']?.toString() ?? '-'
          : '-';

      final judul = json['judul']?.toString().trim() ?? '';
      final deskripsi =
          json['lpr_deskripsi']?.toString() ?? '-';

      final idLaporan = json['id_laporan'] as int;

      final laporanModel = LaporanModel.fromJson(json);

      return LaporanItem(
        idLaporan: idLaporan,
        id: '#CR-$idLaporan',
        title: judul.isNotEmpty ? judul : deskripsi,
        category: namaKategori,
        status: json['status']?.toString() ?? 'Diajukan',
        dayName: tanggal != null
            ? namaHari[tanggal.weekday - 1]
            : '-',
        dateOnly: tanggal != null
            ? '${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}'
            : '-',
        laporan: laporanModel,
      );
    }).toList();
  }

  List<LaporanItem> filterLaporan({
    required List<LaporanItem> laporan,
    required String status,
    required String pencarian,
  }) {
    final keyword = pencarian.trim().toLowerCase();

    return laporan.where((item) {
      final cocokStatus =
          status == 'Semua' || item.status == status;

      final cocokPencarian =
          item.title.toLowerCase().contains(keyword) ||
          item.id.toLowerCase().contains(keyword) ||
          item.category.toLowerCase().contains(keyword);

      return cocokStatus && cocokPencarian;
    }).toList();
  }

  int hitungStatus(
    List<LaporanItem> laporan,
    String status,
  ) {
    if (status == 'Semua') {
      return laporan.length;
    }

    return laporan.where((item) {
      return item.status == status;
    }).length;
  }
}
