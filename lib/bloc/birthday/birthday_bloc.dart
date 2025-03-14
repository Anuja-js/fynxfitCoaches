import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/birthday/birthday.event.dart';
import 'birthday_state.dart';

class BirthdayBloc extends Bloc<BirthdayEvent, BirthdayState> {
  BirthdayBloc() : super(BirthdayState()) {
    on<UpdateBirthday>((event, emit) {
      emit(BirthdayState(birthday: event.birthday));
    });
  }
}
