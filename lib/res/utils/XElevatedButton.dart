import 'package:flutter/material.dart';
import '../colors/app-colors.dart';

class XElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  const XElevatedButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonBg,
        foregroundColor: AppColors.buttonForeground,
      ),
      child: Text(label),
    );
  }
}
