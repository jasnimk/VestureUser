import 'package:flutter/material.dart';

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const CustomChoiceChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
      ),
    );
  }
}
