import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../custom_text_widget.dart';

class AiSuggestionChips extends StatelessWidget {
  const AiSuggestionChips({
    super.key,
    required this.suggestions,
    required this.onSelected,
  });

  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final text = suggestions[i];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelected(text),
              borderRadius: BorderRadius.circular(22.r),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: palette.cardMuted,
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(
                    color: MyColors.darkPurple.withValues(alpha: 0.45),
                  ),
                ),
                child: CustomTextWidget(
                  text,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
