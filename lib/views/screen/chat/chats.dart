/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: chat
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../widgets/coming_soon_placeholder.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ComingSoonPlaceholder(
        title: Enus.messages.tr,
        icon: Icons.chat_bubble_outline_rounded,
        message: Enus.messagesMessage.tr,
      ),
    );
  }
}
