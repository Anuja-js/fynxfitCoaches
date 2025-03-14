
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/height/height_event.dart';
import 'package:fynxfitcoaches/bloc/height/height_state.dart';

class HeightBloc extends Bloc<HeightEvent, HeightState> {
  HeightBloc() : super(HeightState(isCmUnit: true, selectedHeight: 170.0)) {
    on<ToggleUnit>((event, emit) {
      final newHeight = state.isCmUnit ? state.selectedHeight / 2.54 : state.selectedHeight * 2.54;
      emit(HeightState(isCmUnit: !state.isCmUnit, selectedHeight: newHeight));
    });

    on<UpdateHeight>((event, emit) {
      emit(HeightState(isCmUnit: state.isCmUnit, selectedHeight: event.height));
    });
  }
}
