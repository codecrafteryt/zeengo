import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../data/models/task_model/ops_task_model.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../custom_bottom_sheet_widget.dart';
import '../custom_text_widget.dart';

class OpsTaskDetailSheet {
  OpsTaskDetailSheet._();

  static Future<void> show(BuildContext context, OpsTask task) {
    final palette = AppPalette.of(context);
    final title = task.title?.trim().isNotEmpty == true
        ? task.title!.trim()
        : Enus.taskDetail.tr;
    final notes = task.description?.trim() ?? '';
    final due = task.dueDate?.trim() ?? '';

    return CustomBottomSheetWidget.show(
      context: context,
      heightFactor: 0.45,
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            title,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _chip(
                task.isUrgent
                    ? Enus.taskPriorityUrgent.tr
                    : Enus.taskPriorityNormal.tr,
                task.isUrgent ? MyColors.red : palette.textSecondary,
              ),
              _chip(
                task.isDone
                    ? Enus.taskStatusDone.tr
                    : Enus.taskStatusOpen.tr,
                task.isDone ? palette.textSecondary : MyColors.darkPurple,
              ),
              if ((task.znCode ?? '').isNotEmpty)
                _chip(task.znCode!, MyColors.darkPurple),
            ],
          ),
          if (due.isNotEmpty) ...[
            SizedBox(height: 14.h),
            CustomTextWidget(
              Enus.taskDue.trParams({'date': due}),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: palette.textSecondary,
            ),
          ],
          if (notes.isNotEmpty) ...[
            SizedBox(height: 16.h),
            CustomTextWidget(
              notes,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: palette.textPrimary,
              height: 1.4,
            ),
          ],
        ],
      ),
    );
  }

  static Widget _chip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomTextWidget(
        label,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
