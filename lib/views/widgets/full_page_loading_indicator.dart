import 'package:flutter/material.dart';

import '../../utils/values/app_palette.dart';
import 'app_loading_dots.dart';

/// Full-page loading overlay (e.g. logout).
class FullPageLoadingIndicator extends StatelessWidget {
  const FullPageLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Scaffold(
      backgroundColor: palette.scaffold,
      body: const SizedBox.expand(
        child: Center(child: AppLoadingDots()),
      ),
    );
  }
}
