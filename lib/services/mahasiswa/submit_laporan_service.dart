
import 'dart:typed_data';

import 'laporan_service.dart';
import 'foto_service.dart';

class SubmitLaporanService {
  final LaporanService laporanService = LaporanService();
  final FotoService fotoService = FotoService();

  Future<int> submit({
    required String judul,
    required int idKategori,
    required String lokasi,
    required String deskripsi,
    required Uint8List foto,
    required String namaFile,
  }) async {
    // 1. Buat laporan dan dapatkan ID-nya.
    final idLaporan = await laporanService.buatLaporan(
      judul: judul,
      idKategori: idKategori,
      lokasi: lokasi,
      deskripsi: deskripsi,
    );

    // 2. Upload foto ke Supabase Storage.
    final pathFoto = await fotoService.uploadFoto(
      file: foto,
      idLaporan: idLaporan,
      namaFile: namaFile,
    );

    // 3. Simpan lokasi foto ke tabel foto.
    await fotoService.simpanFotoDatabase(
      idLaporan: idLaporan,
      pathFoto: pathFoto,
    );

    // 4. Kembalikan ID untuk halaman berikutnya.
    return idLaporan;
  }
}
