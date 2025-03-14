abstract class WeightEvent {}

class UpdateWeight extends WeightEvent {
  final double weight;
  UpdateWeight({required this.weight});
}

class ToggleUnit extends WeightEvent {}
