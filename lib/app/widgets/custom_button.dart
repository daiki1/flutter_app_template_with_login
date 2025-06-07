import 'package:flutter/material.dart';
import 'package:flutter_app_template_with_login/app/widgets/form_section.dart';

import '../../config/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Future<void> Function() onPressed;
  final bool isPrimary;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: () async {
        await onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.primary  : AppColors.secondary,
        foregroundColor: isPrimary ? Colors.white : AppColors.text,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(label),
      ),
    );

    return FormSection(child: fullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button);
  }
}