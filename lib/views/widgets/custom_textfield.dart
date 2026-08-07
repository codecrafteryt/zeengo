/*
  ---------------------------------------
  Project: Zeengo Mobile Application
  Description: Reusable text field (raw + theme-aware outlined style)
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/values/app_palette.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final double? fontSize;
  final FontWeight hintFontWeight;
  final TextEditingController controller;
  final bool isObscureText;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? cursorColor;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final Color? fillColor;
  final Color? focusedBorderColor;
  final Color? focusedFillColor;
  final Color? focusedTextColor;
  final double? width;
  final double? height;
  final Widget? suffixIcon;
  final bool showCustomSendIcon;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onPrefixIconPressed;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final bool readOnly;
  final VoidCallback? onTap;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Color? labelColor;
  final TextStyle? floatingLabelStyle;
  final double? enabledBorderWidth;
  final double? focusedBorderWidth;
  final Color? errorBorderColor;
  final double errorBorderWidth;
  final double focusedErrorBorderWidth;
  final int? maxLength;
  final String? allowedPattern;
  final bool preventSpaces;
  final ValueChanged<String>? onChanged;
  final bool? filled;

  /// When true, applies AppPalette outlined style (border = theme container
  /// border, floating label always on, height 50, etc.) so callers don't
  /// re-specify the same login/form boilerplate.
  final bool themed;

  const CustomTextField({
    super.key,
    this.labelText,
    required this.hintText,
    required this.controller,
    this.hintFontWeight = FontWeight.w400,
    this.isObscureText = false,
    this.borderRadius,
    this.padding,
    this.borderColor,
    this.hintColor,
    this.textColor,
    this.cursorColor,
    this.prefixIcon,
    this.prefixIconColor,
    this.fillColor,
    this.focusedBorderColor,
    this.focusedFillColor,
    this.focusedTextColor,
    this.fontSize,
    this.width,
    this.height,
    this.suffixIcon,
    this.showCustomSendIcon = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onPrefixIconPressed,
    this.contentPadding,
    this.focusNode,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.onTap,
    this.maxLength,
    this.allowedPattern,
    this.preventSpaces = false,
    this.onChanged,
    this.floatingLabelBehavior,
    this.labelColor,
    this.floatingLabelStyle,
    this.enabledBorderWidth,
    this.focusedBorderWidth,
    this.errorBorderColor,
    this.errorBorderWidth = 1.2,
    this.focusedErrorBorderWidth = 1.2,
    this.filled,
    this.themed = false,
  });

  static const _errorColor = Color.fromRGBO(240, 66, 72, 1);

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final resolvedFontSize = fontSize ?? 13;
    final errorColor = errorBorderColor ?? _errorColor;

    // Theme-aware defaults (login / auth outline style).
    final Color resolvedBorder = borderColor ??
        (themed ? palette.border : Colors.grey);
    final Color resolvedFocusedBorder = focusedBorderColor ??
        (themed ? palette.border : Colors.transparent);
    final Color resolvedFill = fillColor ??
        (themed
            ? (isDark ? palette.cardMuted : palette.card)
            : Colors.white);
    final Color resolvedHint = hintColor ??
        (themed ? palette.textSecondary : Colors.grey);
    final Color resolvedText = textColor ??
        (themed ? palette.textPrimary : Colors.black);
    final Color resolvedCursor = cursorColor ??
        (themed ? palette.textPrimary : Colors.black);
    final Color resolvedLabel = labelColor ?? resolvedHint;

    final double? heightConstraint =
        height != null || themed ? (height ?? 50) : null;

    final double resolvedRadius = borderRadius ?? (themed ? 12.r : 8.0);
    final EdgeInsetsGeometry resolvedPadding =
        padding ?? (themed ? EdgeInsets.zero : const EdgeInsets.all(5));
    final bool resolvedFilled = filled ?? true;
    final double resolvedEnabledWidth = enabledBorderWidth ?? 1;
    final double resolvedFocusedWidth =
        focusedBorderWidth ?? (themed ? 1 : 1.5);

    final FloatingLabelBehavior resolvedFloat =
        floatingLabelBehavior ??
            (themed
                ? FloatingLabelBehavior.always
                : FloatingLabelBehavior.auto);

    final TextStyle resolvedFloatingStyle = floatingLabelStyle ??
        TextStyle(
          color: themed ? resolvedLabel : resolvedFocusedBorder,
          fontSize: themed ? 13.sp : resolvedFontSize,
          fontWeight: themed ? FontWeight.w500 : FontWeight.w600,
        );

    final EdgeInsetsGeometry resolvedContentPadding = contentPadding ??
        EdgeInsets.symmetric(
          horizontal: themed ? 16.w : 14.w,
          vertical: heightConstraint != null ? 14.h : 13,
        );

    final radius = BorderRadius.circular(resolvedRadius);

    // InputDecoration cannot lay out with infinite max width (hasSize assert).
    // Expand to parent when width is finite; never force infinity unbounded.
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedWidth = constraints.maxWidth.isFinite;
        final field = TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          maxLength: maxLength,
          inputFormatters: [
            if (maxLength != null)
              LengthLimitingTextInputFormatter(maxLength!),
            if (allowedPattern != null)
              FilteringTextInputFormatter.allow(RegExp(allowedPattern!)),
            if (preventSpaces)
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          decoration: InputDecoration(
            counterText: '',
            filled: resolvedFilled,
            fillColor: resolvedFill,
            isDense: false,
            // Avoid minHeight-only constraints; they fail under unbounded width.
            constraints: heightConstraint != null && hasBoundedWidth
                ? BoxConstraints(
                    minHeight: heightConstraint,
                    maxWidth: constraints.maxWidth,
                  )
                : null,
            labelText: labelText,
            floatingLabelBehavior: resolvedFloat,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            alignLabelWithHint: true,
            hintText: hintText.isEmpty ? null : hintText,
            contentPadding: resolvedContentPadding,
            hintStyle: TextStyle(
              color: resolvedHint,
              fontSize: resolvedFontSize,
              fontWeight: hintFontWeight,
            ),
            labelStyle: TextStyle(
              color: resolvedLabel,
              fontSize: resolvedFontSize,
              fontWeight: FontWeight.w500,
            ),
            floatingLabelStyle: resolvedFloatingStyle,
            errorStyle: TextStyle(
              color: errorColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
            errorMaxLines: 2,
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(
                color: resolvedBorder,
                width: resolvedEnabledWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(
                color: resolvedFocusedBorder,
                width: resolvedFocusedWidth,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(
                color: errorColor,
                width: errorBorderWidth,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(
                color: errorColor,
                width: focusedErrorBorderWidth,
              ),
            ),
            suffixIcon: showCustomSendIcon
                ? Container(margin: EdgeInsets.only(right: 8.0.w))
                : suffixIcon,
            prefixIcon: prefixIcon != null
                ? GestureDetector(
                    onTap: onPrefixIconPressed,
                    child: Icon(
                      prefixIcon,
                      color: prefixIconColor ?? resolvedHint,
                      size: 22.sp,
                    ),
                  )
                : null,
            prefixIconConstraints: prefixIcon != null
                ? BoxConstraints(
                    minWidth: 44.w,
                    minHeight: heightConstraint ?? 48,
                  )
                : null,
            suffixIconConstraints: suffixIcon != null
                ? BoxConstraints(
                    minWidth: 44.w,
                    minHeight: heightConstraint ?? 48,
                  )
                : null,
          ),
          style: TextStyle(
            color: resolvedText,
            fontSize: resolvedFontSize,
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: resolvedCursor,
          validator: validator,
          obscureText: isObscureText,
        );

        return Padding(
          padding: resolvedPadding,
          child: width != null
              ? SizedBox(width: width, child: field)
              : hasBoundedWidth
                  ? SizedBox(width: constraints.maxWidth, child: field)
                  : field,
        );
      },
    );
  }
}
