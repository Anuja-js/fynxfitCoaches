import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/infocoach/coach_info_event.dart';
import 'package:fynxfitcoaches/bloc/infocoach/coach_info_state.dart';
import 'package:fynxfitcoaches/utils/services/coache_services.dart';

class BasicInfoBloc extends Bloc<BasicInfoEvent, BasicInfoState> {
  final CoachService _coachService = CoachService();

  BasicInfoBloc() : super(BasicInfoInitial()) {
    on<UpdateName>((event, emit) {
      if (state is BasicInfoUpdated) {
        final currentState = state as BasicInfoUpdated;
        emit(BasicInfoUpdated(
          name: event.name,
          experience: currentState.experience,
          expertise: currentState.expertise,
          bio: currentState.bio,
        ));
      } else {
        emit(BasicInfoUpdated(name: event.name, experience: '', expertise: '', bio: ''));
      }
    });

    on<UpdateExperience>((event, emit) {
      if (state is BasicInfoUpdated) {
        final currentState = state as BasicInfoUpdated;
        emit(BasicInfoUpdated(
      name: currentState.name,
          experience: event.experience,
          expertise: currentState.expertise,
          bio: currentState.bio,
        ));
      }
    });

    on<UpdateExpertise>((event, emit) {
      if (state is BasicInfoUpdated) {
        final currentState = state as BasicInfoUpdated;
        emit(BasicInfoUpdated(
         name: currentState.name,
          experience: currentState.experience,
          expertise: event.expertise,
          bio: currentState.bio,
        ));
      }
    });

    on<UpdateBio>((event, emit) {
      if (state is BasicInfoUpdated) {
        final currentState = state as BasicInfoUpdated;
        emit(BasicInfoUpdated(
         name: currentState.name,
          experience: currentState.experience,
          expertise: currentState.expertise,
          bio: event.bio,
        ));
      }
    });

    on<SubmitBasicInfo>((event, emit) async {
      if (state is BasicInfoUpdated) {
        final currentState = state as BasicInfoUpdated;

        // Save data to Firestore
        await _coachService.saveCoachBasicInfo(
          userId: event.userId,
          name: currentState.name,
          experience: currentState.experience,
          expertise: currentState.expertise,
          bio: currentState.bio,
        );

        print("Basic Info Submitted Successfully");
      }
    });
  }
}
