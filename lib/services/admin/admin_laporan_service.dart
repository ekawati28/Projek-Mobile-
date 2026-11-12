import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminLaporanService {
  final SupabaseClient supabase = Supabase.instance.client;

  static const List<String> urutanStatus = [
    'Diajukan',
    'Diverifikasi',
    'Diproses',
    'Selesai',
  ];

  Future<void> _pastikanAdmin() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Admin belum login.');
    }

    final pengguna = await supabase
        .from('pengguna')
        .select('role')
        .eq('auth_id', user.id)
        .single();

    if (pengguna['role'] != 'admin') {
      throw Exception('Akses ditolak. Khusus Admin.');
    }
  }

  Future<Map<String, dynamic>> ubahStatusLaporan({
    required int idLaporan,
    required String statusBaru,
  }) async {
    await _pastikanAdmin();

    if (!urutanStatus.contains(statusBaru)) {
      throw Exception('Status laporan tidak valid.');
    }

    // Ambil status laporan saat ini.
    final laporan = await supabase
        .from('laporan')
        .select('id_laporan, status')
        .eq('id_laporan', idLaporan)
        .single();

    final String statusLama = laporan['status'];

    final int indeksLama = urutanStatus.indexOf(statusLama);
    final int indeksBaru = urutanStatus.indexOf(statusBaru);

    if (indeksLama == -1) {
      throw Exception('Status laporan saat ini tidak dikenal.');
    }

    if (indeksBaru != indeksLama + 1) {
      throw Exception(
        'Perubahan status harus mengikuti urutan: '
        'Diajukan, Diverifikasi, Diproses, Selesai.',
      );
    }

    // Pastikan status belum berubah oleh proses lain.
    final hasil = await supabase
        .from('laporan')
        .update({'status': statusBaru})
        .eq('id_laporan', idLaporan)
        .eq('status', statusLama)
        .select('id_laporan, status, lpr_waktu_diperbarui')
        .maybeSingle();

    if (hasil == null) {
      throw Exception(
        'Status laporan sudah berubah. Muat ulang data.',
      );
    }

    // Trigger database menangani riwayat dan notifikasi.
    return Map<String, dynamic>.from(hasil);
  }
  
  Future<List<Map<String, dynamic>>> getDaftarLaporan() async {
    await _pastikanAdmin();

    // 1. Mengambil seluruh data laporan.
    final laporan = await supabase
        .from('laporan')
        .select(
          'id_laporan, id_pengguna, id_kategori, judul, lokasi, '
          'lpr_deskripsi, status, lpr_waktu_dibuat',
        )
        .order('lpr_waktu_dibuat', ascending: false);

    if (laporan.isEmpty) {
      return [];
    }

    // 2. Mengambil ID mahasiswa yang membuat laporan.
    final idPengguna = laporan
        .map((item) => item['id_pengguna'])
        .toSet()
        .toList();

    // 3. Mengambil nama dan email mahasiswa.
    final pengguna = await supabase
        .from('pengguna')
        .select('id_pengguna, nama_pengguna, email')
        .inFilter('id_pengguna', idPengguna);

    // 4. Membuat mapping data mahasiswa.
    final Map<dynamic, Map<String, dynamic>> dataPengguna = {
      for (final item in pengguna)
        item['id_pengguna']: Map<String, dynamic>.from(item),
    };

    // 5. Menggabungkan data laporan dan data mahasiswa.
    return laporan.map((item) {
      final waktu =
          item['lpr_waktu_dibuat']?.toString() ?? '';

      final profil = dataPengguna[item['id_pengguna']];

      final namaPengguna =
          profil?['nama_pengguna']?.toString() ??
          'Pengguna tidak ditemukan';

      final emailPengguna =
          profil?['email']?.toString() ?? '-';

      final judulLaporan =
          item['judul']?.toString() ?? 'Tanpa judul';

      final deskripsi =
          item['lpr_deskripsi']?.toString() ?? '-';

      return {
        // Identitas laporan.
        'id_laporan': item['id_laporan'],
        'id': '#CR-${item['id_laporan']}',

        // Judul: untuk daftar dan halaman detail.
        'title': judulLaporan,
        'judul': judulLaporan,

        // Identitas mahasiswa.
        'pelapor': namaPengguna,
        'nama_pelapor': namaPengguna,
        'email': emailPengguna,

        // Informasi laporan.
        'status': item['status'] ?? 'Diajukan',
        'kategori': item['id_kategori']?.toString() ?? '-',
        'lokasi': item['lokasi']?.toString() ?? '-',
        'deskripsi': deskripsi,

        // Tanggal laporan.
        'tanggal': waktu.isNotEmpty
            ? waktu.split('T').first
            : '-',
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getFotoLaporan(
    int idLaporan,
  ) async {
    await _pastikanAdmin();

    final data = await supabase
        .from('foto')
        .select('id_foto, id_laporan, path_foto')
        .eq('id_laporan', idLaporan)
        .order('ft_waktu_dibuat', ascending: true);

    if (data.isEmpty) {
      return [];
    }

    final List<Map<String, dynamic>> hasil = [];

    for (final item in data) {
      final path = item['path_foto']?.toString().trim();

      if (path == null || path.isEmpty) {
        throw Exception('Path foto kosong.');
      }

      debugPrint('ID Laporan: $idLaporan');
      debugPrint('Bucket: foto-laporan');
      debugPrint('Path: $path');

      final signedUrl = await supabase.storage
          .from('foto-laporan')
          .createSignedUrl(path, 3600);

      hasil.add({
        'id_foto': item['id_foto'],
        'path_foto': path,
        'url_foto': signedUrl,
      });
    }

    return hasil;
  }
  
  Future<List<Map<String, dynamic>>> getRiwayatLaporan(
    int idLaporan,
  ) async {
    await _pastikanAdmin();

    // Mengambil riwayat berdasarkan ID laporan.
    final riwayat = await supabase
        .from('riwayat')
        .select(
          'id_riwayat, id_laporan, id_pengguna, '
          'status, catatan, rwyt_waktu_dibuat',
        )
        .eq('id_laporan', idLaporan)
        .order('rwyt_waktu_dibuat', ascending: true);

    if (riwayat.isEmpty) {
      return [];
    }

    // Mengambil ID pengguna yang tercatat dalam riwayat.
    final idPengguna = riwayat
        .map((item) => item['id_pengguna'])
        .toSet()
        .toList();

    // Mengambil nama pengguna.
    final pengguna = await supabase
        .from('pengguna')
        .select('id_pengguna, nama_pengguna')
        .inFilter('id_pengguna', idPengguna);

    // Membuat mapping ID dan nama pengguna.
    final Map<dynamic, String> namaPengguna = {
      for (final item in pengguna)
        item['id_pengguna']:
            item['nama_pengguna']?.toString() ?? 'Tanpa nama',
    };

    // Menggabungkan riwayat dan identitas pengguna.
    return riwayat.map((item) {
      return {
        ...Map<String, dynamic>.from(item),
        'nama_pengguna':
            namaPengguna[item['id_pengguna']] ?? 'Pengguna tidak ditemukan',
      };
    }).toList();
  }


}
