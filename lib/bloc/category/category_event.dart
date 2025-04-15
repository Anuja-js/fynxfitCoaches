part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {}

class SelectCategory extends CategoryEvent {
  final String selectedCategory;
  SelectCategory(this.selectedCategory);

  @override
  List<Object> get props => [selectedCategory];
}
