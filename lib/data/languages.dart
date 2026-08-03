import 'package:get/get.dart';

import 'enus.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': _en,
        'ar_SA': _ar,
      };

  static const Map<String, String> _en = {
    Enus.appName: 'Zeengo',
    Enus.version: 'Version: @version',
    Enus.or: 'or',
    Enus.comingSoon: 'Coming soon',
    Enus.comingSoonDefaultMessage:
        "We're building something great here. Check back soon for updates.",
    Enus.sectionComingSoon: 'This section is coming soon.',
    Enus.english: 'English',
    Enus.arabic: 'Arabic',
    Enus.chooseLanguage: 'Choose Language',
    Enus.explore: 'Explore',
    Enus.map: 'Map',
    Enus.inbox: 'Inbox',
    Enus.pay: 'Pay',
    Enus.profile: 'Profile',
    Enus.exploreMessage:
        'Your explore feed and nearby venues will show up here soon.',
    Enus.payMessage: 'Payments and wallet features are coming soon.',
    Enus.messages: 'Messages',
    Enus.messagesMessage:
        'Chat with hosts and stay on top of your bookings — launching soon.',
    Enus.guest: 'Guest',
    Enus.showProfile: 'Show profile',
    Enus.trip: 'Trip',
    Enus.bookingDetails: 'Booking Details',
    Enus.dailyProgram: 'Daily Program',
    Enus.requestChanges: 'Request Changes',
    Enus.notifications: 'Notifications',
    Enus.payments: 'Payments',
    Enus.outstandingBalance: 'Outstanding Balance',
    Enus.paymentHistory: 'Payment History',
    Enus.currencyCalculator: 'Currency Calculator',
    Enus.travel: 'Travel',
    Enus.prayerTimes: 'Prayer Times',
    Enus.russiaGuide: 'Russia Guide',
    Enus.maps: 'Maps',
    Enus.nearbyPlaces: 'Nearby Places',
    Enus.support: 'Support',
    Enus.chat: 'Chat',
    Enus.emergencyContacts: 'Emergency Contacts',
    Enus.settings: 'Settings',
    Enus.language: 'Language',
    Enus.about: 'About',
    Enus.logout: 'Logout',
  };

  static const Map<String, String> _ar = {
    Enus.appName: 'زينجو',
    Enus.version: 'الإصدار: @version',
    Enus.or: 'أو',
    Enus.comingSoon: 'قريبًا',
    Enus.comingSoonDefaultMessage:
        'نعمل على شيء رائع هنا. عد لاحقًا للاطلاع على التحديثات.',
    Enus.sectionComingSoon: 'هذا القسم قادم قريبًا.',
    Enus.english: 'الإنجليزية',
    Enus.arabic: 'العربية',
    Enus.chooseLanguage: 'اختر اللغة',
    Enus.explore: 'استكشاف',
    Enus.map: 'الخريطة',
    Enus.inbox: 'الوارد',
    Enus.pay: 'الدفع',
    Enus.profile: 'الملف الشخصي',
    Enus.exploreMessage:
        'سيظهر هنا موجزك الرئيسي والأماكن القريبة قريبًا.',
    Enus.payMessage: 'ميزات الدفع والمحفظة قادمة قريبًا.',
    Enus.messages: 'الرسائل',
    Enus.messagesMessage:
        'تحدث مع المضيفين وتابع حجوزاتك — قريبًا.',
    Enus.guest: 'زائر',
    Enus.showProfile: 'عرض الملف الشخصي',
    Enus.trip: 'الرحلة',
    Enus.bookingDetails: 'تفاصيل الحجز',
    Enus.dailyProgram: 'البرنامج اليومي',
    Enus.requestChanges: 'طلب تغييرات',
    Enus.notifications: 'الإشعارات',
    Enus.payments: 'المدفوعات',
    Enus.outstandingBalance: 'الرصيد المستحق',
    Enus.paymentHistory: 'سجل المدفوعات',
    Enus.currencyCalculator: 'حاسبة العملات',
    Enus.travel: 'السفر',
    Enus.prayerTimes: 'مواقيت الصلاة',
    Enus.russiaGuide: 'دليل روسيا',
    Enus.maps: 'الخرائط',
    Enus.nearbyPlaces: 'الأماكن القريبة',
    Enus.support: 'الدعم',
    Enus.chat: 'محادثة',
    Enus.emergencyContacts: 'جهات اتصال الطوارئ',
    Enus.settings: 'الإعدادات',
    Enus.language: 'اللغة',
    Enus.about: 'حول',
    Enus.logout: 'تسجيل الخروج',
  };
}
