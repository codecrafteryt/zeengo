import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../data/enus.dart';
import '../widgets/coming_soon_placeholder.dart';

class Payouts extends StatelessWidget {
  const Payouts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ComingSoonPlaceholder(
        title: Enus.pay.tr,
        icon: Icons.credit_card_outlined,
        message: Enus.payMessage.tr,
      ),
    );
  }
}
