abstract class SplashState {}

class SplashInitial extends SplashState {}

class UserVerified extends SplashState {}

class UserNotVerified extends SplashState {}

class UserNotLoggedIn extends SplashState {}

class AuthFailure extends SplashState {
  final String message;
  AuthFailure(this.message);
}
