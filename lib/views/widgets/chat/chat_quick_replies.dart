import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';

class ChatQuickReplies extends StatelessWidget {
  const ChatQuickReplies({
    super.key,
    required this.items,
    required this.onSelected,
  });

  final List<String> items;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final text = items[i];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelected(text),
              borderRadius: BorderRadius.circular(22.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: MyColors.white,
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(
                    color: MyColors.darkPurple.withValues(alpha: 0.45),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: MyColors.blackDark,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
