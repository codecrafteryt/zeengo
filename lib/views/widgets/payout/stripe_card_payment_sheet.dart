import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../services/stripe_payment_service.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_fonts.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Enus.cardDetails.tr, style: _title),
        SizedBox(height: 4.h),
        Text(
          Enus.payAmount.trParams({'amount': widget.amountLabel}),
          style: _sub,
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(flex: 5, child: Text(Enus.cardNumber.tr, style: _label)),
            Expanded(flex: 2, child: Text(Enus.expiration.tr, style: _label)),
            SizedBox(width: 8.w),
            Expanded(flex: 2, child: Text(Enus.cvv.tr, style: _label)),
          ],
        ),
        SizedBox(height: 8.h),
        // height: 50 — preferred; not rigidly fixed so CardField can lay out number/exp/cvc
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 50.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: _fieldDecoration,
          child: CardField(
            enablePostalCode: false,
            onCardChanged: (d) =>
                setState(() => _cardComplete = d?.complete ?? false),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: '1234 1234 1234 1234',
              hintStyle: _hint,
              contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            ),
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 14.sp,
              color: MyColors.blackDark,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(Enus.cardFieldsHint.tr, style: _tiny),
        SizedBox(height: 16.h),
        Text(Enus.zipCode.tr, style: _label),
        SizedBox(height: 8.h),
        TextField(
          controller: _zipController,
          style: _value,
          decoration: _inputDecoration(Enus.zipCode.tr),
        ),
        SizedBox(height: 16.h),
        Text(Enus.countryRegion.tr, style: _label),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 50.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: _fieldDecoration,
          alignment: Alignment.center,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _country,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: [
                for (final c in _countries)
                  DropdownMenuItem(value: c.$1, child: Text(c.$2, style: _value)),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _country = v);
              },
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(Enus.poweredByStripe.tr, style: _powered),
        SizedBox(height: 24.h),
        Row(
          children: [
            TextButton(
              onPressed: _loading ? null : () => Navigator.pop(context, false),
              child: Text(
                Enus.cancel.tr,
                style: TextStyle(
                  fontFamily: MyFonts.plusJakartaSans,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  color: MyColors.blackDark,
                ),
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
                    : Text(Enus.done.tr, style: _btn),
              ),
            ),
          ],
        ),
      ],
    );
  }

  BoxDecoration get _fieldDecoration => BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: MyColors.borderSubtle),
      );

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: _hint,
      filled: true,
      fillColor: MyColors.white,
      // height ~50 via padding; not a hard fixed height
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: MyColors.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: MyColors.darkPurple, width: 1.4),
      ),
    );
  }

  TextStyle get _title => TextStyle(
        fontFamily: MyFonts.plusJakartaSans,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: MyColors.blackDark,
      );
  TextStyle get _sub => TextStyle(
        fontFamily: MyFonts.plusJakartaSans,
        fontSize: 13.sp,
        color: MyColors.textSecondary,
      );
  TextStyle get _label => TextStyle(
        fontFamily: MyFonts.plusJakartaSans,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: MyColors.blackDark,
      );
  TextStyle get _hint => TextStyle(
        fontFamily: MyFonts.plusJakartaSans,
        fontSize: 14.sp,
        color: MyColors.textSecondary,
      );
  TextStyle get _value => TextStyle(
        fontFamily: MyFonts.plusJakartaSans,
        fontSize: 14.sp,
        color: MyColors.blackDark,
      );
  TextStyle get _tiny => TextStyle(
        fontFamily: MyFonts.plusJakartaSans,
        fontSize: 11.sp,
        color: MyColors.textSecondary,
      );
  TextStyle get _powered => TextStyle(
        fontFamily: MyFonts.plusJakartaSans,
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: MyColors.blackDark,
      );
  TextStyle get _btn => TextStyle(
        fontFamily: MyFonts.plusJakartaSans,
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
      );
}
