
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminPetugasService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _pastikanAdmin() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Admin belum login.');
    }

    final pengguna = await supabase
        .from('pengguna')
        .select('role')
        .eq('auth_id', user.id)
        .maybeSingle();

    if (pengguna == null || pengguna['role'] != 'admin') {
      throw Exception('Akses ditolak. Khusus Admin.');
    }
  }

  Future<List<Map<String, dynamic>>> getDaftarPetugas() async {
    await _pastikanAdmin();

    // Mengambil akun petugas.
    final data = await supabase
        .from('pengguna')
        .select(
          'id_pengguna, auth_id, nama_pengguna, email, role',
        )
        .eq('role', 'petugas')
        .order('nama_pengguna', ascending: true);

    if (data.isEmpty) return [];

    final idPetugas = data
        .map((item) => item['id_pengguna'])
        .toList();

    // Mengambil detail profil petugas.
    final detail = await supabase
        .from('detail_petugas')
        .select(
          'id_pengguna, jabatan, keahlian, no_telepon',
        )
        .inFilter('id_pengguna', idPetugas);

    final Map<dynamic, Map<String, dynamic>> detailPetugas = {
      for (final item in detail)
        item['id_pengguna']:
            Map<String, dynamic>.from(item),
    };

    // Mengambil penugasan.
    final penugasan = await supabase
        .from('penugasan')
        .select('id_penugasan, id_petugas')
        .inFilter('id_petugas', idPetugas);

    final Map<dynamic, int> jumlahPenugasan = {};

    for (final item in penugasan) {
      final id = item['id_petugas'];

      jumlahPenugasan[id] =
          (jumlahPenugasan[id] ?? 0) + 1;
    }

    // Menggabungkan seluruh data.
    return data.map((item) {
      final id = item['id_pengguna'];
      final profil = detailPetugas[id];

      return {
        'id_pengguna': id,
        'auth_id': item['auth_id'],
        'nama_pengguna':
            item['nama_pengguna']?.toString() ?? 'Tanpa nama',
        'email': item['email']?.toString() ?? '-',
        'role': item['role']?.toString() ?? 'petugas',

        'jabatan':
            profil?['jabatan']?.toString() ?? 'Belum diisi',
        'keahlian':
            profil?['keahlian']?.toString() ?? 'Belum diisi',
        'no_telepon':
            profil?['no_telepon']?.toString() ?? 'Belum diisi',

        'jumlah_penugasan': jumlahPenugasan[id] ?? 0,
      };
    }).toList();
  }

  
  // Membuat akun petugas melalui Edge Function.
  Future<Map<String, dynamic>> tambahPetugas({
    required String nama,
    required String email,
    required String password,
    required String jabatan,
    required String keahlian,
    required String noTelepon,
  }) async {
    // Mengambil sesi Admin yang sedang login.
    final session = supabase.auth.currentSession;

    if (session == null) {
      throw Exception('Sesi Admin tidak ditemukan. Silakan login kembali.');
    }

    try {
      final response = await supabase.functions.invoke(
        'buat-akun-petugas',
        headers: {
          'Authorization': 'Bearer ${session.accessToken}',
        },
        body: {
          'nama': nama.trim(),
          'email': email.trim(),
          'password': password,
          'jabatan': jabatan.trim(),
          'keahlian': keahlian.trim(),
          'no_telepon': noTelepon.trim(),
        },
      );

      final data = Map<String, dynamic>.from(response.data);

      if (data['success'] != true) {
        throw Exception(
          data['error'] ?? 'Gagal membuat akun petugas.',
        );
      }

      return data;
    } on FunctionException catch (e) {
      final details = e.details;

      if (details is Map && details['error'] != null) {
        final pesan = details['error'].toString();
        final detail = details['detail']?.toString() ?? '';
        final kode = details['code']?.toString() ?? '';

        throw Exception(
          '$pesan\nDetail: $detail\nKode: $kode',
        );
      }

      throw Exception(
        'HTTP ${e.status}: ${details?.toString() ?? 'Gagal menghubungi server.'}',
      );
    }
  }


  // Mengambil petugas yang sudah ditugaskan pada laporan.
  Future<Map<String, dynamic>?> getPetugasDitugaskan(
    int idLaporan,
  ) async {
    await _pastikanAdmin();

    final penugasan = await supabase
        .from('penugasan')
        .select('id_penugasan, id_petugas, waktu_penugasan')
        .eq('id_laporan', idLaporan)
        .order('waktu_penugasan', ascending: false)
        .limit(1);

    if (penugasan.isEmpty) return null;

    final idPetugas =
        (penugasan.first['id_petugas'] as num).toInt();

    final pengguna = await supabase
        .from('pengguna')
        .select('id_pengguna, nama_pengguna, email')
        .eq('id_pengguna', idPetugas)
        .single();

    final detail = await supabase
        .from('detail_petugas')
        .select('jabatan, keahlian, no_telepon')
        .eq('id_pengguna', idPetugas)
        .maybeSingle();

    return {
      ...Map<String, dynamic>.from(pengguna),
      'jabatan': detail?['jabatan'] ?? 'Belum diisi',
      'keahlian': detail?['keahlian'] ?? 'Belum diisi',
      'no_telepon': detail?['no_telepon'] ?? '-',
      'id_penugasan': penugasan.first['id_penugasan'],
      'waktu_penugasan': penugasan.first['waktu_penugasan'],
    };
  }

  // Menyimpan atau memperbarui petugas yang ditugaskan.
  // Tidak mengubah status laporan.
  Future<void> tugaskanPetugas({
    required int idLaporan,
    required int idPetugas,
  }) async {
    await _pastikanAdmin();

    // Pastikan laporan sudah diverifikasi.
    final laporan = await supabase
        .from('laporan')
        .select('status')
        .eq('id_laporan', idLaporan)
        .single();

    if (laporan['status'] != 'Diverifikasi') {
      throw Exception(
        'Petugas hanya dapat ditugaskan pada laporan berstatus Diverifikasi.',
      );
    }

    // Pastikan akun yang dipilih benar-benar petugas.
    final petugas = await supabase
        .from('pengguna')
        .select('id_pengguna, role')
        .eq('id_pengguna', idPetugas)
        .maybeSingle();

    if (petugas == null || petugas['role'] != 'petugas') {
      throw Exception('Akun yang dipilih bukan petugas.');
    }

    // Periksa apakah laporan sudah memiliki penugasan.
    final penugasanLama = await supabase
        .from('penugasan')
        .select('id_penugasan')
        .eq('id_laporan', idLaporan)
        .order('waktu_penugasan', ascending: false)
        .limit(1);

    if (penugasanLama.isNotEmpty) {
      // Perbarui petugas jika sudah pernah ditugaskan.
      await supabase
          .from('penugasan')
          .update({
            'id_petugas': idPetugas,
            'waktu_penugasan':
                DateTime.now().toUtc().toIso8601String(),
          })
          .eq(
            'id_penugasan',
            penugasanLama.first['id_penugasan'],
          );
    } else {
      // Buat penugasan baru.
      await supabase.from('penugasan').insert({
        'id_laporan': idLaporan,
        'id_petugas': idPetugas,
      });
    }
  }


}
