import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_event.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<String?> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Fetch user verification status from Firestore
        DocumentSnapshot userDoc = await _firestore.collection('coaches').doc(user.uid).get();

        // if (userDoc.exists && userDoc['verified'] == "true") {
          await _updateUserLoginTime(user);
          emit(AuthSuccess(user));
        // } else {
        //   emit(AuthFailure("Your account is not verified by the admin."));
        // }
      } else {
        emit(AuthFailure("Login failed. User not found."));
      }
      return null;
    } catch (e) {
          final authdata = auth.currentUser;
          if (authdata != null) {
            DocumentSnapshot userDoc = await _firestore.collection('coaches').doc(authdata.uid).get();

            // if (userDoc.exists && userDoc['verified'] == "true") {
              await _updateUserLoginTime(authdata);
              emit(AuthSuccess(authdata));
            // } else {
            //   emit(AuthFailure("Your account is not verified by the admin."));
            // }

            return null;
          } else {
            // throw e;
            emit(AuthFailure(e.toString()));
            return e.toString();
          }
      // emit(AuthFailure(e.toString()));
      // return e.toString();
    }
  }

  Future<String?> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      User? user = userCredential.user;
      if (user != null) {
        print("User UID: ${user.uid}");
        print("User Email: ${user.email}");

        await _firestore.collection('coaches').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'verified': "false",
          'createdAt': FieldValue.serverTimestamp(),
          "profileonboading":false
        });

        print("User stored in Firestore successfully");
      }

      emit(AuthSuccess(user!));
      return null;
    } catch (e) {
      final authdata = auth.currentUser;

      if (authdata != null) {
        print("User stored in Firestore successfully");
        await _firestore.collection('coaches').doc(authdata.uid).set({
          'uid': authdata.uid,
          'email': authdata.email,
          'createdAt': FieldValue.serverTimestamp(),
          'verified': "false",
          "profileonboading":false
        });
        await auth.signOut();

        emit(AuthSuccess(authdata));
        return null;
      } else {
        emit(AuthFailure(e.toString()));
        return e.toString();
      }
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await auth.signOut();
      emit(AuthLoggedOut());
    } catch (e) {
      // on<Event>((event, emit) async {
      //    await future.whenComplete(() =>  emit( AuthFailure("Logout failed. Please try again.")));
      //     });
      emit(AuthFailure("Logout failed. Please try again."));
    }
  }

  Future<void> _updateUserLoginTime(User user) async {
    try {
      await _firestore.collection('coaches').doc(user.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
      print("User last login updated: ${user.uid}");
    } catch (e) {
      print("Error updating last login time: $e");
    }
  }
}
