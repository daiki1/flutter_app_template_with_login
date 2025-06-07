import 'package:flutter/cupertino.dart';

import 'loader_overlay.dart';

/// MainWrapper is a widget that wraps the main content of the application
/// to provide a consistent layout and display a loading overlay.
class MainWrapper extends StatelessWidget {
  final Widget child;

  const MainWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        const LoaderOverlay(), // Always on top
      ],
    );
  }
}