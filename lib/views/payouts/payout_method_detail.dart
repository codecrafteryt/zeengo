import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/enus.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_fonts.dart';
import '../../utils/values/my_images.dart';
import '../widgets/payout/payout_detail_shell.dart';
import '../widgets/payout/payout_info_widgets.dart';
import 'payment_method.dart';

class PayoutMethodDetail extends StatelessWidget {
  const PayoutMethodDetail({
    super.key,
    required this.methodId,
    required this.onClose,
    required this.onAction,
  });

  final PaymentMethodId methodId;
  final VoidCallback onClose;
  final VoidCallback onAction;

  TextStyle get _body => TextStyle(
        fontFamily: MyFonts.plusJakartaSans,
        fontSize: 13.sp,
        height: 1.4,
        color: MyColors.textSecondary,
      );

  TextStyle get _label => TextStyle(
        fontFamily: MyFonts.plusJakartaSans,
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: MyColors.darkPurple,
      );

  @override
  Widget build(BuildContext context) {
    return switch (methodId) {
      PaymentMethodId.card => PayoutDetailShell(
          title: Enus.payByCardStripe.tr,
          onClose: onClose,
          onAction: onAction,
          buttonLabel: Enus.payNowStripe.tr,
          leadingSvg: MyImages.navPaySvg,
          child: Text(Enus.stripeDescription.tr, style: _body),
        ),
      PaymentMethodId.applePay => PayoutDetailShell(
          title: Enus.pmApplePay.tr,
          onClose: onClose,
          onAction: onAction,
          buttonLabel: Enus.requestApplePayWhatsapp.tr,
          buttonColor: const Color(0xFF2563EB),
          leadingSvg: MyImages.chatPhone,
          child: Text(Enus.applePayDescription.tr, style: _body),
        ),
      PaymentMethodId.alRajhi => PayoutDetailShell(
          title: Enus.alRajhiTransfer.tr,
          onClose: onClose,
          onAction: onAction,
          buttonLabel: Enus.sendReceiptWhatsapp.tr,
          buttonColor: MyColors.green,
          leadingSvg: MyImages.chatPhone,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PayoutInfoBox(
                children: [
                  PayoutKeyValue(label: Enus.beneficiary.tr, value: 'ZEENGO Tourism LLC'),
                  PayoutKeyValue(label: Enus.iban.tr, value: 'SA03 8000 0000 6080 1016 7519'),
                  PayoutKeyValue(label: Enus.bank.tr, value: 'Al-Rajhi Bank'),
                  PayoutKeyValue(label: Enus.reference.tr, value: Enus.yourBookingCode.tr),
                  PayoutKeyValue(label: Enus.currencyLabel.tr, value: 'SAR'),
                ],
              ),
              SizedBox(height: 10.h),
              Text(Enus.afterTransferNote.tr, style: _body),
            ],
          ),
        ),
      PaymentMethodId.usdtTrc20 => _crypto(
          title: Enus.usdtTrc20Title.tr,
          label: Enus.walletTrc20.tr,
          address: 'TQn9Y2khEsLJW1ChVvFMSMeRDow5KcbLSE',
          warning: Enus.usdtTrc20Warning.tr,
        ),
      PaymentMethodId.usdtBep20 => _crypto(
          title: Enus.usdtBep20Title.tr,
          label: Enus.walletBep20.tr,
          address: '0x742d35Cc6634C0532925a3b844Bc9e759e0B48',
          warning: Enus.usdtBep20Warning.tr,
        ),
      PaymentMethodId.cash => PayoutDetailShell(
          title: Enus.cashToSplizerAgent.tr,
          onClose: onClose,
          onAction: onAction,
          buttonLabel: Enus.contactSplizerAgent.tr,
          buttonColor: const Color(0xFF2563EB),
          leadingSvg: MyImages.chatPhone,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Enus.cashAgentDescription.tr, style: _body),
              SizedBox(height: 12.h),
              PayoutInfoBox(
                children: [
                  Text(Enus.acceptedCurrencies.tr, style: _label),
                  SizedBox(height: 6.h),
                  Text(
                    'USD · SAR · EUR · RUB',
                    style: TextStyle(
                      fontFamily: MyFonts.plusJakartaSans,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: MyColors.blackDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    };
  }

  Widget _crypto({
    required String title,
    required String label,
    required String address,
    required String warning,
  }) {
    return PayoutDetailShell(
      title: title,
      onClose: onClose,
      onAction: onAction,
      buttonLabel: Enus.confirmPaymentWhatsapp.tr,
      buttonColor: const Color(0xFFD97706),
      leadingSvg: MyImages.chatPhone,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PayoutWalletBox(label: label, address: address),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded, size: 18.sp, color: const Color(0xFFD97706)),
              SizedBox(width: 6.w),
              Expanded(child: Text(warning, style: _body)),
            ],
          ),
        ],
      ),
    );
  }
}
