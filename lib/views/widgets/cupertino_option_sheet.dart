import 'package:flutter/cupertino.dart';

import '../../utils/values/app_palette.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_fonts.dart';
import 'custom_text_widget.dart';

class CupertinoSheetOption {
  const CupertinoSheetOption({
    required this.label,
    required this.onTap,
    this.leading,
    this.selected = false,
    this.isDestructive = false,
  });

  final String label;
  final Widget? leading;
  final bool selected;
  final bool isDestructive;
  final VoidCallback onTap;
}

/// iOS-style action sheet for **both** Android and iOS (no platform branch).
class CupertinoOptionSheet {
  CupertinoOptionSheet._();

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<CupertinoSheetOption> options,
    required String cancelLabel,
  }) {
    final palette = AppPalette.of(context);

    return showCupertinoModalPopup<void>(
      context: context,
      useRootNavigator: true,
      barrierColor: palette.overlay,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: ColoredBox(
                    color: palette.card,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: MyFonts.roboto,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: palette.textSecondary,
                              decoration: TextDecoration.none,
                              decorationThickness: 0,
                            ),
                          ),
                        ),
                        for (var i = 0; i < options.length; i++) ...[
                          if (i > 0)
                            Container(height: 1, color: palette.border),
                          _OptionTile(option: options[i]),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: palette.card,
                    borderRadius: BorderRadius.circular(14),
                    onPressed: () =>
                        Navigator.of(ctx, rootNavigator: true).pop(),
                    child: Text(
                      cancelLabel,
                      style: const TextStyle(
                        fontFamily: MyFonts.roboto,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: CupertinoColors.activeBlue,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.option});

  final CupertinoSheetOption option;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final color = option.isDestructive
        ? CupertinoColors.destructiveRed
        : palette.textPrimary;
    final centerLabel = option.isDestructive && option.leading == null;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        option.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: centerLabel
            ? Center(
                child: CustomTextWidget(
                  option.label,
                  textAlign: TextAlign.center,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: color,
                  decoration: TextDecoration.none,
                ),
              )
            : Row(
                children: [
                  if (option.leading != null) ...[
                    option.leading!,
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: CustomTextWidget(
                      option.label,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: color,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  if (option.selected)
                    const Icon(
                      CupertinoIcons.check_mark,
                      size: 22,
                      color: MyColors.darkPurple,
                    ),
                ],
              ),
      ),
    );
  }
}
