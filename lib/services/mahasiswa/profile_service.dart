
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    // 1. Mengambil data pengguna yang sedang login.
    final pengguna = await supabase
        .from('pengguna')
        .select('id_pengguna, nama_pengguna, email')
        .eq('auth_id', user.id)
        .single();

    final idPengguna = pengguna['id_pengguna'];

    // 2. Mengambil seluruh status laporan milik pengguna.
    final laporan = await supabase
        .from('laporan')
        .select('id_laporan, status')
        .eq('id_pengguna', idPengguna);

    // 3. Menghitung statistik laporan.
    final totalLaporan = laporan.length;

    final totalSelesai = laporan.where((item) {
      return item['status']?.toString().toLowerCase() ==
          'selesai';
    }).length;

    return {
      'nama_pengguna':
          pengguna['nama_pengguna']?.toString() ?? 'Mahasiswa',
      'email':
          user.email ?? pengguna['email']?.toString() ?? '-',
      'total_laporan': totalLaporan,
      'total_selesai': totalSelesai,
      'status_akun': 'Aktif',
    };
  }
}
