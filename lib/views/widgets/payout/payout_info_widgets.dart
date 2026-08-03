import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../../../utils/values/my_images.dart';
import '../app_svg_icon.dart';

class PayoutInfoBox extends StatelessWidget {
  const PayoutInfoBox({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: MyColors.scaffoldMuted,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: MyColors.borderSubtle),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: MyColors.darkPurple,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: MyColors.blackDark,
            ),
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
    return PayoutInfoBox(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: MyFonts.plusJakartaSans,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: MyColors.darkPurple,
          ),
        ),
        SizedBox(height: 8.h),
        SelectableText(
          address,
          style: TextStyle(
            fontFamily: MyFonts.plusJakartaSans,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: MyColors.blackDark,
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
                child: Text(
                  Enus.qrScanWallet.tr,
                  style: TextStyle(
                    fontFamily: MyFonts.plusJakartaSans,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: MyColors.darkPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
