import 'dart:ui';

class MyColors {
  // Primary Colors
  static const Color brandPrimary = Color(0xFF007782);
  static const Color textSecondary = Color(0xFF717171);
  static const Color scaffoldMuted = Color(0xFFF7F7F7);
  static const Color borderSubtle = Color(0xFFDDDDDD);
  static const Color primary1 =
      Color.fromRGBO(238, 158, 3, 1); // rgba(255, 192, 0, 1)
  static const Color primary2 =
      Color.fromRGBO(205, 148, 3, 1); // rgba(255, 192, 0, 1)
  static const Color grey = Color.fromRGBO(117, 120, 141, 1);
  static const Color fieldGrey = Color.fromRGBO(117, 120, 141, 0.5);
  static const Color lightGrey = Color.fromRGBO(117, 131, 141, 1);
  static const Color darkWhite = Color.fromRGBO(239, 239, 239, 1);
  static const Color lightRed = Color.fromRGBO(254, 236, 236, 1);
  static const Color background = Color.fromRGBO(255, 255, 255, 1);
  static const Color iconbacgr = Color.fromRGBO(246, 247, 250, 1);
  // Secondary Colors
  static const Color secondaryLight =
      Color(0xFFFFE082); // rgba(255, 224, 130, 1)
  static const Color secondaryLighter =
      Color(0xFFFFF3E0); // rgba(255, 243, 224, 1)
  static const Color secondaryDark = Color(0xFFFFC107); // rgba(255, 193, 7, 1)
  static const Color greenPrimary = Color.fromRGBO(218, 248, 230, 1);
  static const Color green = Color.fromRGBO(34, 173, 92, 1);
  static const Color red = Color(0xFFD50000); // rgba(213, 0, 0, 1)
  static const Color darkyello = Color.fromARGB(255, 222, 203, 33);

  // Gradients (as individual colors)
  static const Color orangeGradientStart =
      Color(0xFFFF6D00); // rgba(255, 109, 0, 1)
  static const Color orangeGradientEnd =
      Color(0xFFFFA000); // rgba(255, 160, 0, 1)
  static const Color bronzeGradientStart =
      Color(0xFF8C7B00); // rgba(140, 123, 0, 1)
  static const Color bronzeGradientEnd =
      Color(0xFFFFA726); // rgba(255, 167, 38, 1)
  static const Color blueGrayGradientStart =
      Color(0xFF90A4AE); // rgba(144, 164, 174, 1)
  static const Color blueGrayGradientEnd =
      Color(0xFFCFD8DC); // rgba(207, 216, 220, 1)

  // Additional Colors
  static const Color white = Color(0xFFFFFFFF); // rgba(255, 255, 255, 1)
  static const Color light = Color(0xFFF9F9F9); // rgba(249, 249, 249, 1)
  static const Color black = Color(0xFF000000); // rgba(0, 0, 0, 1)
  static const Color blackDark = Color(0xFF262626); // rgba(33, 33, 33, 1)

  // Grayscale Colors
  static const Color gray100 = Color(0xFF9EA1A8); // rgba(158, 161, 168, 1)
  static const Color grayscale20 = Color(0xFFBDBDBD); // rgba(189, 189, 189, 1)
  static const Color grayscale30 = Color(0xFF9E9E9E); // rgba(158, 158, 158, 1)
  static const Color grayscale40 = Color(0xFF757575); // rgba(117, 117, 117, 1)
  static const Color grayscale50 = Color(0xFF616161); // rgba(97, 97, 97, 1)
  static const Color grayscale60 = Color(0xFF424242); // rgba(66, 66, 66, 1)
  static const Color grayscale70 = Color(0xFF212121); // rgba(33, 33, 33, 1)
  static const Color grayscale80 = Color(0xFF000000); // rgba(0, 0, 0, 1)
  static const Color grayscale90 = Color(0xFF1B1B1B); // rgba(27, 27, 27, 1)
  static const Color grayscale100 = Color(0xFF212121); // rgba(33, 33, 33, 1)

  // chatBot
  static const Color accentColor = Color(0xFFFFC300);
  static const Color chipBackgroundColor = Color(0x14FFC300);
  static const Color chipBorderColor = Color(0x38FFC300);

  /// User chat bubble gradient (left → right).
  static const Color chatUserGradientStart = Color(0xFFCD9403);
  static const Color chatUserGradientEnd = Color(0xFFFFEC01);

  /// Wave dots on the white bot bubble; `white` would be invisible on white.
  static const Color chatBotWaveDots = Color(0xFFCD9403);
  MyColors._();
}
