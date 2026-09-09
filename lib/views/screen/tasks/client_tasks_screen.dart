import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/task_controller.dart';
import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../widgets/custom_text_widget.dart';
import '../../widgets/explore/ops_task_tile.dart';

class ClientTasksScreen extends GetView<TaskController> {
  const ClientTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: palette.scaffold,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(8.w, top + 8.h, 16.w, 12.h),
            color: palette.card,
            child: Row(
              children: [
                IconButton(
                  onPressed: Get.back,
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20.sp,
                    color: palette.icon,
                  ),
                ),
                Expanded(
                  child: CustomTextWidget(
                    Enus.opsTasks.tr,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                ),
                Obx(() {
                  final zn = controller.znCode.value;
                  if (zn.isEmpty) return const SizedBox.shrink();
                  return CustomTextWidget(
                    zn,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: MyColors.darkPurple,
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
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
                return Center(
                  child:
                      CircularProgressIndicator(color: MyColors.darkPurple),
                );
              }

              final error = controller.errorMessage.value;
              if (error != null &&
                  error.isNotEmpty &&
                  controller.items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextWidget(
                          error,
                          textAlign: TextAlign.center,
                          color: palette.textSecondary,
                        ),
                        SizedBox(height: 12.h),
                        TextButton(
                          onPressed: controller.fetchTasks,
                          child: CustomTextWidget(
                            Enus.viewAllTasks.tr,
                            color: MyColors.darkPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.items.isEmpty) {
                return Center(
                  child: CustomTextWidget(
                    Enus.noOpenTasks.tr,
                    color: palette.textSecondary,
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
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                    itemCount: controller.items.length +
                        (controller.isLoadingMore.value ? 1 : 0),
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (_, i) {
                      if (i >= controller.items.length) {
                        return Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: MyColors.darkPurple,
                            ),
                          ),
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
