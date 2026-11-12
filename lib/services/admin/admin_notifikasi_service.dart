
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminNotifikasiService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Mengambil ID Admin yang sedang login.
  Future<int> getIdAdmin() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Admin belum login.');
    }

    final pengguna = await supabase
        .from('pengguna')
        .select('id_pengguna, role')
        .eq('auth_id', user.id)
        .maybeSingle();

    if (pengguna == null || pengguna['role'] != 'admin') {
      throw Exception('Akses ditolak. Khusus Admin.');
    }

    return (pengguna['id_pengguna'] as num).toInt();
  }

  // Mengambil seluruh notifikasi Admin.
  Future<List<Map<String, dynamic>>> getDaftarNotifikasi() async {
    final idAdmin = await getIdAdmin();

    final data = await supabase
        .from('notifikasi')
        .select()
        .eq('id_pengguna', idAdmin)
        .order('not_waktu_dibuat', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  // Menghitung notifikasi belum dibaca.
  Future<int> getJumlahBelumDibaca() async {
    final idAdmin = await getIdAdmin();

    final data = await supabase
        .from('notifikasi')
        .select('id_notifikasi')
        .eq('id_pengguna', idAdmin)
        .eq('baca', false);

    return data.length;
  }

  // Menandai satu notifikasi sudah dibaca.
  Future<void> tandaiDibaca(int idNotifikasi) async {
    final idAdmin = await getIdAdmin();

    await supabase
        .from('notifikasi')
        .update({'baca': true})
        .eq('id_notifikasi', idNotifikasi)
        .eq('id_pengguna', idAdmin)
        .eq('baca', false);
  }

  // Menandai semua notifikasi sudah dibaca.
  Future<void> tandaiSemuaDibaca() async {
    final idAdmin = await getIdAdmin();

    await supabase
        .from('notifikasi')
        .update({'baca': true})
        .eq('id_pengguna', idAdmin)
        .eq('baca', false);
  }
}
