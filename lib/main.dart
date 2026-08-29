import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller/language_controller.dart';
import 'controller/theme_controller.dart';
import 'data/helper/get_di.dart';
import 'data/languages.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'services/stripe_payment_service.dart';
import 'utils/values/app_theme.dart';
import 'views/screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  await DependencyInjection.init();
  await NotificationService.instance.init();
  await StripePaymentService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Cache themes so Obx rebuilds do not recreate ThemeData every frame.
  late final ThemeData _lightTheme = AppTheme.light();
  late final ThemeData _darkTheme = AppTheme.dark();

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    final themeController = Get.find<ThemeController>();

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(
          () => GetMaterialApp(
            title: 'Zeengo',
            debugShowCheckedModeBanner: false,
            translations: AppTranslations(),
            locale: languageController.locale.value,
            fallbackLocale: LanguageController.english,
            supportedLocales: const [
              LanguageController.english,
              LanguageController.arabic,
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: _lightTheme,
            darkTheme: _darkTheme,
            themeMode: themeController.themeMode,
            home: child,
          ),
        );
      },
      child: const SplashScreen(),
    );
  }
}
