import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../utils/values/app_palette.dart';
import '../../utils/values/my_color.dart';

/// Full-page loading overlay (e.g. logout).
class FullPageLoadingIndicator extends StatelessWidget {
  const FullPageLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: palette.scaffold,
      body: SizedBox.expand(
        child: ColoredBox(
          color: palette.scaffold,
          child: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: isDark ? MyColors.white : MyColors.darkPurple,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}
