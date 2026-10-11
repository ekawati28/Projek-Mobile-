import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/pengguna_model.dart';

class AuthService {

  final SupabaseClient supabase =
      Supabase.instance.client;

  Future<AuthResponse> register({
    required String nama,
    required String email,
    required String password,
  }) async {

    final response =
        await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'nama_pengguna': nama,
        'role': 'mahasiswa',
      },
    );

    return response;
  }


  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {


    final response =
        await supabase.auth
            .signInWithPassword(
      email: email,
      password: password,
    );


    return response;
  }


  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  User? get currentUser {
    return supabase.auth.currentUser;
  }

  Future<void> resetPassword(String email) async {
    await supabase.auth.resetPasswordForEmail(
      email,
      redirectTo:
          'http://localhost:3000',
    );
  }

}