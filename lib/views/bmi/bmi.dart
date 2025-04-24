import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/bmi/bmi_event.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
import '../../bloc/bmi/bmi_bloc.dart';
import '../../bloc/bmi/bmi_state.dart';


class BmiScreen extends StatefulWidget {
  const BmiScreen({Key? key}) : super(key: key);

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BmiBloc, BmiState>(
        builder: (context, state) {
          return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: CustomText(text:"BMI Calculator",),
        backgroundColor: Colors.black,
      ),
      body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Height Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Height Unit:", style: TextStyle(color: Colors.white)),
                    ToggleButtons(
                      isSelected: [!state.isHeightInInches, state.isHeightInInches],
                      onPressed: (_) {
                        context.read<BmiBloc>().add(ToggleHeightUnit());
                      },
                      children: const [
                        Padding(padding: EdgeInsets.all(8.0), child: Text("cm")),
                        Padding(padding: EdgeInsets.all(8.0), child: Text("in")),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: state.isHeightInInches ? "Height (in)" : "Height (cm)",
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),

                // Weight Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Weight Unit:", style: TextStyle(color: Colors.white)),
                    ToggleButtons(
                      isSelected: [!state.isWeightInLbs, state.isWeightInLbs],
                      onPressed: (_) {
                        context.read<BmiBloc>().add(ToggleWeightUnit());
                      },
                      children: const [
                        Padding(padding: EdgeInsets.all(8.0), child: Text("kg")),
                        Padding(padding: EdgeInsets.all(8.0), child: Text("lb")),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: state.isWeightInLbs ? "Weight (lb)" : "Weight (kg)",
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    double height = double.tryParse(heightController.text) ?? 0;
                    double weight = double.tryParse(weightController.text) ?? 0;

                    if (height > 0 && weight > 0) {
                      context.read<BmiBloc>().add(CalculateBMI(height: height, weight: weight));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter valid values")),
                      );
                    }
                  },
                  child: const Text("Calculate BMI"),
                ),

                const SizedBox(height: 20),

                if (state.bmi > 0)
                  Column(
                    children: [
                      Text(
                        "Your BMI: ${state.bmi.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Category: ${state.getCategory()}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _getColorForCategory(state.getCategory()),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          )

      );}
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case "Underweight":
        return Colors.blue;
      case "Normal Weight":
        return Colors.green;
      case "Overweight":
        return Colors.orange;
      case "Obesity":
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}
