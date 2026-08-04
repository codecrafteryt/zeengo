import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/currency_converter_controller.dart';
import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../custom_text_widget.dart';

class CurrencyAmountSection extends StatelessWidget {
  const CurrencyAmountSection({
    super.key,
    required this.controller,
    required this.accent,
  });

  final CurrencyConverterController controller;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final fieldColor = palette.cardMuted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          Enus.amount.tr,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: palette.textSecondary,
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.fromLTRB(16.w, 18.h, 12.w, 18.h),
          decoration: BoxDecoration(
            color: fieldColor,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: palette.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: controller.amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                      cursorColor: MyColors.darkPurple,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                        height: 1.1,
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        filled: true,
                        fillColor: fieldColor,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Obx(() {
                final base = controller.baseCurrency.value;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: CurrencyConverterController.currencies.map((code) {
                    final selected = code == base;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      child: _CurrencyPill(
                        code: code,
                        selected: selected,
                        accent: accent,
                        onTap: () => controller.setBaseCurrency(code),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _CurrencyPill extends StatelessWidget {
  const _CurrencyPill({
    required this.code,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String code;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: selected ? accent : palette.card,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: selected ? accent : palette.border,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: CustomTextWidget(
            code,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : palette.textSecondary,
          ),
        ),
      ),
    );
  }
}
