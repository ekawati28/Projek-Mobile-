class PenggunaModel {
  final int? idPengguna;
  final String? authId;
  final String namaPengguna;
  final String email;
  final String role;
  final DateTime? createdAt;


  PenggunaModel({
    this.idPengguna,
    this.authId,
    required this.namaPengguna,
    required this.email,
    required this.role,
    this.createdAt,
  });


  // Mengambil data dari Supabase
  factory PenggunaModel.fromJson(
      Map<String, dynamic> json) {

    return PenggunaModel(
      idPengguna: json['id_pengguna'],
      authId: json['auth_id'],
      namaPengguna: json['nama_pengguna'],
      email: json['email'],
      role: json['role'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(
              json['created_at'],
            )
          : null,
    );
  }


  // Mengirim data ke Supabase
  Map<String, dynamic> toJson() {

    return {

      'id_pengguna': idPengguna,

      'auth_id': authId,

      'nama_pengguna': namaPengguna,

      'email': email,

      'role': role,

      'created_at':
          createdAt?.toIso8601String(),

    };
  }
}