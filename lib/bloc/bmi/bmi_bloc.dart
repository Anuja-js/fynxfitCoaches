import 'package:flutter_bloc/flutter_bloc.dart';
import 'bmi_event.dart';
import 'bmi_state.dart';

class BmiBloc extends Bloc<BmiEvent, BmiState> {
  BmiBloc()
      : super(BmiState(
    isHeightInInches: false,
    isWeightInLbs: false,
    bmi: 0,
  )) {
    on<ToggleHeightUnit>((event, emit) {
      emit(state.copyWith(isHeightInInches: !state.isHeightInInches));
    });

    on<ToggleWeightUnit>((event, emit) {
      emit(state.copyWith(isWeightInLbs: !state.isWeightInLbs));
    });

    on<CalculateBMI>((event, emit) {
      double height = event.height;
      double weight = event.weight;

      // Convert units if needed
      if (state.isHeightInInches) {
        height *= 2.54; // inches to cm
      }
      if (state.isWeightInLbs) {
        weight *= 0.453592; // lbs to kg
      }

      height = height / 100; // cm to meters

      double bmi = weight / (height * height);
      emit(state.copyWith(bmi: bmi));
    });
  }
}
