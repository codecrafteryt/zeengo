import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../services/stripe_payment_service.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';
import '../custom_text_widget.dart';

/// Stripe card form for [CustomBottomSheetWidget] (Airbnb-style).
class StripeCardPaymentSheet extends StatefulWidget {
  const StripeCardPaymentSheet({
    super.key,
    this.amountLabel = '\$100',
  });

  final String amountLabel;

  @override
  State<StripeCardPaymentSheet> createState() => _StripeCardPaymentSheetState();
}

class _StripeCardPaymentSheetState extends State<StripeCardPaymentSheet> {
  final _zipController = TextEditingController();
  String _country = 'US';
  bool _loading = false;
  bool _cardComplete = false;

  static const _countries = <(String, String)>[
    ('US', 'United States'),
    ('SA', 'Saudi Arabia'),
    ('RU', 'Russia'),
    ('AE', 'United Arab Emirates'),
    ('PK', 'Pakistan'),
  ];

  @override
  void dispose() {
    _zipController.dispose();
    super.dispose();
  }

  Future<void> _onDone() async {
    if (!_cardComplete) {
      Get.snackbar(Enus.paymentFailed.tr, Enus.enterValidCard.tr);
      return;
    }
    setState(() => _loading = true);
    try {
      final result = await StripePaymentService.instance.payWithCard(
        amountLabel: widget.amountLabel,
        billingCountry: _country,
        billingPostalCode: _zipController.text.trim(),
      );
      if (!mounted) return;
      if (result.success) {
        Navigator.of(context).pop(true);
        Get.snackbar(Enus.paymentSuccess.tr, result.message);
      } else {
        Get.snackbar(Enus.paymentFailed.tr, result.message);
      }
    } catch (e) {
      Get.snackbar(Enus.paymentFailed.tr, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          Enus.cardDetails.tr,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
        SizedBox(height: 4.h),
        CustomTextWidget(
          Enus.payAmount.trParams({'amount': widget.amountLabel}),
          fontSize: 13.sp,
          color: palette.textSecondary,
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: CustomTextWidget(
                Enus.cardNumber.tr,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: palette.textPrimary,
              ),
            ),
            Expanded(
              flex: 2,
              child: CustomTextWidget(
                Enus.expiration.tr,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: palette.textPrimary,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              flex: 2,
              child: CustomTextWidget(
                Enus.cvv.tr,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 50.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: _fieldDecoration(palette),
          child: CardField(
            enablePostalCode: false,
            onCardChanged: (d) =>
                setState(() => _cardComplete = d?.complete ?? false),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: '1234 1234 1234 1234',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: palette.textSecondary,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            ),
            style: TextStyle(
              fontFamily: MyFonts.roboto,
              fontSize: 14.sp,
              color: palette.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        CustomTextWidget(
          Enus.cardFieldsHint.tr,
          fontSize: 11.sp,
          color: palette.textSecondary,
        ),
        SizedBox(height: 16.h),
        CustomTextWidget(
          Enus.zipCode.tr,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: palette.textPrimary,
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _zipController,
          style: TextStyle(
            fontSize: 14.sp,
            color: palette.textPrimary,
          ),
          decoration: _inputDecoration(palette, Enus.zipCode.tr),
        ),
        SizedBox(height: 16.h),
        CustomTextWidget(
          Enus.countryRegion.tr,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: palette.textPrimary,
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 50.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: _fieldDecoration(palette),
          alignment: Alignment.center,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _country,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: palette.icon),
              items: [
                for (final c in _countries)
                  DropdownMenuItem(
                    value: c.$1,
                    child: CustomTextWidget(
                      c.$2,
                      fontSize: 14.sp,
                      color: palette.textPrimary,
                    ),
                  ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _country = v);
              },
            ),
          ),
        ),
        SizedBox(height: 20.h),
        CustomTextWidget(
          Enus.poweredByStripe.tr,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            TextButton(
              onPressed: _loading ? null : () => Navigator.pop(context, false),
              child: CustomTextWidget(
                Enus.cancel.tr,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                color: palette.textPrimary,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _loading ? null : _onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.darkPurple,
                  foregroundColor: MyColors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  shape: const StadiumBorder(),
                ),
                child: _loading
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: MyColors.white,
                        ),
                      )
                    : CustomTextWidget(
                        Enus.done.tr,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: MyColors.white,
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  BoxDecoration _fieldDecoration(AppPalette palette) => BoxDecoration(
        color: palette.inputFill,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.border),
      );

  InputDecoration _inputDecoration(AppPalette palette, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: palette.textSecondary,
      ),
      filled: true,
      fillColor: palette.inputFill,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: palette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: MyColors.darkPurple, width: 1.4),
      ),
    );
  }
}
