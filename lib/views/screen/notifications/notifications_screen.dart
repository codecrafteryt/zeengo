import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controller/notification_controller.dart';
import '../../../data/enus.dart';
import '../../../data/models/notification_model/notification_model.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../../widgets/custom_text_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<NotificationController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchNotifications(refresh: true);
      controller.fetchUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: palette.scaffold,
      appBar: AppBar(
        backgroundColor: palette.scaffold,
        elevation: 0,
        surfaceTintColor: palette.card,
        leading: GestureDetector(
          onTap: () => Get.back(),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SizedBox(
              width: 20.w,
              height: 20.h,
              child: SvgPicture.asset(
                MyImages.arrowBackFlatSvg,
                width: 20.w,
                height: 20.h,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(palette.icon, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        leadingWidth: 48,
        title: CustomTextWidget(
          Enus.notifications.tr,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            if (controller.unreadCount.value <= 0) {
              return SizedBox(width: 12.w);
            }
            return TextButton(
              onPressed: controller.markAllAsRead,
              child: CustomTextWidget(
                'Mark all',
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: MyColors.darkPurple,
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null &&
            controller.items.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextWidget(
                    controller.errorMessage.value!,
                    textAlign: TextAlign.center,
                    fontSize: 14.sp,
                    color: palette.textSecondary,
                  ),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () =>
                        controller.fetchNotifications(refresh: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.items.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h + bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    MyImages.noNotifications,
                    width: 180.w,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.notifications_none_rounded,
                      size: 96.sp,
                      color: MyColors.gray100,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomTextWidget(
                    Enus.noNotifications.tr,
                    textAlign: TextAlign.center,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                  SizedBox(height: 8.h),
                  CustomTextWidget(
                    Enus.noNotificationsMessage.tr,
                    textAlign: TextAlign.center,
                    fontSize: 13.sp,
                    height: 1.4,
                    color: palette.textSecondary,
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: MyColors.darkPurple,
          onRefresh: () async {
            await controller.fetchNotifications(refresh: true);
            await controller.fetchUnreadCount();
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (scroll) {
              if (scroll.metrics.pixels >=
                  scroll.metrics.maxScrollExtent - 120) {
                controller.loadMore();
              }
              return false;
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h + bottom),
              itemCount: controller.items.length +
                  (controller.isLoadingMore.value ? 1 : 0),
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                if (index >= controller.items.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: const Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                final item = controller.items[index];
                return _NotificationTile(
                  notification: item,
                  onTap: () => controller.markAsRead(item),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final unread = notification.unread;

    return Material(
      color: unread ? palette.card : palette.cardMuted,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: unread
                  ? MyColors.darkPurple.withValues(alpha: 0.35)
                  : palette.border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.darkPurple.withValues(alpha: 0.12),
                ),
                child: Icon(
                  _iconForType(notification.type),
                  size: 20.sp,
                  color: MyColors.darkPurple,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextWidget(
                            notification.title ?? 'Zeengo',
                            fontSize: 14.sp,
                            fontWeight:
                                unread ? FontWeight.w700 : FontWeight.w600,
                            color: palette.textPrimary,
                          ),
                        ),
                        if (unread)
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColors.darkPurple,
                            ),
                          ),
                      ],
                    ),
                    if ((notification.body ?? '').isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      CustomTextWidget(
                        notification.body!,
                        fontSize: 13.sp,
                        height: 1.35,
                        color: palette.textSecondary,
                      ),
                    ],
                    if ((notification.createdAt ?? '').isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      CustomTextWidget(
                        _formatTime(notification.createdAt!),
                        fontSize: 11.sp,
                        color: palette.textSecondary,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(String? type) {
    switch (type) {
      case 'chat':
        return Icons.chat_bubble_outline_rounded;
      case 'payment':
        return Icons.payments_outlined;
      case 'assignment':
        return Icons.directions_car_outlined;
      case 'vip':
        return Icons.star_outline_rounded;
      case 'edit_request':
        return Icons.edit_note_rounded;
      case 'sos':
        return Icons.emergency_outlined;
      case 'program':
        return Icons.event_note_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}
