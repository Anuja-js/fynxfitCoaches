import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0); // Initial screen index

  void changePage(int index) {
    emit(index);
  }
}
