import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../custom_text_widget.dart';

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isMine,
    required this.time,
    this.senderName,
  });

  final String text;
  final bool isMine;
  final String time;
  final String? senderName;
}

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final mine = message.isMine;
    final bubble = Container(
      constraints: BoxConstraints(maxWidth: 0.72.sw),
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 8.h),
      decoration: BoxDecoration(
        color: mine ? MyColors.darkPurple : palette.cardMuted,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
          bottomLeft: Radius.circular(mine ? 18.r : 4.r),
          bottomRight: Radius.circular(mine ? 4.r : 18.r),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            message.text,
            fontSize: 14.sp,
            height: 1.35,
            fontWeight: FontWeight.w500,
            color: mine ? MyColors.white : palette.textPrimary,
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextWidget(
                message.time,
                fontSize: 10.sp,
                color: mine
                    ? MyColors.white.withValues(alpha: 0.75)
                    : palette.textSecondary,
              ),
              if (mine) ...[
                SizedBox(width: 4.w),
                Icon(
                  Icons.done_all_rounded,
                  size: 14.sp,
                  color: MyColors.white.withValues(alpha: 0.85),
                ),
              ],
            ],
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment:
            mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine) ...[
            _Avatar(label: message.senderName?.characters.first ?? '?'),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!mine && message.senderName != null) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
                    child: CustomTextWidget(
                      message.senderName!,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: MyColors.darkPurple,
                    ),
                  ),
                ],
                bubble,
              ],
            ),
          ),
          if (mine) ...[
            SizedBox(width: 8.w),
            const _Avatar(label: 'Me', isMine: true),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.label, this.isMine = false});

  final String label;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14.r,
      backgroundColor: isMine
          ? MyColors.darkPurple.withValues(alpha: 0.15)
          : MyColors.purple.withValues(alpha: 0.15),
      child: CustomTextWidget(
        label.characters.first.toUpperCase(),
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: isMine ? MyColors.darkPurple : MyColors.purple,
      ),
    );
  }
}
