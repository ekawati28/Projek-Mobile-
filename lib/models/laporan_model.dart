class LaporanModel {
  final int idLaporan;
  final String lokasi;
  final String deskripsi;
  final String status;
  final DateTime waktuDibuat;
  final String namaPelapor;

  LaporanModel({
    required this.idLaporan,
    required this.lokasi,
    required this.deskripsi,
    required this.status,
    required this.waktuDibuat,
    required this.namaPelapor,
  });

  factory LaporanModel.fromJson(Map<String, dynamic> json) {
    return LaporanModel(
      idLaporan: json['id_laporan'] as int,
      lokasi: json['lokasi'] as String,
      deskripsi: json['lpr_deskripsi'] as String,
      status: json['status'] as String,
      waktuDibuat: DateTime.parse(
        json['lpr_waktu_dibuat'] as String,
      ),
      namaPelapor: json['pengguna']?['nama_pengguna'] ?? 'Tidak diketahui',
    );
  }
}