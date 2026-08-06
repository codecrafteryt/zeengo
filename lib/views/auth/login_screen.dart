/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Airbnb-style login / booking access
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/enus.dart';
import '../../utils/extensions/extentions.dart';
import '../../utils/values/app_palette.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_images.dart';
import '../screen/explore/home_pages.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_widget.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Demo credentials (same values for now).
  static const _demoBookingCode = 'click@gmail';
  static const _demoPhone = '123456789';

  final _formKey = GlobalKey<FormState>();
  final _bookingController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bookingFocus = FocusNode();
  final _phoneFocus = FocusNode();

  bool _isLoading = false;
  String? _formError;

  @override
  void dispose() {
    _bookingController.dispose();
    _phoneController.dispose();
    _bookingFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  String? _validateBookingCode(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return Enus.bookingCodeRequired.tr;
    return null;
  }

  String? _validatePhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return Enus.phoneRequired.tr;
    return null;
  }

  Future<void> _onViewTrip() async {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();
    setState(() => _formError = null);

    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final code = _bookingController.text.trim();
    final phone = _phoneController.text.trim();

    if (code != _demoBookingCode || phone != _demoPhone) {
      setState(() => _formError = Enus.invalidCredentials.tr);
      return;
    }

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Get.off(() => const HomePages());
  }

  Widget _buildOutlinedField({
    required AppPalette palette,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    required ValueChanged<String>? onFieldSubmitted,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = palette.border;

    return CustomTextField(
      controller: controller,
      focusNode: focusNode,
      labelText: label,
      hintText: hint,
      height: 50,
      borderRadius: 12.r,
      padding: EdgeInsets.zero,
      keyboardType: keyboardType,
      filled: true,
      fillColor: isDark ? palette.cardMuted : palette.card,
      focusedFillColor: isDark ? palette.cardMuted : palette.card,
      borderColor: border,
      focusedBorderColor: border,
      enabledBorderWidth: 1,
      focusedBorderWidth: 1,
      errorBorderColor: const Color.fromRGBO(240, 66, 72, 1),
      errorBorderWidth: 1.2,
      focusedErrorBorderWidth: 1.2,
      labelColor: palette.textSecondary,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelStyle: TextStyle(
        color: palette.textSecondary,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      ),
      hintColor: palette.textSecondary,
      textColor: palette.textPrimary,
      cursorColor: palette.textPrimary,
      fontSize: 15.sp,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

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
                        key: _formKey,
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
                            _buildOutlinedField(
                              palette: palette,
                              controller: _bookingController,
                              focusNode: _bookingFocus,
                              label: Enus.bookingCode.tr,
                              hint: Enus.bookingCodeHint.tr,
                              keyboardType: TextInputType.text,
                              validator: _validateBookingCode,
                              onFieldSubmitted: (_) =>
                                  _phoneFocus.requestFocus(),
                            ),
                            20.sbh,
                            _buildOutlinedField(
                              palette: palette,
                              controller: _phoneController,
                              focusNode: _phoneFocus,
                              label: Enus.phoneNumber.tr,
                              hint: Enus.phoneNumberHint.tr,
                              keyboardType: TextInputType.phone,
                              validator: _validatePhone,
                              onFieldSubmitted: (_) => _onViewTrip(),
                            ),
                            if (_formError != null) ...[
                              14.sbh,
                              CustomTextWidget(
                                _formError!,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: MyColors.red,
                                textAlign: TextAlign.center,
                              ),
                            ],
                            25.sbh,
                            CustomButton(
                              text: Enus.viewMyTrip.tr,
                              onPressed: _isLoading ? null : _onViewTrip,
                              isLoading: _isLoading,
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
                            16.sbh,
                            CustomTextWidget(
                              Enus.bookingCodeHelp.tr,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              color: palette.textSecondary,
                              textAlign: TextAlign.center,
                            ),
                            4.sbh,
                            CustomTextWidget(
                              Enus.bookingCodeHelpAr.tr,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              color: palette.textSecondary,
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            28.sbh,
                            Center(
                              child: CustomTextWidget(
                                Enus.appName.tr,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: palette.textSecondary,
                              ),
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
