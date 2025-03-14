import 'package:bloc/bloc.dart';

class ProfileOnboardingCubit extends Cubit<int> {
  ProfileOnboardingCubit() : super(0);

  void nextPage() {
    if (state < 5) emit(state + 1);
  }

  void previousPage() {
    if (state > 0) emit(state - 1);
  }

  void goToPage(int index) {
    emit(index);
  }
}
