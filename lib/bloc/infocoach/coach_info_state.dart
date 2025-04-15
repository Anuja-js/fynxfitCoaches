abstract class BasicInfoState {}

class BasicInfoInitial extends BasicInfoState {}

class BasicInfoUpdated extends BasicInfoState {
  final String name;
  final String experience;
  final String expertise;
  final String bio;

  BasicInfoUpdated({required this.name, required this.experience, required this.expertise, required this.bio});
}
