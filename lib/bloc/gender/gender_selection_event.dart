
abstract class GenderSelectionEvent {}

class SelectGender extends GenderSelectionEvent {
  final String gender;
  SelectGender(this.gender);
}


