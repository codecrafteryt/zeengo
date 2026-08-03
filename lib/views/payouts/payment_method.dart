import 'package:flutter/material.dart';

import '../../data/enus.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_images.dart';

enum PaymentMethodId {
  card,
  applePay,
  alRajhi,
  usdtTrc20,
  usdtBep20,
  cash,
}

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.svgAsset,
    required this.titleKey,
    required this.subtitleKey,
    required this.accent,
    this.badgeKey,
  });

  final PaymentMethodId id;
  final String svgAsset;
  final String titleKey;
  final String subtitleKey;
  final Color accent;
  final String? badgeKey;
}

class PaymentMethodsCatalog {
  PaymentMethodsCatalog._();

  static final List<PaymentMethod> all = [
    const PaymentMethod(
      id: PaymentMethodId.card,
      svgAsset: MyImages.navPaySvg,
      titleKey: Enus.pmVisaMastercard,
      subtitleKey: Enus.pmStripeSub,
      accent: MyColors.darkPurple,
      badgeKey: Enus.badgeRecommended,
    ),
    const PaymentMethod(
      id: PaymentMethodId.applePay,
      svgAsset: MyImages.payoutApple,
      titleKey: Enus.pmApplePay,
      subtitleKey: Enus.pmAppleSub,
      accent: MyColors.blackDark,
    ),
    const PaymentMethod(
      id: PaymentMethodId.alRajhi,
      svgAsset: MyImages.payoutBank,
      titleKey: Enus.pmAlRajhi,
      subtitleKey: Enus.pmAlRajhiSub,
      accent: MyColors.green,
      badgeKey: Enus.badgePopular,
    ),
    const PaymentMethod(
      id: PaymentMethodId.usdtTrc20,
      svgAsset: MyImages.payoutUsdt,
      titleKey: Enus.pmUsdtTrc20,
      subtitleKey: Enus.pmUsdtTrc20Sub,
      accent: Color(0xFFD97706),
    ),
    const PaymentMethod(
      id: PaymentMethodId.usdtBep20,
      svgAsset: MyImages.payoutUsdt,
      titleKey: Enus.pmUsdtBep20,
      subtitleKey: Enus.pmUsdtBep20Sub,
      accent: Color(0xFFB45309),
    ),
    const PaymentMethod(
      id: PaymentMethodId.cash,
      svgAsset: MyImages.payoutCash,
      titleKey: Enus.pmCashSplizer,
      subtitleKey: Enus.pmCashSub,
      accent: Color(0xFF2563EB),
    ),
  ];
}
