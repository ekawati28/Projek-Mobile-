class UserModel {
  final String id;
  final String namaLengkap;
  final String email;
  final String role;
  final String? nim;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.role,
    this.nim,
    required this.createdAt,
  });
}