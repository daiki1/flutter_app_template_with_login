import 'package:flutter/cupertino.dart';

import 'loader_overlay.dart';

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