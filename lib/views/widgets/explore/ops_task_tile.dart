import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../data/models/task_model/ops_task_model.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../custom_text_widget.dart';
import 'ops_task_detail_sheet.dart';

class OpsTaskTile extends StatelessWidget {
  const OpsTaskTile({super.key, required this.task, this.compact = false});

  final OpsTask task;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final title = task.title?.trim().isNotEmpty == true
        ? task.title!.trim()
        : Enus.opsTasks.tr;
    final notes = task.description?.trim() ?? '';
    final due = task.dueDate?.trim() ?? '';
    final done = task.isDone;
    final urgent = task.isUrgent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => OpsTaskDetailSheet.show(context, task),
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: palette.cardMuted,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: palette.border.withValues(alpha: 0.65)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextWidget(
                      title,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: done
                          ? palette.textSecondary
                          : palette.textPrimary,
                      decoration:
                          done ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _Badge(
                    label: urgent
                        ? Enus.taskPriorityUrgent.tr
                        : Enus.taskPriorityNormal.tr,
                    color: urgent
                        ? MyColors.red
                        : palette.textSecondary,
                    bg: urgent
                        ? MyColors.red.withValues(alpha: 0.12)
                        : palette.border.withValues(alpha: 0.35),
                  ),
                ],
              ),
              if (!compact && notes.isNotEmpty) ...[
                SizedBox(height: 6.h),
                CustomTextWidget(
                  notes,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: palette.textSecondary,
                ),
              ],
              SizedBox(height: 8.h),
              Row(
                children: [
                  _Badge(
                    label: done
                        ? Enus.taskStatusDone.tr
                        : Enus.taskStatusOpen.tr,
                    color: done ? palette.textSecondary : MyColors.darkPurple,
                    bg: done
                        ? palette.border.withValues(alpha: 0.35)
                        : MyColors.darkPurple.withValues(alpha: 0.12),
                  ),
                  if (due.isNotEmpty) ...[
                    SizedBox(width: 8.w),
                    CustomTextWidget(
                      Enus.taskDue.trParams({'date': due}),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: palette.textSecondary,
                    ),
                  ],
                  const Spacer(),
                  if ((task.znCode ?? '').isNotEmpty)
                    CustomTextWidget(
                      task.znCode!,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: MyColors.darkPurple,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.bg,
  });

  final String label;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomTextWidget(
        label,
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}
