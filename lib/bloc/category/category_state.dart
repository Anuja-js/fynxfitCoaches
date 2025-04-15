part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<String> categories;
  final String? selectedCategory;
  CategoryLoaded(this.categories, this.selectedCategory);

  @override
  List<Object> get props => [categories, selectedCategory ?? ''];
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);

  @override
  List<Object> get props => [message];
}
