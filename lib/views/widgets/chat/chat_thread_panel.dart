import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/values/my_color.dart';
import '../app_card.dart';
import 'chat_composer.dart';
import 'chat_empty_state.dart';
import 'chat_message_bubble.dart';
import 'chat_quick_replies.dart';
import 'chat_thread_header.dart';

/// Airbnb-style chat thread panel (header + messages + quick replies + composer).
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

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
      child: Column(
        children: [
          ChatThreadHeader(
            title: title,
            svgAsset: svgAsset,
            statusLabel: statusLabel,
            accent: accent,
          ),
          Divider(height: 24.h, color: MyColors.borderSubtle),
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
          ChatQuickReplies(items: quickReplies, onSelected: onQuickReply),
          SizedBox(height: 10.h),
          ChatComposer(
            controller: controller,
            hint: composerHint,
            onSend: onSend,
          ),
        ],
      ),
    );
  }
}
