import 'package:flutter/material.dart';

class HeightScaleWidget extends StatelessWidget {
  final double initialHeight;
  final ValueChanged<double> onHeightChanged;
  final bool isCmUnit;

  const HeightScaleWidget({
    Key? key,
    required this.initialHeight,
    required this.onHeightChanged,
    required this.isCmUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Slider(
        value: initialHeight,
        min: isCmUnit ? 99 : 39,
        max: isCmUnit ? 220 : 87,
        divisions: isCmUnit ? 120 : 48,
        label: initialHeight.toStringAsFixed(0),
        onChanged: onHeightChanged,
      ),
    );
  }
}
