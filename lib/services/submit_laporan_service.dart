import 'dart:typed_data';

import 'laporan_service.dart';
import 'foto_service.dart';

class SubmitLaporanService {
  final LaporanService laporanService = LaporanService();

  final FotoService fotoService = FotoService();

  Future<void> submit({
    required String judul,
    required int idKategori,
    required String lokasi,
    required String deskripsi,
    required Uint8List foto,
    required String namaFile,

  }) async {

    // 1. Buat laporan dulu
    final idLaporan =
        await laporanService.buatLaporan(
          judul: judul,
          idKategori: idKategori,
          lokasi: lokasi,
          deskripsi: deskripsi,
        );

    // 2. Upload foto ke storage
    final pathFoto =
        await fotoService.uploadFoto(
          file: foto,
          idLaporan: idLaporan,
          namaFile: namaFile,
        );

    // 3. Simpan path foto ke database
    await fotoService.simpanFotoDatabase(
      idLaporan: idLaporan,
      pathFoto: pathFoto,
    );
  }
}