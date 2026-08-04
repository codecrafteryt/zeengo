import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/suggestions_controller.dart';
import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../custom_bottom_sheet_widget.dart';
import '../custom_header_bar_widget.dart';
import '../custom_text_widget.dart';
import 'suggestion_tip_card.dart';

/// Explore → Suggestions bottom sheet (static now, API-ready via controller).
class SuggestionsSheet extends StatelessWidget {
  const SuggestionsSheet({super.key});

  static Future<void> show(BuildContext context) {
    final controller = Get.find<SuggestionsController>();
    controller.loadTips();

    final palette = AppPalette.of(context);
    return CustomBottomSheetWidget.show(
      context: context,
      heightFactor: 0.98,
      radius: 16.r,
      showHandle: false,
      scrollable: true,
      padding: EdgeInsets.fromLTRB(
        18.w,
        8.h,
        18.w,
        16.h + MediaQuery.paddingOf(context).bottom,
      ),
      backgroundColor: palette.scaffold,
      child: const SuggestionsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final controller = Get.find<SuggestionsController>();

    return Obx(() {
      final tips = controller.tips;
      final loading = controller.isLoading.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CustomHeaderBarWidget(),
          SizedBox(height: 8.h),
          CustomTextWidget(
            Enus.suggestions.tr,
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
          SizedBox(height: 4.h),
          CustomTextWidget(
            controller.basedOnLabel.value.isEmpty
                ? Enus.whatToDoNow.tr
                : controller.basedOnLabel.value,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: palette.textSecondary,
          ),
          SizedBox(height: 18.h),
          if (loading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: const Center(child: CircularProgressIndicator()),
            )
          else
            ...tips.map(
              (tip) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: SuggestionTipCard(
                  tip: tip,
                  onAction: () => controller.onTipAction(tip),
                ),
              ),
            ),
        ],
      );
    });
  }
}
