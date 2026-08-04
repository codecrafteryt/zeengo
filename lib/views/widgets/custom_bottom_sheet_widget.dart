import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/values/app_palette.dart';

/// Airbnb-style reusable bottom sheet.
/// Use [CustomBottomSheetWidget.show] from any screen.
class CustomBottomSheetWidget extends StatelessWidget {
  const CustomBottomSheetWidget({
    super.key,
    required this.child,
    this.heightFactor,
    this.padding,
    this.showHandle = true,
    this.backgroundColor,
    this.radius,
    this.scrollable = true,
    this.borderColor,
  });

  final Widget child;
  final double? heightFactor;
  final EdgeInsetsGeometry? padding;
  final bool showHandle;
  final Color? backgroundColor;
  final double? radius;
  final bool scrollable;
  final Color? borderColor;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double? heightFactor,
    double? radius,
    EdgeInsetsGeometry? padding,
    bool showHandle = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool scrollable = true,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: AppPalette.of(context).overlay,
      builder: (ctx) => CustomBottomSheetWidget(
        heightFactor: heightFactor,
        radius: radius,
        padding: padding,
        showHandle: showHandle,
        scrollable: scrollable,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final bg = backgroundColor ?? palette.card;
    final media = MediaQuery.of(context);
    final maxH = media.size.height * (heightFactor ?? 0.98);
    final r = radius ?? 16.r;
    final contentPadding = padding ??
        EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h + media.padding.bottom);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxH,
            minHeight: maxH * 0.85,
          ),
          child: Container(
            height: maxH,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(r)),
              border: borderColor == null
                  ? null
                  : Border.all(color: borderColor!, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 28,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                if (showHandle) ...[
                  SizedBox(height: 10.h),
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: palette.border,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
                Expanded(
                  child: scrollable
                      ? SingleChildScrollView(
                          padding: contentPadding,
                          child: child,
                        )
                      : Padding(
                          padding: contentPadding,
                          child: child,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
