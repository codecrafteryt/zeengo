import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';

class ChatComposer extends StatelessWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.hint,
    required this.onSend,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback onSend;

  static const double _height = 50;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    // One solid fill — avoid theme InputDecorationTheme dark fill showing through.
    final fieldColor = palette.cardMuted;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: _height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: fieldColor,
              borderRadius: BorderRadius.circular(_height / 2),
            ),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              cursorColor: MyColors.darkPurple,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.2,
                color: palette.textPrimary,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                filled: true,
                fillColor: fieldColor,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 14.h,
                ),
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  height: 1.2,
                  color: palette.textSecondary,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Material(
          color: MyColors.darkPurple,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onSend,
            child: SizedBox(
              width: _height,
              height: _height,
              child: Center(
                child: SvgPicture.asset(
                  MyImages.chatSend,
                  width: 20.sp,
                  height: 20.sp,
                  colorFilter: const ColorFilter.mode(
                    MyColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
