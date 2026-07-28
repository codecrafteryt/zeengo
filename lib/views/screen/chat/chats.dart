/*
  ---------------------------------------
  Project: khelo yaar Mobile Application
  Date: March 31, 2024
  Author: Ameer Salman
  ---------------------------------------
  Description: chat
*/

import 'package:flutter/material.dart';

import '../../widgets/coming_soon_placeholder.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ComingSoonPlaceholder(
        title: 'Messages',
        icon: Icons.chat_bubble_outline_rounded,
        message:
            'Chat with hosts and stay on top of your bookings — launching soon.',
      ),
    );
  }
}
