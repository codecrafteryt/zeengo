import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../../utils/values/my_images.dart';
import '../app_svg_icon.dart';
import '../custom_text_widget.dart';

class PayoutInfoBox extends StatelessWidget {
  const PayoutInfoBox({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: palette.cardMuted,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class PayoutKeyValue extends StatelessWidget {
  const PayoutKeyValue({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            label,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: MyColors.darkPurple,
          ),
          SizedBox(height: 3.h),
          CustomTextWidget(
            value,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: palette.textPrimary,
          ),
        ],
      ),
    );
  }
}

class PayoutWalletBox extends StatelessWidget {
  const PayoutWalletBox({
    super.key,
    required this.label,
    required this.address,
  });

  final String label;
  final String address;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return PayoutInfoBox(
      children: [
        CustomTextWidget(
          label,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: MyColors.darkPurple,
        ),
        SizedBox(height: 8.h),
        SelectableText(
          address,
          style: TextStyle(
            fontFamily: MyFonts.roboto,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
            height: 1.4,
          ),
        ),
        SizedBox(height: 10.h),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: address));
            Get.snackbar(Enus.copied.tr, address, snackPosition: SnackPosition.BOTTOM);
          },
          child: Row(
            children: [
              AppSvgIcon(
                asset: MyImages.payoutQr,
                size: 16.sp,
                color: MyColors.darkPurple,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: CustomTextWidget(
                  Enus.qrScanWallet.tr,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: MyColors.darkPurple,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
