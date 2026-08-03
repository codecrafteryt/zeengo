import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/values/my_color.dart';

/// Airbnb-style reusable bottom sheet.
/// Use [CustomBottomSheetWidget.show] from any screen.
class CustomBottomSheetWidget extends StatelessWidget {
  const CustomBottomSheetWidget({
    super.key,
    required this.child,
    this.heightFactor,
    this.padding,
    this.showHandle = true,
    this.backgroundColor = MyColors.white,
    this.radius,
  });

  final Widget child;
  final double? heightFactor;
  final EdgeInsetsGeometry? padding;
  final bool showHandle;
  final Color backgroundColor;
  final double? radius;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double? heightFactor,
    double? radius,
    EdgeInsetsGeometry? padding,
    bool showHandle = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color backgroundColor = MyColors.white,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: MyColors.black.withValues(alpha: 0.45),
      builder: (ctx) => CustomBottomSheetWidget(
        heightFactor: heightFactor,
        radius: radius,
        padding: padding,
        showHandle: showHandle,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxH = media.size.height * (heightFactor ?? 0.98);
    final r = radius ?? 16.r;

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
          child: Material(
            color: backgroundColor,
            elevation: 0,
            borderRadius: BorderRadius.vertical(top: Radius.circular(r)),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: maxH,
              child: Column(
                children: [
                  if (showHandle) ...[
                    SizedBox(height: 10.h),
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: MyColors.borderSubtle,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                  Expanded(
                    child: SingleChildScrollView(
                      padding: padding ??
                          EdgeInsets.fromLTRB(
                            20.w,
                            8.h,
                            20.w,
                            16.h + media.padding.bottom,
                          ),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
