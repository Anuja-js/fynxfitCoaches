import 'package:flutter/material.dart';

class WeightScaleWidget extends StatefulWidget {
  final double initialWeight;
  final ValueChanged<double> onWeightChanged;
  final bool isKgUnit;

  const WeightScaleWidget({
    Key? key,
    required this.initialWeight,
    required this.onWeightChanged,
    required this.isKgUnit,
  }) : super(key: key);

  @override
  _WeightScaleWidgetState createState() => _WeightScaleWidgetState();
}

class _WeightScaleWidgetState extends State<WeightScaleWidget> {
  late FixedExtentScrollController _scrollController;
  late List<double> weightValues;

  @override
  void initState() {
    super.initState();
    _setupScale();
  }

  void _setupScale() {
    double minWeight = widget.isKgUnit ? 30.0 : 66.0;
    double maxWeight = widget.isKgUnit ? 200.0 : 440.0;
    double step = widget.isKgUnit ? 1.0 : 2.0;

    weightValues = List.generate(
      ((maxWeight - minWeight) ~/ step).toInt() + 1,
          (index) => minWeight + (index * step),
    );

    int initialIndex = weightValues.indexOf(widget.initialWeight);
    if (initialIndex == -1) {
      initialIndex = weightValues.length ~/ 2;
    }

    _scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        child: ListWheelScrollView.useDelegate(
          controller: _scrollController,
          itemExtent: 50,
          physics: FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            widget.onWeightChanged(weightValues[index]);
          },
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              return Center(
                child: Text(
                  weightValues[index].toStringAsFixed(0),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              );
            },
            childCount: weightValues.length,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
