import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/enus.dart';
import '../../utils/values/app_palette.dart';
import '../../utils/values/my_color.dart';
import '../widgets/custom_bottom_sheet_widget.dart';
import '../widgets/custom_header_bar_widget.dart';
import '../widgets/custom_text_widget.dart';
import '../widgets/payout/payment_method_tile.dart';
import '../widgets/payout/payout_balance_card.dart';
import '../widgets/payout/stripe_card_payment_sheet.dart';
import 'payment_method.dart';
import 'payout_method_detail.dart';

class Payouts extends StatefulWidget {
  const Payouts({super.key, this.embedded = false});

  /// When true, renders list content only (for bottom sheet).
  final bool embedded;

  static Future<void> showAsSheet(BuildContext context) {
    final palette = AppPalette.of(context);
    return CustomBottomSheetWidget.show(
      context: context,
      heightFactor: 0.98,
      radius: 16.r,
      showHandle: false,
      scrollable: false,
      padding: EdgeInsets.fromLTRB(
        16.w,
        8.h,
        16.w,
        12.h + MediaQuery.paddingOf(context).bottom,
      ),
      backgroundColor: palette.scaffold,
      child: const Payouts(embedded: true),
    );
  }

  @override
  State<Payouts> createState() => _PayoutsState();
}

class _PayoutsState extends State<Payouts> {
  static const _whatsapp = '+79160000000';
  static const _dueAmount = '\$100';
  PaymentMethodId? _selected;

  Future<void> _openWhatsapp([String? message]) async {
    final text = Uri.encodeComponent(message ?? Enus.whatsappPaymentMsg.tr);
    final uri = Uri.parse('https://wa.me/$_whatsapp?text=$text');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _onPayAction() async {
    if (_selected == PaymentMethodId.card) {
      await CustomBottomSheetWidget.show<bool>(
        context: context,
        heightFactor: 0.98,
        radius: 16,
        showHandle: false,
        child: const StripeCardPaymentSheet(amountLabel: _dueAmount),
      );
      return;
    }
    await _openWhatsapp();
  }

  void _toggle(PaymentMethodId id) {
    setState(() => _selected = _selected == id ? null : id);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    final list = ListView(
      padding: widget.embedded
          ? EdgeInsets.only(bottom: 8.h)
          : EdgeInsets.fromLTRB(16.w, top + 12.h, 16.w, 20.h + bottom),
      children: [
        if (widget.embedded) ...[
          const CustomHeaderBarWidget(),
          SizedBox(height: 8.h),
          CustomTextWidget(
            Enus.pay.tr,
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
          SizedBox(height: 14.h),
        ],
        const PayoutBalanceCard(
          dueAmount: _dueAmount,
          paidAmount: '\$450',
          totalAmount: '\$550',
        ),
        if (_selected != null) ...[
          SizedBox(height: 12.h),
          PayoutMethodDetail(
            methodId: _selected!,
            onClose: () => setState(() => _selected = null),
            onAction: _onPayAction,
          ),
        ],
        SizedBox(height: 8.h),
        CustomTextWidget(
          Enus.choosePaymentMethod.tr,
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
          color: MyColors.darkPurple,
        ),
        SizedBox(height: 12.h),
        for (final m in PaymentMethodsCatalog.all)
          PaymentMethodTile(
            svgAsset: m.svgAsset,
            title: m.titleKey.tr,
            subtitle: m.subtitleKey.tr,
            accent: m.accent,
            badge: m.badgeKey?.tr,
            expanded: _selected == m.id,
            onTap: () => _toggle(m.id),
          ),
        SizedBox(height: 8.h),
        CustomTextWidget(
          Enus.paymentsSecureFooter.tr,
          textAlign: TextAlign.center,
          fontSize: 11.sp,
          height: 1.4,
          color: palette.textSecondary,
        ),
      ],
    );

    if (widget.embedded) {
      return list;
    }

    return Scaffold(
      backgroundColor: palette.scaffold,
      body: list,
    );
  }
}
