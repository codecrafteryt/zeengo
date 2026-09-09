import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/app_palette.dart';
import '../app_card.dart';
import 'chat_composer.dart';
import 'chat_empty_state.dart';
import 'chat_message_bubble.dart';
import 'chat_thread_header.dart';
import 'chat_typing_indicator.dart';

/// Airbnb-style chat thread panel (header + messages + composer).
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
    required this.composerHint,
    required this.controller,
    required this.onSend,
    this.compact = false,
    this.focusNode,
    this.isTyping = false,
    this.typingLabel,
  });

  final String title;
  final String svgAsset;
  final Color accent;
  final String statusLabel;
  final String emptyMessage;
  final List<ChatMessage> messages;
  final String composerHint;
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool compact;
  final FocusNode? focusNode;
  final bool isTyping;
  final String? typingLabel;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 10.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;
          final showHeader = h >= 160;
          final showTyping =
              isTyping && (typingLabel?.trim().isNotEmpty ?? false);

          return Column(
            children: [
              if (showHeader) ...[
                ChatThreadHeader(
                  title: title,
                  svgAsset: svgAsset,
                  statusLabel: statusLabel,
                  accent: accent,
                  isOnline: true,
                ),
                Divider(height: 20.h, color: palette.border),
              ],
              Expanded(
                child: messages.isEmpty && !showTyping
                    ? ChatEmptyState(message: emptyMessage)
                    : ListView.builder(
                        reverse: true,
                        padding: EdgeInsets.only(bottom: 8.h),
                        itemCount: messages.length + (showTyping ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (showTyping && i == 0) {
                            return ChatTypingIndicator(label: typingLabel!);
                          }
                          final msgIndex =
                              messages.length - 1 - (showTyping ? i - 1 : i);
                          return ChatMessageBubble(message: messages[msgIndex]);
                        },
                      ),
              ),
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
