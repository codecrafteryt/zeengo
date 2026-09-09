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
          (m) => ChatMessage(
            text: chat.bubbleText(m),
            isMine: m.isMine(myId),
            time: m.timeLabel,
            senderName: m.isMine(myId)
                ? null
                : m.inboundLabel(
                    support: Enus.support.tr,
                    driver: Enus.driver.tr,
                    splizer: Enus.splizer.tr,
                  ),
          ),
        )
        .toList();
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
                      if (_tab == _supportTab) {
                        return _buildLivePanel(
                          palette: palette,
                          short: short,
                          title: chat.conversation.value?.title
                                      ?.trim()
                                      .isNotEmpty ==
                                  true
                              ? chat.conversation.value!.title!.trim()
                              : Enus.zeengoSupport.tr,
                          svgAsset: MyImages.chatHeadset,
                          accent: MyColors.darkPurple,
                          emptyMessage: Enus.startChatSupport.tr,
                          quickReplies: [
                            Enus.qrNeedHelp.tr,
                            Enus.qrDriverArrive.tr,
                            Enus.qrBookRestaurant.tr,
                          ],
                        );
                      }
                      if (_tab == _driverTab) {
                        return _buildLivePanel(
                          palette: palette,
                          short: short,
                          title: Enus.driver.tr,
                          svgAsset: MyImages.chatCar,
                          accent: const Color(0xFF2563EB),
                          emptyMessage: Enus.startChatDriver.tr,
                          quickReplies: [
                            Enus.qrWhereAreYou.tr,
                            Enus.qrWhenArrive.tr,
                            Enus.qrAtEntrance.tr,
                          ],
                        );
                      }
                      return _buildLivePanel(
                        palette: palette,
                        short: short,
                        title: Enus.splizer.tr,
                        svgAsset: MyImages.chatBriefcase,
                        accent: MyColors.purple,
                        emptyMessage: Enus.startChatSplizer.tr,
                        quickReplies: [
                          Enus.qrCanYouHelp.tr,
                          Enus.qrItinerary.tr,
                          Enus.qrChangeBooking.tr,
                        ],
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
    required List<String> quickReplies,
  }) {
    final loading = chat.isLoading.value && chat.messages.isEmpty;
    final error = chat.errorMessage.value;
    final status = chat.supportTyping.value
        ? Enus.supportTyping.tr
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
      quickReplies: quickReplies,
      composerHint: Enus.typeMessage.tr,
      controller: _controller,
      focusNode: _composerFocus,
      onSend: _send,
      onQuickReply: _send,
      compact: short,
    );
  }
}
