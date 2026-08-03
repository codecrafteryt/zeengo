import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/enus.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../../widgets/app_segment_tabs.dart';
import '../../widgets/chat/chat_message_bubble.dart';
import '../../widgets/chat/chat_thread_panel.dart';
import '../../widgets/chat/chat_whatsapp_banner.dart';
import 'chat_channel.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  static const _whatsappNumber = '+79160000000';

  final _controller = TextEditingController();
  int _tab = 1;
  late List<List<ChatMessage>> _threads;

  List<ChatChannel> get _channels => ChatChannels.demo(
        supportTitle: Enus.zeengoSupport.tr,
        driverTitle: 'Alexei Sokolov',
        splizerTitle: 'Khalid Al-Zahrani',
        supportEmpty: Enus.startChatSupport.tr,
        driverEmpty: Enus.startChatDriver.tr,
        splizerEmpty: Enus.startChatSplizer.tr,
        supportReplies: [
          Enus.qrNeedHelp.tr,
          Enus.qrDriverArrive.tr,
          Enus.qrBookRestaurant.tr,
        ],
        driverReplies: [
          Enus.qrWhereAreYou.tr,
          Enus.qrWhenArrive.tr,
          Enus.qrAtEntrance.tr,
        ],
        splizerReplies: [
          Enus.qrCanYouHelp.tr,
          Enus.qrItinerary.tr,
          Enus.qrChangeBooking.tr,
        ],
      );

  @override
  void initState() {
    super.initState();
    _threads = _channels.map((c) => List<ChatMessage>.from(c.seedMessages)).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final value = (text ?? _controller.text).trim();
    if (value.isEmpty) return;
    final now = TimeOfDay.now();
    final stamped =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    setState(() {
      _threads[_tab].add(ChatMessage(text: value, isMine: true, time: stamped));
      _controller.clear();
    });
  }

  Future<void> _openWhatsapp() async {
    final uri = Uri.parse('https://wa.me/$_whatsappNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final channels = _channels;
    final channel = channels[_tab];

    return Scaffold(
      backgroundColor: MyColors.scaffoldMuted,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, top + 12.h, 16.w, 12.h + bottom),
        child: Column(
          children: [
            AppSegmentTabs(
              index: _tab,
              onChanged: (i) => setState(() => _tab = i),
              tabs: [
                AppSegmentTab(label: Enus.support.tr, svgAsset: MyImages.chatHeadset),
                AppSegmentTab(label: Enus.driver.tr, svgAsset: MyImages.chatCar),
                AppSegmentTab(label: Enus.splizer.tr, svgAsset: MyImages.chatBriefcase),
              ],
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: ChatThreadPanel(
                title: channel.title,
                svgAsset: channel.svgAsset,
                accent: channel.accent,
                statusLabel: Enus.online.tr,
                emptyMessage: channel.emptyMessage,
                messages: _threads[_tab],
                quickReplies: channel.quickReplies,
                composerHint: Enus.typeMessage.tr,
                controller: _controller,
                onSend: _send,
                onQuickReply: _send,
              ),
            ),
            SizedBox(height: 12.h),
            ChatWhatsappBanner(
              title: Enus.whatsappZeengo.tr,
              subtitle: Enus.whatsappSubtitle.tr,
              onTap: _openWhatsapp,
            ),
          ],
        ),
      ),
    );
  }
}
