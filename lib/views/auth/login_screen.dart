/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Airbnb-style login
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
  static const _demoEmail = 'click@gmail';
  static const _demoPassword = '123456789';

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _formError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return Enus.emailRequired.tr;
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.?[^@\s]*$').hasMatch(v);
    if (!ok) return Enus.emailInvalid.tr;
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return Enus.passwordRequired.tr;
    if (v.length < 6) return Enus.passwordMinLength.tr;
    return null;
  }

  Future<void> _onContinue() async {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();
    setState(() => _formError = null);

    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email != _demoEmail || password != _demoPassword) {
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
    required String? Function(String?) validator,
    required ValueChanged<String>? onFieldSubmitted,
    bool obscure = false,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = palette.border;

    return CustomTextField(
      controller: controller,
      focusNode: focusNode,
      labelText: label,
      hintText: '',
      height: 50,
      borderRadius: 12.r,
      padding: EdgeInsets.zero,
      keyboardType: keyboardType,
      isObscureText: obscure,
      filled: true,
      fillColor: isDark ? palette.cardMuted : palette.card,
      focusedFillColor: isDark ? palette.cardMuted : palette.card,
      // Theme container border for idle + focus (no purple).
      borderColor: border,
      focusedBorderColor: border,
      enabledBorderWidth: 1,
      focusedBorderWidth: 1,
      errorBorderColor: const Color.fromRGBO(240, 66, 72, 1),
      errorBorderWidth: 1.2,
      focusedErrorBorderWidth: 1.2,
      labelColor: palette.textSecondary,
      // Always float "Email" / "Password" (default, not only on focus).
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelStyle: TextStyle(
        color: palette.textSecondary,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      ),
      textColor: palette.textPrimary,
      cursorColor: palette.textPrimary,
      fontSize: 15.sp,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      suffixIcon: suffix,
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
                              controller: _emailController,
                              focusNode: _emailFocus,
                              label: Enus.email.tr,
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                              onFieldSubmitted: (_) =>
                                  _passwordFocus.requestFocus(),
                            ),
                            20.sbh,
                            _buildOutlinedField(
                              palette: palette,
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              label: Enus.password.tr,
                              obscure: _obscurePassword,
                              keyboardType: TextInputType.visiblePassword,
                              validator: _validatePassword,
                              onFieldSubmitted: (_) => _onContinue(),
                              suffix: IconButton(
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: palette.textSecondary,
                                  size: 22.sp,
                                ),
                              ),
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
                            30.sbh,
                            CustomButton(
                              text: Enus.continueText.tr,
                              onPressed: _isLoading ? null : _onContinue,
                              isLoading: _isLoading,
                              height: 50,
                              width: double.infinity,
                              backgroundColor: MyColors.darkPurple,
                              textColor: MyColors.white,
                              borderColor: MyColors.darkPurple,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
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
