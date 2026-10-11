import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';

class AuthController {

  final AuthService authService = AuthService();

  Future<AuthResponse> register({
    required String nama,
    required String email,
    required String password,
  }) async {

    return await authService.register(
      nama: nama,
      email: email,
      password: password,
    );

  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {

    return await authService.login(
      email: email,
      password: password,
    );

  }

  Future<void> logout() async {
    await authService.logout();
  }

  Future<void> resetPassword(String email) async {
    await authService.resetPassword(email);
  }

  User? get currentUser {
    return authService.currentUser;
  }
}