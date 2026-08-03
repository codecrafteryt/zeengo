
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../../data/enus.dart';
import '../../widgets/coming_soon_placeholder.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ComingSoonPlaceholder(
        title: Enus.explore.tr,
        icon: Icons.search_outlined,
        message: Enus.exploreMessage.tr,
      ),
    );
  }
}
