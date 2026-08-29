import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:zeengo/views/payouts/payouts.dart';

import '../../../controller/home_controller.dart';
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
import '../../widgets/suggestions/suggestions_sheet.dart';

class ExploreScreen extends GetView<HomeController> {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final palette = AppPalette.of(context);

    return Scaffold(
      backgroundColor: palette.scaffold,
      body: Obx(() {
        final loading = controller.isLoading.value && controller.home.value == null;

        return RefreshIndicator(
          color: MyColors.darkPurple,
          onRefresh: () => controller.fetchHome(showLoader: false),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              Obx(
                () => SliverToBoxAdapter(
                  child: ExploreHeader(
                    userName: controller.clientName.value.isEmpty
                        ? Enus.guest.tr
                        : controller.clientName.value,
                    packageLabel: controller.packageLabel.value.isEmpty
                        ? '—'
                        : controller.packageLabel.value,
                    bookingId: controller.znCode.value.isEmpty
                        ? '—'
                        : controller.znCode.value,
                  ),
                ),
              ),
              if (loading)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: MyColors.darkPurple,
                    ),
                  ),
                )
              else
                Obx(() {
                  final error = controller.errorMessage.value;
                  return SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h + bottom),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (error != null && error.isNotEmpty) ...[
                          Transform.translate(
                            offset: Offset(0, -8.h),
                            child: Material(
                              color: const Color(0x14D50000),
                              borderRadius: BorderRadius.circular(14.r),
                              child: InkWell(
                                onTap: controller.fetchHome,
                                borderRadius: BorderRadius.circular(14.r),
                                child: Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline_rounded,
                                        color: MyColors.red,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          error,
                                          style: TextStyle(
                                            color: MyColors.red,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.refresh_rounded,
                                        color: MyColors.red,
                                        size: 20.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                        ],
                        Transform.translate(
                          offset: Offset(0, -18.h),
                          child: ExploreStatsRow(
                            items: [
                              ExploreStatItem(
                                svgAsset: MyImages.exploreCalendar,
                                value: controller.daysLeftLabel.value,
                                label: Enus.daysLeft.tr,
                                iconColor: MyColors.darkPurple,
                                bgColor:
                                    MyColors.darkPurple.withValues(alpha: 0.12),
                              ),
                              ExploreStatItem(
                                svgAsset: MyImages.exploreGuests,
                                value: controller.guestsLabel.value,
                                label: Enus.guests.tr,
                                iconColor: MyColors.purple,
                                bgColor:
                                    MyColors.purple.withValues(alpha: 0.12),
                              ),
                              ExploreStatItem(
                                svgAsset: MyImages.exploreMoney,
                                value: controller.dueLabel.value,
                                label: Enus.due.tr,
                                iconColor: const Color(0xFFD97706),
                                bgColor: const Color(0x1AD97706),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        ExploreScheduleCard(
                          dateLabel: controller.scheduleDateLabel.value.isEmpty
                              ? '—'
                              : controller.scheduleDateLabel.value,
                          items: controller.todayProgram.toList(),
                        ),
                        SizedBox(height: 16.h),
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
                              onTap: () =>
                                  CurrencyCalculatorSheet.show(context),
                            ),
                            ExploreActionItem(
                              svgAsset: MyImages.exploreSuggestion,
                              title: Enus.suggestions.tr,
                              subtitle: Enus.whatToDoNow.tr,
                              accent: const Color(0xFFD97706),
                              onTap: () => SuggestionsSheet.show(context),
                            ),
                            ExploreActionItem(
                              svgAsset: MyImages.navPaySvg,
                              title: Enus.payBalance.tr,
                              subtitle: controller.dueLabel.value,
                              accent: MyColors.darkPurple,
                              onTap: () => Payouts.showAsSheet(context),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        ExplorePaymentCard(
                          progress: controller.paymentProgress.value,
                          paidLabel: Enus.paidAmount.trParams({
                            'amount': controller.paidLabelAmount.value,
                          }),
                          totalLabel: Enus.totalAmount.trParams({
                            'amount': controller.totalLabelAmount.value,
                          }),
                        ),
                        SizedBox(height: 18.h),
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
                      ]),
                    ),
                  );
                }),
            ],
          ),
        );
      }),
    );
  }
}
