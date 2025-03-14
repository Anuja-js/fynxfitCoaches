import 'package:flutter_bloc/flutter_bloc.dart';
import 'weight_event.dart';
import 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  WeightBloc() : super(WeightState(selectedWeight: 75.0, isKgUnit: true)) {
    on<UpdateWeight>((event, emit) {
      emit(WeightState(selectedWeight: event.weight, isKgUnit: state.isKgUnit));
    });

    on<ToggleUnit>((event, emit) {
      double newWeight = state.isKgUnit
          ? state.selectedWeight * 2.20462  // Convert KG to LB
          : state.selectedWeight / 2.20462; // Convert LB to KG

      emit(WeightState(selectedWeight: newWeight, isKgUnit: !state.isKgUnit));
    });
  }
}
