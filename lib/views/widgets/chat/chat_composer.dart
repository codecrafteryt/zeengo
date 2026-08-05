import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';

class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.hint,
    required this.onSend,
    this.focusNode,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback onSend;
  final FocusNode? focusNode;

  static const double height = 50;
  static const double radius = 8;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  late final FocusNode _focus;
  late final bool _ownsFocus;

  @override
  void initState() {
    super.initState();
    _ownsFocus = widget.focusNode == null;
    _focus = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (_ownsFocus) {
      _focus.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final fieldColor = palette.cardMuted;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(ChatComposer.radius),
      borderSide: BorderSide.none,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ChatComposer.radius),
            child: Container(
              height: ChatComposer.height,
              alignment: Alignment.center,
              color: fieldColor,
              child: TextField(
                focusNode: _focus,
                controller: widget.controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => widget.onSend(),
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
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 14.h,
                  ),
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    height: 1.2,
                    color: palette.textSecondary,
                  ),
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
            onTap: widget.onSend,
            child: SizedBox(
              width: ChatComposer.height,
              height: ChatComposer.height,
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
