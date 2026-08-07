import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../data/enus.dart';
import '../../utils/extensions/extentions.dart';
import '../../utils/values/app_palette.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_images.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_widget.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: palette.scaffold,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h + bottom),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 20.h,
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Image.asset(
                              MyImages.appIcon,
                              width: 110.w,
                              height: 110.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                          28.sbh,
                          CustomTextWidget(
                            Enus.welcomeBack.tr,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                            color: palette.textPrimary,
                            letterSpacing: -0.6,
                            textAlign: TextAlign.center,
                          ),
                          10.sbh,
                          CustomTextWidget(
                            Enus.loginSubtitle.tr,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.45,
                            color: palette.textSecondary,
                            textAlign: TextAlign.center,
                          ),
                          40.sbh,
                          CustomTextField(
                            themed: true,
                            controller: controller.bookingController,
                            focusNode: controller.bookingFocus,
                            labelText: Enus.bookingCode.tr,
                            hintText: Enus.bookingCodeHint.tr,
                            keyboardType: TextInputType.text,
                            validator: controller.validateBookingCode,
                            onFieldSubmitted: (_) => controller.focusPhone(),
                          ),
                          20.sbh,
                          CustomTextField(
                            themed: true,
                            controller: controller.phoneController,
                            focusNode: controller.phoneFocus,
                            labelText: Enus.phoneNumber.tr,
                            hintText: Enus.phoneNumberHint.tr,
                            keyboardType: TextInputType.phone,
                            validator: controller.validatePhone,
                            onFieldSubmitted: (_) => controller.viewMyTrip(),
                          ),
                          Obx(() {
                            final error = controller.formError.value;

                            if (error == null || error.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return Column(
                              children: [
                                14.sbh,
                                CustomTextWidget(
                                  error,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.red,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          }),
                          25.sbh,
                          Obx(
                            () => CustomButton(
                              text: Enus.viewMyTrip.tr,
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.viewMyTrip,
                              isLoading: controller.isLoading.value,
                              height: 50,
                              width: double.infinity,
                              backgroundColor: MyColors.darkPurple,
                              textColor: MyColors.white,
                              borderColor: MyColors.darkPurple,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              suffixIcon: Icons.arrow_forward_rounded,
                              iconColor: MyColors.white,
                              iconSize: 20.sp,
                            ),
                          ),
                          36.sbh,
                          CustomTextWidget(
                            Enus.bookingCodeHelp.tr,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: palette.textSecondary,
                            textAlign: TextAlign.center,
                          ),
                          4.sbh,
                          CustomTextWidget(
                            Enus.bookingCodeHelpAr.tr,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: palette.textSecondary,
                            textAlign: TextAlign.center,
                          ),
                          28.sbh,
                          Center(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: controller.toggleStaffFastAccess,
                                borderRadius: BorderRadius.circular(8.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 8.h,
                                  ),
                                  child: Obx(() {
                                    final expanded =
                                        controller.staffExpanded.value;

                                    final arrowAsset = expanded
                                        ? MyImages.arrowUpFlatSvg
                                        : MyImages.arrowDownFlatSvg;

                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.verified_user_outlined,
                                          size: 18.sp,
                                          color: palette.textSecondary,
                                        ),
                                        SizedBox(width: 8.w),
                                        CustomTextWidget(
                                          Enus.staffFastAccess.tr,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: palette.textSecondary,
                                        ),
                                        SizedBox(width: 6.w),
                                        SvgPicture.asset(
                                          arrowAsset,
                                          width: 16.sp,
                                          height: 16.sp,
                                          colorFilter: ColorFilter.mode(
                                            palette.textSecondary,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                          Obx(() {
                            final expanded = controller.staffExpanded.value;

                            return AnimatedSize(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeInOut,
                              alignment: Alignment.topCenter,
                              child: expanded
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        14.sbh,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: 50.h,
                                                child: CustomTextField(
                                                  themed: true,
                                                  controller: controller.staffCodeController,
                                                  focusNode: controller.staffCodeFocus,
                                                  hintText: Enus.bookingCodeHint.tr,
                                                  keyboardType: TextInputType.text,
                                                  onFieldSubmitted: (_) =>
                                                      controller.openStaffPortal(),
                                                ),
                                              ),
                                            ),
                                            12.sbw,
                                            GestureDetector(
                                              onTap: (){
                                                debugPrint("Open");
                                              },
                                              child: Container(
                                                height: 45,
                                                width: 70.w,
                                                decoration: BoxDecoration(
                                                  color: MyColors.darkPurple,
                                                  borderRadius: BorderRadius.circular(8.r),
                                                ),
                                                child: Center(
                                                      child: CustomTextWidget(
                                                        Enus.staffOpen.tr,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w400,
                                                        height: 1.4,
                                                        color: MyColors.white,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ) : const SizedBox.shrink(),
                            );
                          }),
                          12.sbh,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
