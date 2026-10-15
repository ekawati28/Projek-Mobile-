import 'package:flutter/material.dart';

import '../models/dashboard_model.dart';
import '../services/dashboard_service.dart';

class DashboardController extends ChangeNotifier {

  final DashboardService service = DashboardService();

  DashboardModel? dashboard;

  bool isLoading = false;

  String? errorMessage;

  Future<void> loadDashboard() async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      dashboard = await service.getDashboard();

    } catch(e) {
      errorMessage =
          e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}