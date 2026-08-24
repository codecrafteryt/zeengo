import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/constants.dart';
import '../data/enus.dart';
import '../data/models/api_response_model.dart';
import '../data/models/auth_model/login_model.dart';
import '../data/repos/auth_repo/auth_repo.dart';
import '../views/screen/explore/home_pages.dart';

class AuthController extends GetxController {
  AuthController({
    required this.authRepo,
    required this.sharedPreferences,
  });

  final AuthRepo authRepo;
  final SharedPreferences sharedPreferences;

  static const staffPortalBase = 'https://zeengo.app/portal';
  static const bookingCodePrefix = 'ZN';

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final bookingController = TextEditingController();
  final phoneFocus = FocusNode();
  final bookingFocus = FocusNode();

  final staffCodeController = TextEditingController();
  final staffCodeFocus = FocusNode();

  final isLoading = false.obs;
  final formError = RxnString();
  final staffExpanded = false.obs;
  final staffError = RxnString();

  /// Keeps `ZN` prefix while the user types (e.g. `0000` → `ZN0000`).
  late final TextInputFormatter bookingCodeFormatter =
      _BookingCodePrefixFormatter(prefix: bookingCodePrefix);

  String? validatePhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return Enus.phoneRequired.tr;
    return null;
  }

  String? validateBookingCode(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty || v == bookingCodePrefix) {
      return Enus.bookingCodeRequired.tr;
    }
    return null;
  }

  void focusBookingCode() => bookingFocus.requestFocus();

  void clearLoginFields() {
    phoneController.clear();
    bookingController.clear();
    formError.value = null;
  }

  /// `POST /auth/client/login` — phone + booking code.
  Future<void> login() async {
    if (isLoading.value) return;

    FocusManager.instance.primaryFocus?.unfocus();
    formError.value = null;

    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final bookingCode = _normalizeBookingCode(bookingController.text);
    isLoading.value = true;
    try {
      final response = await authRepo.loginRepo(
        phone: phoneController.text.trim(),
        bookingCode: bookingCode,
      );

      debugPrint('====> LOGIN statusCode: ${response.statusCode}');
      debugPrint('====> LOGIN full response body: ${response.body}');
      debugPrint('====> LOGIN statusText: ${response.statusText}');
      debugPrint('====> LOGIN bodyString: ${response.bodyString}');
      debugPrint(
        '====> LOGIN request phone=${phoneController.text.trim()} '
        'bookingCode=$bookingCode',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is! Map<String, dynamic>) {
          formError.value = 'Unexpected response from server';
          debugPrint('====> LOGIN unexpected body type: ${body.runtimeType}');
          return;
        }

        final ApiResponse<LoginModel> model =
            ApiResponse.fromJson(body, LoginModel.fromJson);

        debugPrint(
          '====> LOGIN parsed ApiResponse '
          'status=${model.status} message=${model.message} error=${model.error}',
        );
        debugPrint(
          '====> LOGIN parsed data: accessToken=${model.data?.accessToken} '
          'refreshToken=${model.data?.refreshToken} '
          'user=${model.data?.user?.toJson()}',
        );

        if (model.status == 200 && model.data != null) {
          final data = model.data!;
          await sharedPreferences.setString(
            Constants.accessToken,
            data.accessToken ?? '',
          );
          await sharedPreferences.setString(
            Constants.refreshToken,
            data.refreshToken ?? '',
          );
          await sharedPreferences.setString(
            Constants.userId,
            data.user?.id ?? '',
          );
          await sharedPreferences.setString(
            Constants.userFullName,
            data.user?.fullName ?? '',
          );
          await sharedPreferences.setString(
            Constants.userPhone,
            data.user?.phone ?? phoneController.text.trim(),
          );
          await sharedPreferences.setString(
            Constants.userEmail,
            data.user?.email ?? '',
          );
          await sharedPreferences.setString(
            Constants.userPreferredLang,
            data.user?.preferredLang ?? '',
          );

          debugPrint(
            '====> LOGIN stored accessToken: '
            '${sharedPreferences.getString(Constants.accessToken)}',
          );
          debugPrint(
            '====> LOGIN stored refreshToken: '
            '${sharedPreferences.getString(Constants.refreshToken)}',
          );
          debugPrint(
            '====> LOGIN stored userPhone: '
            '${sharedPreferences.getString(Constants.userPhone)}',
          );

          clearLoginFields();
          Get.off(() => const HomePages());
        } else {
          formError.value = model.error.isNotEmpty
              ? model.error
              : (model.message.isNotEmpty
                  ? model.message
                  : Enus.invalidCredentials.tr);
        }
      } else {
        final body = response.body;
        String message = Enus.invalidCredentials.tr;
        if (body is Map) {
          final error = body['error'];
          if (error is Map && error['message'] != null) {
            message = error['message'].toString();
          } else if (body['message'] != null) {
            message = body['message'].toString();
          }
          debugPrint('====> LOGIN error envelope: $body');
        }
        formError.value = message;
      }
    } catch (e, st) {
      debugPrint('====> LOGIN exception: $e');
      debugPrint('====> LOGIN stack: $st');
      formError.value = 'Some error has occurred, try again later';
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

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

  static String _normalizeBookingCode(String raw) {
    final cleaned = raw.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (cleaned.isEmpty) return '';
    if (cleaned.startsWith(bookingCodePrefix)) return cleaned;
    if (cleaned == 'Z') return bookingCodePrefix;
    return '$bookingCodePrefix$cleaned';
  }

  @override
  void onClose() {
    phoneController.dispose();
    bookingController.dispose();
    phoneFocus.dispose();
    bookingFocus.dispose();
    staffCodeController.dispose();
    staffCodeFocus.dispose();
    super.onClose();
  }
}

/// Forces uppercase alphanumerics and keeps a live `ZN` prefix while typing.
class _BookingCodePrefixFormatter extends TextInputFormatter {
  _BookingCodePrefixFormatter({required this.prefix});

  final String prefix;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final cleaned =
        newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

    if (cleaned.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final text = cleaned.startsWith(prefix)
        ? cleaned
        : (cleaned == 'Z' ? prefix : '$prefix$cleaned');

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
