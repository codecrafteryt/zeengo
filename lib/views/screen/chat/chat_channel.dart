import 'package:flutter/material.dart';

import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../../widgets/chat/chat_message_bubble.dart';

class ChatChannel {
  const ChatChannel({
    required this.title,
    required this.svgAsset,
    required this.accent,
    required this.emptyMessage,
    required this.quickReplies,
    this.seedMessages = const [],
  });

  final String title;
  final String svgAsset;
  final Color accent;
  final String emptyMessage;
  final List<String> quickReplies;
  final List<ChatMessage> seedMessages;
}

class ChatChannels {
  ChatChannels._();

  static List<ChatChannel> demo({
    required String supportTitle,
    required String driverTitle,
    required String splizerTitle,
    required String supportEmpty,
    required String driverEmpty,
    required String splizerEmpty,
    required List<String> supportReplies,
    required List<String> driverReplies,
    required List<String> splizerReplies,
  }) {
    return [
      ChatChannel(
        title: supportTitle,
        svgAsset: MyImages.chatHeadset,
        accent: MyColors.darkPurple,
        emptyMessage: supportEmpty,
        quickReplies: supportReplies,
        seedMessages: const [
          ChatMessage(
            text: 'Hi, I need help 👋',
            isMine: true,
            time: '11:20',
          ),
        ],
      ),
      ChatChannel(
        title: driverTitle,
        svgAsset: MyImages.chatCar,
        accent: const Color(0xFF2563EB),
        emptyMessage: driverEmpty,
        quickReplies: driverReplies,
      ),
      ChatChannel(
        title: splizerTitle,
        svgAsset: MyImages.chatBriefcase,
        accent: MyColors.purple,
        emptyMessage: splizerEmpty,
        quickReplies: splizerReplies,
        seedMessages: const [
          ChatMessage(
            text: 'hello',
            isMine: false,
            time: '21:29',
            senderName: 'Amine Lahouideg',
          ),
          ChatMessage(
            text: 'Can you help? 🙏',
            isMine: true,
            time: '11:36',
          ),
        ],
      ),
    ];
  }
}
