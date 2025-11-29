import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  final ApiService _apiService;

  LoginViewModel(this._apiService);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validaciones básicas
      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Por favor completa todos los campos';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!email.contains('@')) {
        _errorMessage = 'Ingresa un email válido';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Llamar al API
      final response = await _apiService.login(email, password);

      // Guardar token
      if (response['token'] != null) {
        _apiService.setAuthToken(response['token'] as String);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al iniciar sesión: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
