import 'package:flutter_bloc/flutter_bloc.dart';
import 'gender_selection_event.dart';
import 'gender_selection_state.dart';

class GenderSelectionBloc extends Bloc<GenderSelectionEvent, GenderSelectionState> {
  GenderSelectionBloc() : super(GenderSelectionState()) {
    on<SelectGender>((event, emit) {
      emit(GenderSelectionState(selectedGender: event.gender));
    });
  }
}
