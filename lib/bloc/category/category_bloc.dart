import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryLoading()) {
    on<LoadCategories>(onLoadCategories);
    on<SelectCategory>(onSelectCategory);
  }

  Future<void> onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('category').get();

      List<String> categories = querySnapshot.docs
          .map((doc) => doc['title'].toString())
          .toList();

      emit(CategoryLoaded(categories, null)); // No category selected initially
    } catch (e) {
      emit(CategoryError("Failed to load categories"));
    }
  }

  void onSelectCategory(SelectCategory event, Emitter<CategoryState> emit) {
    if (state is CategoryLoaded) {
      final loadedState = state as CategoryLoaded;
      emit(CategoryLoaded(loadedState.categories, event.selectedCategory));
    }
  }
}
