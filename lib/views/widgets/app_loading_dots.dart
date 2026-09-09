import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../utils/values/my_color.dart';

/// Theme-aware staggered dots loader (use instead of CircularProgressIndicator).
class AppLoadingDots extends StatelessWidget {
  const AppLoadingDots({super.key, this.size = 50});

  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LoadingAnimationWidget.staggeredDotsWave(
      color: isDark ? MyColors.white : MyColors.darkPurple,
      size: size,
    );
  }
}
