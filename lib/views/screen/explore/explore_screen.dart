import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/enus.dart';
import '../../../utils/values/app_palette.dart';
import '../../../utils/values/my_color.dart';
import '../../../utils/values/my_images.dart';
import '../../widgets/ai/ai_assistant_sheet.dart';
import '../../widgets/currency/currency_calculator_sheet.dart';
import '../../widgets/explore/explore_actions_grid.dart';
import '../../widgets/explore/explore_header.dart';
import '../../widgets/explore/explore_payment_card.dart';
import '../../widgets/explore/explore_restaurants_card.dart';
import '../../widgets/explore/explore_schedule_card.dart';
import '../../widgets/explore/explore_stats_row.dart';
import '../../widgets/explore/explore_weather_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppPalette.of(context).scaffold,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(
            child: ExploreHeader(
              userName: 'محمد',
              packageLabel: 'Love Package - 20 Apr 2026',
              bookingId: 'ZN0001',
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h + bottom),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ExploreStatsRow(
                  items: [
                    ExploreStatItem(
                      svgAsset: MyImages.exploreCalendar,
                      value: '0',
                      label: Enus.daysLeft.tr,
                      iconColor: MyColors.darkPurple,
                      bgColor: MyColors.darkPurple.withValues(alpha: 0.12),
                    ),
                    ExploreStatItem(
                      svgAsset: MyImages.exploreGuests,
                      value: '2',
                      label: Enus.guests.tr,
                      iconColor: MyColors.purple,
                      bgColor: MyColors.purple.withValues(alpha: 0.12),
                    ),
                    ExploreStatItem(
                      svgAsset: MyImages.exploreMoney,
                      value: '\$100',
                      label: Enus.due.tr,
                      iconColor: const Color(0xFFD97706),
                      bgColor: const Color(0x1AD97706),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                ExploreScheduleCard(dateLabel: Enus.mon3Aug.tr),
                SizedBox(height: 12.h),
                ExploreActionsGrid(
                  items: [
                    ExploreActionItem(
                      svgAsset: MyImages.exploreAi,
                      title: Enus.aiAssistant.tr,
                      subtitle: Enus.askMeAnything.tr,
                      accent: MyColors.purple,
                      onTap: () => AiAssistantSheet.show(context),
                    ),
                    ExploreActionItem(
                      svgAsset: MyImages.exploreCurrency,
                      title: Enus.currency.tr,
                      subtitle: 'USD · SAR · RUB',
                      accent: MyColors.green,
                      onTap: () => CurrencyCalculatorSheet.show(context),
                    ),
                    ExploreActionItem(
                      svgAsset: MyImages.exploreSuggestion,
                      title: Enus.suggestions.tr,
                      subtitle: Enus.whatToDoNow.tr,
                      accent: const Color(0xFFD97706),
                    ),
                    ExploreActionItem(
                      svgAsset: MyImages.navPaySvg,
                      title: Enus.payBalance.tr,
                      subtitle: '\$100',
                      accent: MyColors.darkPurple,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                ExplorePaymentCard(
                  progress: 0.82,
                  paidLabel: Enus.paidAmount.trParams({'amount': '\$450'}),
                  totalLabel: Enus.totalAmount.trParams({'amount': '\$550'}),
                ),
                SizedBox(height: 12.h),
                const ExploreRestaurantsCard(
                  items: [
                    ExploreRestaurant(
                      name: 'Al-Medina',
                      cuisine: 'Arabic menu',
                      distance: '1.4km',
                      rating: 5,
                    ),
                    ExploreRestaurant(
                      name: 'Bismillah Kitchen',
                      cuisine: 'Pakistani · Grill',
                      distance: '2.1km',
                      rating: 4,
                    ),
                    ExploreRestaurant(
                      name: 'Halal House',
                      cuisine: 'Turkish · Cafe',
                      distance: '3.0km',
                      rating: 4,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                ExploreWeatherCard(
                  city: 'Moscow',
                  dateLabel: Enus.monday3Aug.tr,
                  temperature: '— °C',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
