
import 'package:supabase_flutter/supabase_flutter.dart';

class NotifikasiService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Mendapatkan ID pengguna dari akun yang sedang login.
  Future<int> _getIdPengguna() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    final data = await supabase
        .from('pengguna')
        .select('id_pengguna')
        .eq('auth_id', user.id)
        .maybeSingle();

    if (data == null) {
      throw Exception('Data pengguna tidak ditemukan.');
    }

    return (data['id_pengguna'] as num).toInt();
  }

  // Mengambil notifikasi milik pengguna yang sedang login.
  Future<List<Map<String, dynamic>>> getNotifikasi() async {
    final idPengguna = await _getIdPengguna();

    final data = await supabase
        .from('notifikasi')
        .select(
          'id_notifikasi, id_laporan, judul, pesan, '
          'baca, not_waktu_dibuat',
        )
        .eq('id_pengguna', idPengguna)
        .order('not_waktu_dibuat', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  // Menghitung notifikasi yang belum dibaca.
  Future<int> getJumlahBelumDibaca() async {
    final idPengguna = await _getIdPengguna();

    final data = await supabase
        .from('notifikasi')
        .select('id_notifikasi')
        .eq('id_pengguna', idPengguna)
        .eq('baca', false);

    return data.length;
  }

  // Menandai satu notifikasi sebagai sudah dibaca.
  Future<void> tandaiDibaca(int idNotifikasi) async {
    final idPengguna = await _getIdPengguna();

    await supabase
        .from('notifikasi')
        .update({'baca': true})
        .eq('id_notifikasi', idNotifikasi)
        .eq('id_pengguna', idPengguna);
  }
}
