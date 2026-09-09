import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/chat_controller.dart';
import '../../../data/enus.dart';
import '../../../data/models/chat_model/chat_model.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../../widgets/app_loading_dots.dart';
import '../../widgets/app_segment_tabs.dart';
import '../../widgets/chat/chat_message_bubble.dart';
import '../../widgets/chat/chat_thread_panel.dart';
import '../../widgets/chat/chat_whatsapp_banner.dart';
import '../../widgets/custom_text_widget.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  static const _whatsappNumber = '+79160000000';
  static const _supportTab = 0;
  static const _driverTab = 1;

  final _controller = TextEditingController();
  final _composerFocus = FocusNode();
  late final ChatController chat;
  int _tab = _supportTab;

  @override
  void initState() {
    super.initState();
    chat = Get.find<ChatController>();
    _composerFocus.addListener(() {
      if (mounted) setState(() {});
    });
    _controller.addListener(() {
      chat.onComposerChanged(_controller.text);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chat.openSupportThread();
    });
  }

  @override
  void dispose() {
    chat.leaveThread();
    _composerFocus.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send([String? text]) async {
    final value = (text ?? _controller.text).trim();
    if (value.isEmpty) return;
    _controller.clear();
    await chat.sendMessage(
      value,
      senderRole: ChatApiMessage.roleForTab(_tab),
    );
  }

  Future<void> _openWhatsapp() async {
    final uri = Uri.parse('https://wa.me/$_whatsappNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  List<ChatMessage> _mapMessages(List<ChatApiMessage> api) {
    final myId = chat.myClientId;
    return api
        .where((m) => m.matchesInboxTab(_tab))
        .map(
          (m) {
            final mine = m.isMine(myId);
            String? name;
            if (!mine) {
              final fromApi = m.senderName?.trim();
              name = (fromApi != null && fromApi.isNotEmpty)
                  ? fromApi
                  : m.roleLabel(
                      support: Enus.support.tr,
                      driver: Enus.driver.tr,
                      splizer: Enus.splizer.tr,
                    );
            }
            return ChatMessage(
              text: chat.bubbleText(m),
              isMine: mine,
              time: m.timeLabel,
              senderName: name,
            );
          },
        )
        .toList();
  }

  String _typingStatusForChannel(String? channel) {
    final name = chat.typingSenderName.value?.trim();
    if (name != null && name.isNotEmpty) {
      return Enus.userTyping.trParams({'name': name});
    }
    switch (channel) {
      case 'driver':
        return Enus.driverTyping.tr;
      case 'splizer':
        return Enus.splizerTyping.tr;
      default:
        return Enus.supportTyping.tr;
    }
  }

  /// Prefer socket-resolved / latest staff [senderName]; else role label.
  String _typingSenderLabel() {
    final fromSocket = chat.typingSenderName.value?.trim();
    if (fromSocket != null && fromSocket.isNotEmpty) return fromSocket;

    final channel = chat.typingChannel.value ?? 'admin';
    for (var i = chat.messages.length - 1; i >= 0; i--) {
      final m = chat.messages[i];
      if (m.senderType != 'staff') continue;
      if (m.inboxChannel != channel) continue;
      final name = m.senderName?.trim();
      if (name != null && name.isNotEmpty) return name;
    }
    switch (channel) {
      case 'driver':
        return Enus.driver.tr;
      case 'splizer':
        return Enus.splizer.tr;
      default:
        return Enus.support.tr;
    }
  }

  /// Header title above Online: latest staff [senderName] for this tab.
  String _headerTitleForTab() {
    for (var i = chat.messages.length - 1; i >= 0; i--) {
      final m = chat.messages[i];
      if (!m.matchesInboxTab(_tab)) continue;
      if (m.senderType != 'staff') continue;
      final name = m.senderName?.trim();
      if (name != null && name.isNotEmpty) return name;
    }
    if (_tab == _driverTab) return Enus.driver.tr;
    if (_tab == 2) return Enus.splizer.tr;
    return Enus.zeengoSupport.tr;
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return ColoredBox(
      color: palette.scaffold,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final short =
                  _composerFocus.hasFocus || constraints.maxHeight < 520;

              return Column(
                children: [
                  AppSegmentTabs(
                    index: _tab,
                    onChanged: (i) {
                      setState(() => _tab = i);
                      _controller.clear();
                    },
                    tabs: [
                      AppSegmentTab(
                        label: Enus.support.tr,
                        svgAsset: MyImages.chatHeadset,
                      ),
                      AppSegmentTab(
                        label: Enus.driver.tr,
                        svgAsset: MyImages.chatCar,
                      ),
                      AppSegmentTab(
                        label: Enus.splizer.tr,
                        svgAsset: MyImages.chatBriefcase,
                      ),
                    ],
                  ),
                  SizedBox(height: short ? 8.h : 12.h),
                  Expanded(
                    child: Obx(() {
                      chat.isPeerTyping.value;
                      chat.typingChannel.value;
                      chat.typingSenderName.value;
                      chat.messages.length;
                      chat.isLoading.value;
                      chat.errorMessage.value;

                      if (_tab == _supportTab) {
                        return _buildLivePanel(
                          palette: palette,
                          short: short,
                          title: _headerTitleForTab(),
                          svgAsset: MyImages.chatHeadset,
                          accent: MyColors.darkPurple,
                          emptyMessage: Enus.startChatSupport.tr,
                        );
                      }
                      if (_tab == _driverTab) {
                        return _buildLivePanel(
                          palette: palette,
                          short: short,
                          title: _headerTitleForTab(),
                          svgAsset: MyImages.chatCar,
                          accent: const Color(0xFF2563EB),
                          emptyMessage: Enus.startChatDriver.tr,
                        );
                      }
                      return _buildLivePanel(
                        palette: palette,
                        short: short,
                        title: _headerTitleForTab(),
                        svgAsset: MyImages.chatBriefcase,
                        accent: MyColors.purple,
                        emptyMessage: Enus.startChatSplizer.tr,
                      );
                    }),
                  ),
                  if (!short) ...[
                    SizedBox(height: 12.h),
                    ChatWhatsappBanner(
                      title: Enus.whatsappZeengo.tr,
                      subtitle: Enus.whatsappSubtitle.tr,
                      onTap: _openWhatsapp,
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLivePanel({
    required AppPalette palette,
    required bool short,
    required String title,
    required String svgAsset,
    required Color accent,
    required String emptyMessage,
  }) {
    final loading = chat.isLoading.value && chat.messages.isEmpty;
    final error = chat.errorMessage.value;
    final typingHere = chat.isTypingOnTab(_tab);
    final status = typingHere
        ? _typingStatusForChannel(chat.typingChannel.value)
        : Enus.online.tr;
    final mapped = _mapMessages(chat.messages);

    if (loading) {
      return const Center(child: AppLoadingDots());
    }

    if (error != null && error.isNotEmpty && chat.messages.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextWidget(
                error,
                textAlign: TextAlign.center,
                fontSize: 14.sp,
                color: palette.textSecondary,
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: chat.openSupportThread,
                child: CustomTextWidget(
                  Enus.retry.tr,
                  color: MyColors.darkPurple,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ChatThreadPanel(
      title: title,
      svgAsset: svgAsset,
      accent: accent,
      statusLabel: status,
      emptyMessage: emptyMessage,
      messages: mapped,
      composerHint: Enus.typeMessage.tr,
      controller: _controller,
      focusNode: _composerFocus,
      onSend: _send,
      compact: short,
      isTyping: typingHere,
      typingLabel: typingHere ? _typingSenderLabel() : null,
    );
  }
}
