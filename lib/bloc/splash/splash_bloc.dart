import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<CheckUserStatus>((event, emit) async {
      await Future.delayed(const Duration(seconds: 3));
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(UserLoggedIn());
      } else {
        emit(UserNotLoggedIn());
      }
    });
  }
}
