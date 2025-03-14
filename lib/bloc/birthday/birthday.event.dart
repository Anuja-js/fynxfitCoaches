abstract class BirthdayEvent {}

class UpdateBirthday extends BirthdayEvent {
  final DateTime birthday;
  UpdateBirthday(this.birthday);
}