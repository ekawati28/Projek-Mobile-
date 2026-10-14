import 'laporan_model.dart';

class DashboardModel {

  final String namaPengguna;

  final int diajukan;
  final int diverifikasi;
  final int diproses;
  final int selesai;

  final List<LaporanModel> laporanTerbaru;
  DashboardModel({

    required this.namaPengguna,

    required this.diajukan,
    required this.diverifikasi,
    required this.diproses,
    required this.selesai,

    required this.laporanTerbaru,
  });


}