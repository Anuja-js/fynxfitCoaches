abstract class HeightEvent {}

class ToggleUnit extends HeightEvent {}

class UpdateHeight extends HeightEvent {
  final double height;
  UpdateHeight(this.height);
}

