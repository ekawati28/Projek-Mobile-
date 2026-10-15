class LaporanModel {

  final int idLaporan;
  final String lokasi;
  final String deskripsi;
  final String status;
  final DateTime waktuDibuat;

  LaporanModel({
    required this.idLaporan,
    required this.lokasi,
    required this.deskripsi,
    required this.status,
    required this.waktuDibuat,

  });

  factory LaporanModel.fromJson(
      Map<String,dynamic> json
  ){

  return LaporanModel(

    idLaporan:
    json['id_laporan'],

    lokasi:
    json['lokasi'],

    deskripsi:
    json['lpr_deskripsi'],

    status:
    json['status'],

    waktuDibuat:
      DateTime.parse(
      json['lpr_waktu_dibuat']
      ),
    );
  }

}