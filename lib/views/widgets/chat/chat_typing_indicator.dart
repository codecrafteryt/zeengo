import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../custom_text_widget.dart';

/// Inbound-style typing bubble with pulsing dots (WhatsApp-like).
class ChatTypingIndicator extends StatefulWidget {
  const ChatTypingIndicator({
    super.key,
    required this.label,
  });

  /// e.g. "Zeengo Admin" / "Support is typing…"
  final String label;

  @override
  State<ChatTypingIndicator> createState() => _ChatTypingIndicatorState();
}

class _ChatTypingIndicatorState extends State<ChatTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final initial = widget.label.trim().isNotEmpty
        ? widget.label.trim().characters.first.toUpperCase()
        : '?';

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, top: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 14.r,
            backgroundColor: MyColors.purple.withValues(alpha: 0.15),
            child: CustomTextWidget(
              initial,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: MyColors.purple,
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
                  child: CustomTextWidget(
                    widget.label,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: MyColors.darkPurple,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: palette.cardMuted,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.r),
                      topRight: Radius.circular(18.r),
                      bottomLeft: Radius.circular(4.r),
                      bottomRight: Radius.circular(18.r),
                    ),
                  ),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (i) {
                          final t = (_controller.value + i * 0.2) % 1.0;
                          final bounce = (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
                          final scale = 0.55 + bounce * 0.55;
                          final opacity = 0.35 + bounce * 0.65;
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Transform.translate(
                              offset: Offset(0, -4.h * bounce),
                              child: Transform.scale(
                                scale: scale,
                                child: Opacity(
                                  opacity: opacity,
                                  child: Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: const BoxDecoration(
                                      color: MyColors.darkPurple,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
