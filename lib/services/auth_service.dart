import '../models/user_model.dart';

class AuthService {
  final Map<String, UserModel> _users = {
    'mahasiswa@gmail.com': UserModel(
      id: 'mhs-001',
      namaLengkap: 'Mahasiswa Uji',
      email: 'mahasiswa@gmail.com',
      role: 'mahasiswa',
      nim: '07352411051',
      createdAt: DateTime.now(),
    ),
    
    'admin@campus.com': UserModel(
      id: 'admin-001',
      namaLengkap: 'Admin Kampus',
      email: 'admin@campus.com',
      role: 'admin',
      createdAt: DateTime.now(),
    ),
    'petugas@campus.com': UserModel(
      id: 'petugas-001',
      namaLengkap: 'Petugas Kampus',
      email: 'petugas@campus.com',
      role: 'petugas',
      createdAt: DateTime.now(),
    ),
  };

  UserModel? _currentUser;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (password != '123456') {
      throw Exception('Password salah. Gunakan: 123456');
    }

    final user = _users[email];
    if (user == null) {
      throw Exception('Email tidak terdaftar. Coba: mahasiswa@gmail.com');
    }

    _currentUser = user;
    return user;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  UserModel? getCurrentUser() {
    return _currentUser;
  }
}