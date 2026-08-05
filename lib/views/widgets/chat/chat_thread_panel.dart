import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/app_palette.dart';
import '../app_card.dart';
import 'chat_composer.dart';
import 'chat_empty_state.dart';
import 'chat_message_bubble.dart';
import 'chat_quick_replies.dart';
import 'chat_thread_header.dart';

/// Airbnb-style chat thread panel (header + messages + quick replies + composer).
///
/// Layout is overflow-safe: non-flex chrome is dropped when height is tight
/// (keyboard / small devices), so Column never reports BOTTOM OVERFLOWED.
class ChatThreadPanel extends StatelessWidget {
  const ChatThreadPanel({
    super.key,
    required this.title,
    required this.svgAsset,
    required this.accent,
    required this.statusLabel,
    required this.emptyMessage,
    required this.messages,
    required this.quickReplies,
    required this.composerHint,
    required this.controller,
    required this.onSend,
    required this.onQuickReply,
    this.compact = false,
    this.focusNode,
  });

  final String title;
  final String svgAsset;
  final Color accent;
  final String statusLabel;
  final String emptyMessage;
  final List<ChatMessage> messages;
  final List<String> quickReplies;
  final String composerHint;
  final TextEditingController controller;
  final VoidCallback onSend;
  final ValueChanged<String> onQuickReply;
  final bool compact;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 10.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Android adjustResize shrinks height; drop chrome before overflow.
          final h = constraints.maxHeight;
          final showHeader = h >= 160;
          final showReplies = !compact && h >= 300;

          return Column(
            children: [
              if (showHeader) ...[
                ChatThreadHeader(
                  title: title,
                  svgAsset: svgAsset,
                  statusLabel: statusLabel,
                  accent: accent,
                ),
                Divider(height: 20.h, color: palette.border),
              ],
              Expanded(
                child: messages.isEmpty
                    ? ChatEmptyState(message: emptyMessage)
                    : ListView.builder(
                        reverse: true,
                        padding: EdgeInsets.only(bottom: 8.h),
                        itemCount: messages.length,
                        itemBuilder: (_, i) {
                          final msg = messages[messages.length - 1 - i];
                          return ChatMessageBubble(message: msg);
                        },
                      ),
              ),
              if (showReplies) ...[
                SizedBox(height: 8.h),
                ChatQuickReplies(
                  items: quickReplies,
                  onSelected: onQuickReply,
                ),
                SizedBox(height: 10.h),
              ] else
                SizedBox(height: 8.h),
              ChatComposer(
                controller: controller,
                hint: composerHint,
                onSend: onSend,
                focusNode: focusNode,
              ),
            ],
          );
        },
      ),
    );
  }
}
