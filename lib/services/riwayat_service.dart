
import 'package:supabase_flutter/supabase_flutter.dart';

class RiwayatService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getRiwayatLaporan() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    final pengguna = await supabase
        .from('pengguna')
        .select('id_pengguna')
        .eq('auth_id', user.id)
        .single();

    final idPengguna = pengguna['id_pengguna'] as int;

    final data = await supabase
        .from('laporan')
        .select('''
          id_laporan,
          id_pengguna,
          id_kategori,
          judul,
          lokasi,
          lpr_deskripsi,
          status,
          lpr_waktu_dibuat,
          kategori (
            nama_kategori
          ),
          pengguna (
            nama_pengguna
          )
        ''')
        .eq('id_pengguna', idPengguna)
        .order('lpr_waktu_dibuat', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }
}
