import 'laporan_model.dart';

class LaporanItem {
  final int idLaporan;
  final String id;
  final String title;
  final String category;
  final String status;
  final String dayName;
  final String dateOnly;
  final LaporanModel laporan;

  const LaporanItem({
    required this.idLaporan,
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.dayName,
    required this.dateOnly,
    required this.laporan,
  });
}
