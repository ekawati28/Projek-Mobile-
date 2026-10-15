import 'package:supabase_flutter/supabase_flutter.dart';


class LaporanService {

  final SupabaseClient supabase = Supabase.instance.client;

  Future<int> buatLaporan({

    required int idKategori,
    required String lokasi,
    required String deskripsi,

  }) async {
    final user = supabase.auth.currentUser;

    if(user == null){
      throw Exception(
        "User belum login"
      );
    }
    final pengguna =
        await supabase
            .from('pengguna')
            .select('id_pengguna')
            .eq(
              'auth_id',
              user.id,
            )
            .single();

    final laporan =
    await supabase
        .from('laporan')
        .insert({

          'id_pengguna':
              pengguna['id_pengguna'],

          'id_kategori':
              idKategori,

          'lokasi':
              lokasi,

          'lpr_deskripsi':
              deskripsi,

        })
        .select('id_laporan').single();

        return laporan['id_laporan'];
  }

}