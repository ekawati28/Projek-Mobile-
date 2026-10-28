import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class FotoService {

  final SupabaseClient supabase = Supabase.instance.client;

  Future<String> uploadFoto({
    required Uint8List file,
    required int idLaporan,
    required String namaFile,

  }) async {

    final path = 'laporan_$idLaporan/$namaFile';

    await supabase
        .storage
        .from('foto-laporan')
        .uploadBinary(
          path,
          file,
        );
    return path;
  }

  Future<void> simpanFotoDatabase({
  required int idLaporan,
  required String pathFoto,

  }) async {

  await supabase
      .from('foto')
      .insert({
        'id_laporan':
            idLaporan,

        'path_foto':
            pathFoto,
      });
  }

  String getPublicUrl(String pathFoto){
    return supabase
        .storage
        .from('foto-laporan')
        .getPublicUrl(pathFoto);
  }
  
  Future<String?> getFotoUrlByLaporan(int idLaporan) async {
    final data = await supabase
        .from('foto')
        .select('path_foto')
        .eq('id_laporan', idLaporan)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    final pathFoto = data['path_foto']?.toString();

    if (pathFoto == null || pathFoto.isEmpty) {
      return null;
    }

    // Buat URL sementara yang bisa mengakses file privat.
    final signedUrl = await supabase
        .storage
        .from('foto-laporan')
        .createSignedUrl(pathFoto, 3600);

    return signedUrl;
  }

}