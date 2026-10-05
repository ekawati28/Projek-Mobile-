class LaporanController {
  // Menyimpan daftar laporan
  final List<Map<String, dynamic>> _laporan = [];

  // Mendapatkan semua laporan
  List<Map<String, dynamic>> get laporan => _laporan;

  // Menambahkan laporan baru
  void tambahLaporan({
    required String judul,
    required String isi,
    required String tanggal,
  }) {
    _laporan.add({
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
    });
  }

  // Menghapus laporan berdasarkan index
  void hapusLaporan(int index) {
    if (index >= 0 && index < _laporan.length) {
      _laporan.removeAt(index);
    }
  }

  // Mengubah laporan
  void editLaporan({
    required int index,
    required String judul,
    required String isi,
    required String tanggal,
  }) {
    if (index >= 0 && index < _laporan.length) {
      _laporan[index] = {
        'judul': judul,
        'isi': isi,
        'tanggal': tanggal,
      };
    }
  }
}