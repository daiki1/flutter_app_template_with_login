import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';
import 'form_section.dart';

/// CustomInput is a reusable input field widget that supports text input, password visibility toggle,
/// and validation.
class CustomInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final String? Function(String?)? validator;
  final bool showEye;
  final int maxLength;
  final bool showCounterTextMaxLength;
  final Widget? prefixIcon;

  const CustomInput({
    super.key,
    required this.label,
    required this.controller,
    required this.maxLength,
    this.obscure = false,
    this.validator,
    this.showEye = false,
    this.showCounterTextMaxLength = false,
    this.prefixIcon,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late final RxBool isPasswordVisible;

  @override
  void initState() {
    super.initState();
    isPasswordVisible =
        (!widget.obscure).obs; // default to hidden if `obscure` is true
  }

  @override
  Widget build(BuildContext context) {
    Widget textFormField({required bool obscureText, Widget? suffixIcon}) {
      return TextFormField(
        controller: widget.controller,
        maxLength: widget.maxLength,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          errorMaxLines: 3,
          counterText: widget.showCounterTextMaxLength ? null : '',
          helperText: ' ', // ← Reserve space for error
          isDense: true,
          filled: true,
          fillColor: AppColors.background,
          suffixIcon: suffixIcon,
          prefixIcon: widget.prefixIcon,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.error, width: 2),
          ),
        ),
        validator: widget.validator,
        onChanged: (_) {
          // This triggers form re-validation while typing
          if (widget.validator != null) {
            Form.of(context).validate();
          }
        },
      );
    }

    if (widget.showEye) {
      return FormSection(
        child: Obx(
          () => textFormField(
            obscureText: !isPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () => isPasswordVisible.toggle(),
            ),
          ),
        ),
      );
    } else {
      return FormSection(child: textFormField(obscureText: widget.obscure));
    }
  }
}
