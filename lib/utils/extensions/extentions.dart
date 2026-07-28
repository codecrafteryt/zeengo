import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension Space on num {
  SizedBox get sbh => SizedBox(
      height: ScreenUtil().setHeight(toDouble(),
      ));

  SizedBox get sbw => SizedBox(
    width: ScreenUtil().setWidth(toDouble()),
  );
}

/// System nav bar, home indicator, and IME — use for bottom padding on full-screen UIs.
class BottomInset {
  BottomInset._();

  /// `max(viewPadding.bottom, padding.bottom) + extra` (handles edge-to-edge Android + keyboard).
  static double of(BuildContext context, {double extra = 0}) {
    final MediaQueryData mq = MediaQuery.of(context);
    return math.max(mq.viewPadding.bottom, mq.padding.bottom) + extra;
  }

  /// Home indicator / gesture nav only (ignores IME) — use under [BottomNavigationBar].
  static double systemBottom(BuildContext context, {double extra = 0}) {
    return MediaQuery.of(context).viewPadding.bottom + extra;
  }

  static EdgeInsets paddingOnlyBottom(BuildContext context,
      {double extra = 0}) {
    return EdgeInsets.only(bottom: of(context, extra: extra));
  }

  /// Bottom-only padding using [of].
  static EdgeInsets fromLTRBWithBottom(
    BuildContext context, {
    required double left,
    required double top,
    required double right,
    double bottomExtra = 0,
  }) {
    return EdgeInsets.fromLTRB(
      left,
      top,
      right,
      of(context, extra: bottomExtra),
    );
  }
}

extension BuildContextBottomInset on BuildContext {
  double get bottomInset => BottomInset.of(this);

  double bottomInsetPlus([double extra = 0]) =>
      BottomInset.of(this, extra: extra);

  double get systemBottomInset => BottomInset.systemBottom(this);

  double systemBottomInsetPlus([double extra = 0]) =>
      BottomInset.systemBottom(this, extra: extra);
}
