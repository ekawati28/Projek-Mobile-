
import 'package:supabase_flutter/supabase_flutter.dart';

class RoleService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<String?> getUserRole(String authId) async {
    final response = await supabase
        .from('pengguna')
        .select('role')
        .eq('auth_id', authId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return response['role']?.toString().trim().toLowerCase();
  }
}
