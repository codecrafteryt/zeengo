import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final formKey = GlobalKey<FormState>();
  final bookingController = TextEditingController();
  final phoneController = TextEditingController();
  final bookingFocus = FocusNode();
  final phoneFocus = FocusNode();

  final isLoading = false.obs;
  final formError = RxnString();

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

  @override
  void onClose() {
    bookingController.dispose();
    phoneController.dispose();
    bookingFocus.dispose();
    phoneFocus.dispose();
    super.onClose();
  }
}
