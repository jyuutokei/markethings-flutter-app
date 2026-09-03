import 'package:flutter/material.dart';
import 'package:mt/core/constants/constants.dart';

class ColorDot extends StatelessWidget {
  const ColorDot({super.key, required this.color, required this.isActive});

  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding / 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: isActive ? Theme.of(context).primaryColor : Colors.transparent,
        ),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(radius: 10, backgroundColor: color),
    );
  }
}
