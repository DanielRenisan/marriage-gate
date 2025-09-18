import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasError = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _hasError;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    _hasError = error != null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _hasError = false;
    notifyListeners();
  }

  Future<void> handleAsyncOperation(Future<void> Function() operation) async {
    try {
      setLoading(true);
      clearError();
      await operation();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

}
