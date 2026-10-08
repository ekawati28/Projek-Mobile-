class AuthController {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      // Simulasi login
      await Future.delayed(const Duration(seconds: 1));
      
      if (email == 'mahasiswa@gmail.com' && password == '123456') {
        _isLoading = false;
        return true;
      } else {
        _errorMessage = 'Email atau password salah';
        _isLoading = false;
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
  }
}