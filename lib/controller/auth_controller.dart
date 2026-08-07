import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/enus.dart';
import '../data/repos/auth_repo/auth_repo.dart';
import '../views/screen/explore/home_pages.dart';

class AuthController extends GetxController {
  AuthController({
    required this.authRepo,
    required this.sharedPreferences,
  });

  final AuthRepo authRepo;
  final SharedPreferences sharedPreferences;

  static const demoBookingCode = 'ZN0000';
  static const demoPhone = '123456789';
  static const staffPortalBase = 'https://zeengo.app/portal';

  final formKey = GlobalKey<FormState>();
  final bookingController = TextEditingController();
  final phoneController = TextEditingController();
  final bookingFocus = FocusNode();
  final phoneFocus = FocusNode();

  final staffCodeController = TextEditingController();
  final staffCodeFocus = FocusNode();

  final isLoading = false.obs;
  final formError = RxnString();
  final staffExpanded = false.obs;
  final staffError = RxnString();

  String? validateBookingCode(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return Enus.bookingCodeRequired.tr;
    return null;
  }

  String? validatePhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return Enus.phoneRequired.tr;
    return null;
  }

  Future<void> viewMyTrip() async {
    if (isLoading.value) return;

    FocusManager.instance.primaryFocus?.unfocus();
    formError.value = null;

    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final code = bookingController.text.trim();
    final phone = phoneController.text.trim();

    if (code != demoBookingCode || phone != demoPhone) {
      formError.value = Enus.invalidCredentials.tr;
      return;
    }

    isLoading.value = true;
    try {
      await Future<void>.delayed(const Duration(seconds: 3));
      Get.off(() => const HomePages());
    } finally {
      // Navigation may dispose this controller; guard updates.
      if (!isClosed) isLoading.value = false;
    }
  }

  void focusPhone() => phoneFocus.requestFocus();

  void toggleStaffFastAccess() {
    staffExpanded.value = !staffExpanded.value;
    staffError.value = null;
    if (!staffExpanded.value) {
      staffCodeFocus.unfocus();
    }
  }

  Future<void> openStaffPortal() async {
    final code = staffCodeController.text.trim();
    staffError.value = null;

    if (code.isEmpty) {
      staffError.value = Enus.staffCodeRequired.tr;
      Get.snackbar(
        Enus.staffFastAccess.tr,
        Enus.staffCodeRequired.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.w),
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final uri = Uri.parse(
      '$staffPortalBase?code=${Uri.encodeQueryComponent(code)}',
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && !isClosed) {
      staffError.value = Enus.comingSoonDefaultMessage.tr;
      Get.snackbar(
        Enus.staffFastAccess.tr,
        Enus.comingSoonDefaultMessage.tr,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.w),
      );
    }
  }

  @override
  void onClose() {
    bookingController.dispose();
    phoneController.dispose();
    bookingFocus.dispose();
    phoneFocus.dispose();
    staffCodeController.dispose();
    staffCodeFocus.dispose();
    super.onClose();
  }
}
