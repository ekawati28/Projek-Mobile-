
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  final SupabaseClient supabase = Supabase.instance.client;

  static const List<String> statusLaporan = [
    'Diajukan',
    'Diverifikasi',
    'Diproses',
    'Selesai',
  ];

  // Memastikan pengguna yang mengakses adalah Admin.
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
  
  // Mengambil statistik laporan berdasarkan tahun berjalan.
  Future<Map<String, int>> getStatistikLaporan() async {
    await _pastikanAdmin();

    final tahunSekarang = DateTime.now().year;

    final awalTahun = DateTime(tahunSekarang, 1, 1);
    final awalTahunBerikutnya = DateTime(tahunSekarang + 1, 1, 1);

    final data = await supabase
        .from('laporan')
        .select('status')
        .gte(
          'lpr_waktu_dibuat',
          awalTahun.toIso8601String(),
        )
        .lt(
          'lpr_waktu_dibuat',
          awalTahunBerikutnya.toIso8601String(),
        );

    final statistik = <String, int>{
      'total': data.length,
      'Diajukan': 0,
      'Diverifikasi': 0,
      'Diproses': 0,
      'Selesai': 0,
    };

    for (final laporan in data) {
      final status = laporan['status']?.toString();

      if (status != null && statistik.containsKey(status)) {
        statistik[status] = statistik[status]! + 1;
      }
    }

    return statistik;
  }

  // Mengambil identitas Admin yang sedang login.
  Future<Map<String, dynamic>> getProfilAdmin() async {
    await _pastikanAdmin();

    final user = supabase.auth.currentUser!;

    final data = await supabase
        .from('pengguna')
        .select('id_pengguna, nama_pengguna, email, role')
        .eq('auth_id', user.id)
        .single();

    return Map<String, dynamic>.from(data);
  }

    
  // Mengambil antrean laporan yang menunggu verifikasi.
  Future<List<Map<String, dynamic>>> getAntreanVerifikasi() async {
    await _pastikanAdmin();

    // Mengambil laporan yang menunggu verifikasi.
    final laporan = await supabase
        .from('laporan')
        .select(
          'id_laporan, id_pengguna, id_kategori, judul, lokasi, '
          'lpr_deskripsi, status, lpr_waktu_dibuat',
        )
        .eq('status', 'Diajukan')
        .order('lpr_waktu_dibuat', ascending: false)
        .limit(10);

    if (laporan.isEmpty) return [];

    // Mengambil ID mahasiswa.
    final idPengguna = laporan
        .map((item) => item['id_pengguna'])
        .toSet()
        .toList();

    // Mengambil nama dan email mahasiswa.
    final pengguna = await supabase
        .from('pengguna')
        .select('id_pengguna, nama_pengguna, email')
        .inFilter('id_pengguna', idPengguna);

    // Membuat mapping profil mahasiswa.
    final Map<dynamic, Map<String, dynamic>> dataPengguna = {
      for (final item in pengguna)
        item['id_pengguna']: Map<String, dynamic>.from(item),
    };

    // Menggabungkan data laporan dan mahasiswa.
    return laporan.map((item) {
      final profil = dataPengguna[item['id_pengguna']];

      final nama = profil?['nama_pengguna']?.toString()
          ?? 'Pengguna tidak ditemukan';

      final email = profil?['email']?.toString() ?? '-';

      final judul = item['judul']?.toString() ?? 'Tanpa judul';

      final deskripsi =
          item['lpr_deskripsi']?.toString() ?? '-';

      final waktu = item['lpr_waktu_dibuat']?.toString() ?? '';

      final id = item['id_laporan'];

      return {
        'id_laporan': id,
        'id': '#CR-$id',

        // Judul laporan.
        'judul': judul,
        'title': judul,

        // Identitas mahasiswa.
        'nama_pelapor': nama,
        'pelapor': nama,
        'nama_pengguna': nama,
        'email': email,

        // Informasi laporan.
        'status': item['status'] ?? 'Diajukan',
        'kategori': item['id_kategori']?.toString() ?? '-',
        'lokasi': item['lokasi']?.toString() ?? '-',
        'deskripsi': deskripsi,
        'lpr_deskripsi': deskripsi,

        // Tanggal.
        'tanggal': waktu.isNotEmpty
            ? waktu.split('T').first
            : '-',
      };
    }).toList();
  }
  
  // Daftar lokasi resmi Kampus III Unkhair.
  static const List<String> daftarLokasiResmi = [
    'JT1',
    'JT2',
    'JT3',
    'JT4',
    'JT5',
    'JT6',
    'LAB RPL',
    'LAB JAK',
    'LAB RISET',
    'PRODI',
    'TU',
    'RUANG SEMINAR',
  ];

  // Mengambil jumlah laporan berdasarkan lokasi resmi.
  Future<Map<String, int>> getStatistikKerusakanGedung() async {
    await _pastikanAdmin();

    final data = await supabase
        .from('laporan')
        .select('lokasi');

    final statistik = <String, int>{
      for (final lokasi in daftarLokasiResmi)
        lokasi: 0,
    };

    for (final laporan in data) {
      final lokasi = laporan['lokasi']?.toString().trim();

      if (lokasi != null && statistik.containsKey(lokasi)) {
        statistik[lokasi] = statistik[lokasi]! + 1;
      }
    }

    return statistik;
  }


}
