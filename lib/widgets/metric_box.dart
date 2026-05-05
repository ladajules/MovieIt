import 'package:flutter/material.dart';

class MetricBox extends StatelessWidget {
  final String value;
  final String label;

  const MetricBox({
    super.key, 
    required this.value, 
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value, 
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 20, 
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label, 
            style: const TextStyle(
              color: Colors.white70, 
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}