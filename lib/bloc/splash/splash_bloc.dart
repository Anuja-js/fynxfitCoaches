import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<CheckUserStatus>((event, emit) async {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Fetch user details from Firestore
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('coaches') // Your Firestore collection
              .doc(user.uid)
              .get();

          if (userDoc.exists && userDoc['verified'] == true) {
            emit(UserVerified()); // Verified user
          } else {
            emit(UserNotVerified()); // Not verified
          }
        } else {
          emit(UserNotLoggedIn()); // No user logged in
        }
      } catch (e) {
        emit(AuthFailure("Failed to check user status: $e"));
      }
      // await Future.delayed(const Duration(seconds: 3));
      // final user = FirebaseAuth.instance.currentUser;
      // if (user != null) {
      //   emit(UserVerified());
      // } else {
      //   emit(UserNotLoggedIn());
      // }
    });
  }
}
