import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/currency_converter_controller.dart';
import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../custom_bottom_sheet_widget.dart';
import '../custom_header_bar_widget.dart';
import '../custom_text_widget.dart';
import 'currency_amount_section.dart';
import 'currency_result_row.dart';
import 'currency_tips_card.dart';

/// Airbnb-style currency calculator bottom sheet.
class CurrencyCalculatorSheet extends StatelessWidget {
  const CurrencyCalculatorSheet({super.key});

  static const _accent = MyColors.darkPurple;

  static Future<void> show(BuildContext context) {
    Get.find<CurrencyConverterController>().reset();

    final palette = AppPalette.of(context);
    return CustomBottomSheetWidget.show(
      context: context,
      heightFactor: 0.98,
      belowStatusBar: true,
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
      child: const CurrencyCalculatorSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final controller = Get.find<CurrencyConverterController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CustomHeaderBarWidget(),
        SizedBox(height: 8.h),
        CustomTextWidget(
          Enus.currencyCalculator.tr,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
        SizedBox(height: 4.h),
        CustomTextWidget(
          'USD · SAR · RUB',
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: palette.textSecondary,
        ),
        SizedBox(height: 18.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: palette.card,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.35
                      : 0.06,
                ),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Obx(() {
            controller.amountText.value;
            controller.baseCurrency.value;
            final quotes = controller.quotes;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CurrencyAmountSection(
                  controller: controller,
                  accent: _accent,
                ),
                SizedBox(height: 14.h),
                ...quotes.map(
                  (q) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: CurrencyResultRow(
                      code: q.code,
                      value: controller.formatAmount(q.amount),
                      accent: _accent,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Center(
                  child: CustomTextWidget(
                    Enus.approxRatesFooter.tr,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            );
          }),
        ),
        SizedBox(height: 14.h),
        const CurrencyTipsCard(accent: _accent),
      ],
    );
  }
}
