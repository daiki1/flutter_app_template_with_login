import 'package:flutter/cupertino.dart';

/// A widget that provides a section for form inputs with padding
class FormSection extends StatelessWidget {
  final Widget child;
  const FormSection({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: child,
    );
  }
}