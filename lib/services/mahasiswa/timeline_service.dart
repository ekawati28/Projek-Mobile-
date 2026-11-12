
import 'package:supabase_flutter/supabase_flutter.dart';

class TimelineService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getDetailLaporan(
    int idLaporan,
  ) async {
    final data = await supabase
        .from('laporan')
        .select('''
          id_laporan,
          judul,
          id_kategori,
          lokasi,
          lpr_deskripsi,
          status,
          lpr_waktu_dibuat
        ''')
        .eq('id_laporan', idLaporan)
        .single();

    return data;
  }

  
  Future<List<Map<String, dynamic>>> getRiwayatLaporan(
    int idLaporan,
  ) async {
    final data = await supabase
        .from('riwayat')
        .select('''
          id_riwayat,
          id_laporan,
          id_pengguna,
          status,
          catatan,
          rwyt_waktu_dibuat
        ''')
        .eq('id_laporan', idLaporan)
        .order('rwyt_waktu_dibuat', ascending: true);

    return List<Map<String, dynamic>>.from(data);
  }

}
