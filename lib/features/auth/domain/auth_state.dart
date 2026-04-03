/// Estado de autenticación para Inventra.
///
/// Modelo inmutable que representa el estado actual de la sesión.
class AuthState {
  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.userId,
    this.email,
    this.errorMessage,
  });

  final bool isAuthenticated;
  final bool isLoading;
  final String? userId;
  final String? email;
  final String? errorMessage;

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? userId,
    String? email,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  /// Estado inicial sin sesión.
  static const initial = AuthState();

  /// Estado de carga durante login/logout.
  static const loading = AuthState(isLoading: true);
}
