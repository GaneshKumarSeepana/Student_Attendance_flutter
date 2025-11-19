import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PercentageIndicator extends StatelessWidget {
  final double percentage;
  final String label;
  final double size;

  const PercentageIndicator({
    Key? key,
    required this.percentage,
    required this.label,
    this.size = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBelowThreshold = percentage < 75.0;
    final color = isBelowThreshold ? Colors.red : (percentage < 90.0 ? Colors.orange : Colors.green);

    return CircularPercentIndicator(
      radius: size / 2,
      lineWidth: 8,
      percent: percentage / 100,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: size / 5,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: size / 8,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      progressColor: color,
      backgroundColor: Colors.grey[300]!,
    );
  }
}