abstract class BmiEvent {}

class ToggleHeightUnit extends BmiEvent {}

class ToggleWeightUnit extends BmiEvent {}

class CalculateBMI extends BmiEvent {
  final double height;
  final double weight;

  CalculateBMI({required this.height, required this.weight});
}
