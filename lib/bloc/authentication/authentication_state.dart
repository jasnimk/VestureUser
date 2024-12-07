
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error
}

class AuthState {
  final AuthStatus status;
  final String? userId;
  final String? errorMessage;
  final String? userName;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userId,
    this.errorMessage,
    this.userName
  });


  factory AuthState.initial() => const AuthState();
  
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);
  
  factory AuthState.authenticated(String userId,String userName) => AuthState(
        status: AuthStatus.authenticated,
        userId: userId,
        userName:userName
      );
  
  factory AuthState.unauthenticated() => const AuthState(
        status: AuthStatus.unauthenticated,
      );
  
  factory AuthState.error(String errorMessage) => AuthState(
        status: AuthStatus.error,
        errorMessage: errorMessage,
      );
}