class BmiState {
  final bool isHeightInInches;
  final bool isWeightInLbs;
  final double bmi;

  BmiState({
    required this.isHeightInInches,
    required this.isWeightInLbs,
    required this.bmi,
  });

  BmiState copyWith({
    bool? isHeightInInches,
    bool? isWeightInLbs,
    double? bmi,
  }) {
    return BmiState(
      isHeightInInches: isHeightInInches ?? this.isHeightInInches,
      isWeightInLbs: isWeightInLbs ?? this.isWeightInLbs,
      bmi: bmi ?? this.bmi,
    );
  }

  String getCategory() {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 24.9) return "Normal Weight";
    if (bmi < 29.9) return "Overweight";
    return "Obesity";
  }
}
