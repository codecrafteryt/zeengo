import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../chat/chat_composer.dart';
import '../chat/chat_message_bubble.dart';
import '../custom_bottom_sheet_widget.dart';
import '../custom_header_bar_widget.dart';
import 'ai_empty_state.dart';
import 'ai_suggestion_chips.dart';

/// Airbnb-style AI Assistant bottom sheet (local chat preview).
class AiAssistantSheet extends StatefulWidget {
  const AiAssistantSheet({super.key});

  static Future<void> show(BuildContext context) {
    final palette = AppPalette.of(context);
    return CustomBottomSheetWidget.show(
      context: context,
      heightFactor: 0.98,
      radius: 16.r,
      showHandle: false,
      scrollable: false,
      padding: EdgeInsets.fromLTRB(
        18.w,
        8.h,
        18.w,
        12.h + MediaQuery.paddingOf(context).bottom,
      ),
      backgroundColor: palette.card,
      child: const AiAssistantSheet(),
    );
  }

  @override
  State<AiAssistantSheet> createState() => _AiAssistantSheetState();
}

class _AiAssistantSheetState extends State<AiAssistantSheet> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _replying = false;

  List<String> get _suggestions => [
        Enus.aiSuggestionProgram.tr,
        Enus.aiSuggestionHalal.tr,
        Enus.aiSuggestionHotel.tr,
      ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _nowLabel() {
    final n = TimeOfDay.now();
    final h = n.hourOfPeriod == 0 ? 12 : n.hourOfPeriod;
    final m = n.minute.toString().padLeft(2, '0');
    final p = n.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  Future<void> _send(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || _replying) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text, isMine: true, time: _nowLabel()),
      );
      _controller.clear();
      _replying = true;
    });
    _scrollToEnd();

    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: Enus.aiLocalReply.tr,
          isMine: false,
          time: _nowLabel(),
          senderName: Enus.claudeAiAssistant.tr,
        ),
      );
      _replying = false;
    });
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final empty = _messages.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CustomHeaderBarWidget(),
        SizedBox(height: 12.h),
        Expanded(
          child: empty
              ? AiEmptyState(
                  title: Enus.askTripAnything.tr,
                  subtitle: Enus.askTripAnythingAr.tr,
                )
              : ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
                  itemCount: _messages.length + (_replying ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (_replying && i == _messages.length) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h, left: 4.w),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: MyColors.darkPurple.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ChatMessageBubble(message: _messages[i]);
                  },
                ),
        ),
        if (empty) ...[
          SizedBox(height: 8.h),
          AiSuggestionChips(
            suggestions: _suggestions,
            onSelected: _send,
          ),
        ],
        SizedBox(height: 12.h),
        ChatComposer(
          controller: _controller,
          hint: Enus.askAnythingHint.tr,
          onSend: () => _send(_controller.text),
        ),
      ],
    );
  }
}
