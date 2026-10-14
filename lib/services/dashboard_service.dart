import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/dashboard_model.dart';
import '../models/laporan_model.dart';


class DashboardService {

  final SupabaseClient supabase =
      Supabase.instance.client;


  Future<DashboardModel> getDashboard() async {


    final user =
        supabase.auth.currentUser;


    if(user == null){
      throw Exception(
        "User belum login"
      );
    }


    final profile =
        await supabase
            .from('pengguna')
            .select()
            .eq(
              'auth_id',
              user.id,
            )
            .single();

    print(profile);
    
    final laporan =
    await supabase
        .from('laporan')
        .select('status')
        .eq(
          'id_pengguna',
          profile['id_pengguna'],
        );

    print(laporan);

    int diajukan = 0;
    int diverifikasi = 0;
    int diproses = 0;
    int selesai = 0;

    for (final item in laporan) {
      print(item['status']);
      switch (item['status'].toString().trim()) {
        case 'Diajukan':
          diajukan++;
          break;
        case 'Diverifikasi':
          diverifikasi++;
          break;
        case 'Diproses':
          diproses++;
          break;
        case 'Selesai':
          selesai++;
          break;
      }
    }

    final laporanTerbaru =
    await supabase
        .from('laporan')
        .select()
        .eq(
          'id_pengguna',
          profile['id_pengguna'],
        )
        .order(
          'lpr_waktu_dibuat',
          ascending: false,
        )
        .limit(3);

    final listLaporan =
    laporanTerbaru
        .map(
          (item) =>
              LaporanModel.fromJson(item),
        )
        .toList();

    return DashboardModel(
      namaPengguna:
          profile['nama_pengguna'],

      diajukan: diajukan,
      diverifikasi: diverifikasi,
      diproses: diproses,
      selesai: selesai,

      laporanTerbaru:listLaporan,
    );


  }

}