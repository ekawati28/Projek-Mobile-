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
}