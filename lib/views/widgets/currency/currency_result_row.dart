import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/app_palette.dart';
import '../custom_text_widget.dart';

class CurrencyResultRow extends StatelessWidget {
  const CurrencyResultRow({
    super.key,
    required this.code,
    required this.value,
    required this.accent,
  });

  final String code;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark ? palette.cardMuted : palette.scaffold,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: palette.border.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          CustomTextWidget(
            code,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: palette.textSecondary,
          ),
          const Spacer(),
          CustomTextWidget(
            value,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: accent,
          ),
        ],
      ),
    );
  }
}
