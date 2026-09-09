import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controller/task_controller.dart';
import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../../widgets/app_loading_dots.dart';
import '../../widgets/custom_text_widget.dart';
import '../../widgets/explore/ops_task_tile.dart';

class ClientTasksScreen extends StatefulWidget {
  const ClientTasksScreen({super.key});

  @override
  State<ClientTasksScreen> createState() => _ClientTasksScreenState();
}

class _ClientTasksScreenState extends State<ClientTasksScreen> {
  late final TaskController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<TaskController>();
    controller.filter.value = 'open';
    controller.seedFromHome();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTasks(showLoader: controller.items.isEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

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
          Enus.schedule.tr,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
            child: Obx(() {
              final f = controller.filter.value;
              return Row(
                children: [
                  Expanded(
                    child: _FilterChip(
                      label: Enus.taskStatusOpen.tr,
                      selected: f == 'open',
                      onTap: () => controller.setFilter('open'),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _FilterChip(
                      label: Enus.taskStatusDone.tr,
                      selected: f == 'done',
                      onTap: () => controller.setFilter('done'),
                    ),
                  ),
                ],
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.items.isEmpty) {
                return const Center(child: AppLoadingDots());
              }

              final error = controller.errorMessage.value;
              if (error != null &&
                  error.isNotEmpty &&
                  controller.items.isEmpty) {
                return RefreshIndicator(
                  color: MyColors.darkPurple,
                  onRefresh: () => controller.fetchTasks(showLoader: false),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      SizedBox(height: 120.h),
                      Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          children: [
                            CustomTextWidget(
                              error,
                              textAlign: TextAlign.center,
                              fontSize: 14.sp,
                              color: palette.textSecondary,
                            ),
                            SizedBox(height: 12.h),
                            TextButton(
                              onPressed: () => controller.fetchTasks(),
                              child: CustomTextWidget(
                                Enus.viewAllTasks.tr,
                                color: MyColors.darkPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (controller.items.isEmpty) {
                return RefreshIndicator(
                  color: MyColors.darkPurple,
                  onRefresh: () => controller.fetchTasks(showLoader: false),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      SizedBox(height: 140.h),
                      Center(
                        child: CustomTextWidget(
                          controller.filter.value == 'done'
                              ? Enus.noDoneTasks.tr
                              : Enus.noOpenTasks.tr,
                          fontSize: 14.sp,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: MyColors.darkPurple,
                onRefresh: () => controller.fetchTasks(showLoader: false),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n.metrics.pixels >=
                        n.metrics.maxScrollExtent - 80) {
                      controller.loadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                    itemCount: controller.items.length +
                        (controller.isLoadingMore.value ? 1 : 0),
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (_, i) {
                      if (i >= controller.items.length) {
                        return Padding(
                          padding: EdgeInsets.all(16.w),
                          child: const Center(child: AppLoadingDots(size: 36)),
                        );
                      }
                      return OpsTaskTile(task: controller.items[i]);
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Material(
      color: selected
          ? MyColors.darkPurple.withValues(alpha: 0.14)
          : palette.card,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected ? MyColors.darkPurple : palette.border,
            ),
          ),
          child: CustomTextWidget(
            label,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: selected ? MyColors.darkPurple : palette.textPrimary,
          ),
        ),
      ),
    );
  }
}
