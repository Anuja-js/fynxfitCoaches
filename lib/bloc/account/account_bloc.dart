import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final FirebaseFirestore firestore;

  AccountBloc({required this.firestore}) : super(AccountInitial()) {
    on<FetchAccountDetails>((event, emit) async {
      emit(AccountLoading());
      try {
        var doc = await firestore.collection('coaches').doc(event.userId).get();
        if (doc.exists) {
          var data = doc.data()!;
          emit(AccountLoaded(
            profileImage: data['profileImage'] ?? '',
            birthday: data['birthday'] ?? '',
            gender: data['gender'] ?? '',
            weight: data['weight'] ?? 0,
            height: data['height'] ?? 0,
            unit: data['unit'] ?? '',
            unitHeight: data['unitheight'] ?? '',
          ));
        } else {
          emit(AccountError("User not found"));
        }
      } catch (e) {
        emit(AccountError("Failed to fetch user data: $e"));
      }
    });
  }

}
