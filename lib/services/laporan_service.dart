import 'package:supabase_flutter/supabase_flutter.dart';


class LaporanService {

  final SupabaseClient supabase = Supabase.instance.client;

  Future<int> getIdKategori(String namaKategori) async {
    final kategori = await supabase
        .from('kategori')
        .select('id_kategori')
        .eq('nama_kategori', namaKategori)
        .single();

    return kategori['id_kategori'] as int;
  }

  Future<int> buatLaporan({
    required String judul,
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

          'judul': judul,

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

  // Mengambil detail laporan berdasarkan ID laporan.
  Future<Map<String, dynamic>> getDetailLaporan(
    int idLaporan,
  ) async {
    final data = await supabase
        .from('laporan')
        .select()
        .eq('id_laporan', idLaporan)
        .single();

    final detail = Map<String, dynamic>.from(data);

    // Mengambil nama kategori jika kolomnya tersedia.
    final idKategori = detail['id_kategori'];

    try {
      if (idKategori != null) {
        final kategori = await supabase
            .from('kategori')
            .select('nama_kategori')
            .eq('id_kategori', idKategori)
            .maybeSingle();

        detail['nama_kategori'] =
            kategori?['nama_kategori'];
      }
    } catch (_) {
      // Detail laporan tetap dapat ditampilkan
      // jika informasi kategori gagal diambil.
    }

    // Mengambil nama pelapor.
    final idPengguna = detail['id_pengguna'];

    try {
      if (idPengguna != null) {
        final pengguna = await supabase
            .from('pengguna')
            .select('nama_pengguna')
            .eq('id_pengguna', idPengguna)
            .maybeSingle();

        detail['nama_pelapor'] =
            pengguna?['nama_pengguna'];
      }
    } catch (_) {
      // Nama pelapor akan menggunakan teks cadangan.
    }

    return detail;
  }
  
  Future<Map<String, dynamic>?> getPenugasan(
    int idLaporan,
  ) async {
    final data = await supabase
        .from('penugasan')
        .select('''
          id_penugasan,
          id_laporan,
          id_petugas,
          waktu_penugasan
        ''')
        .eq('id_laporan', idLaporan)
        .order('waktu_penugasan', ascending: false)
        .limit(1)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    final penugasan = Map<String, dynamic>.from(data);

    final petugas = await supabase
        .from('pengguna')
        .select('nama_pengguna')
        .eq('id_pengguna', penugasan['id_petugas'])
        .maybeSingle();

    penugasan['nama_petugas'] =
        petugas?['nama_pengguna'] ?? 'Petugas';

    return penugasan;
  } 

}