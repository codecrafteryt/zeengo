/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Booking login UI (stateless; logic in AuthController)
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          backgroundColor: palette.scaffold,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h + bottom),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 20.h,
                    ),
                    child: IntrinsicHeight(
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
                              final err = controller.formError.value;
                              if (err == null) return const SizedBox.shrink();
                              return Column(
                                children: [
                                  14.sbh,
                                  CustomTextWidget(
                                    err,
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
                              fontSize: 11,
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
                          ],
                        ),
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
