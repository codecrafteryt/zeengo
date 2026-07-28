/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: custom text field
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final double? fontSize;
  final FontWeight hintFontWeight;
  final TextEditingController controller;
  final bool isObscureText;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final Color hintColor;
  final Color textColor;
  final Color cursorColor;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final Color fillColor;
  final Color focusedBorderColor;
  final Color focusedFillColor;
  final Color focusedTextColor;
  final double? width;
  final double? height;
  final Widget? suffixIcon;
  final bool showCustomSendIcon;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onPrefixIconPressed;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode; // Added FocusNode property
  final ValueChanged<String>? onFieldSubmitted;
  final bool readOnly;
  final VoidCallback? onTap;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Color? labelColor;
  final TextStyle? floatingLabelStyle;
  final double enabledBorderWidth;
  final double focusedBorderWidth;
  final Color? errorBorderColor;
  final double errorBorderWidth;
  final double focusedErrorBorderWidth;
  // parameters for limitations
  final int? maxLength;
  final String? allowedPattern;
  final bool preventSpaces;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.labelText,
    required this.hintText,
    required this.controller,
    this.hintFontWeight = FontWeight.w400,
    this.isObscureText = false,
    this.borderRadius = 10.0,
    this.padding = const EdgeInsets.all(5),
    this.borderColor = Colors.grey,
    this.hintColor = Colors.grey,
    this.textColor = Colors.black,
    this.cursorColor = Colors.black,
    this.prefixIcon,
    this.prefixIconColor,
    this.fillColor = Colors.white,
    this.focusedBorderColor = Colors.transparent,
    this.focusedFillColor = Colors.white,
    this.focusedTextColor = Colors.black,
    this.fontSize,
    this.width,
    this.height,
    this.suffixIcon,
    this.showCustomSendIcon = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onPrefixIconPressed,
    this.contentPadding,
    this.focusNode, // Initialize focusNode
    this.onFieldSubmitted, // Initialize onFieldSubmitted
    this.readOnly = false,
    this.onTap,
    this.maxLength,
    this.allowedPattern,
    this.preventSpaces = false,
    this.onChanged,
    this.floatingLabelBehavior,
    this.labelColor,
    this.floatingLabelStyle,
    this.enabledBorderWidth = 2,
    this.focusedBorderWidth = 1,
    this.errorBorderColor,
    this.errorBorderWidth = 1,
    this.focusedErrorBorderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          focusNode: focusNode, // Assign focusNode here
          onFieldSubmitted: onFieldSubmitted, // Assign onFieldSubmitted here
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          maxLength: maxLength,
          // Add input formatters based on parameters
          inputFormatters: [
            if (maxLength != null)
              LengthLimitingTextInputFormatter(maxLength!),
            if (allowedPattern != null)
              FilteringTextInputFormatter.allow(RegExp(allowedPattern!)),
            if (preventSpaces)
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
            // maxLength: 50,                    // Limit to 50 characters
            // allowedPattern: r'[a-zA-Z0-9]',  // Only allow alphanumeric
            // preventSpaces: true,             // Prevent spaces
          ],
          decoration: InputDecoration(
            counterText: "", // Hides the character counter
            filled: true,
            fillColor: fillColor,
            labelText: labelText,
            floatingLabelBehavior: floatingLabelBehavior,
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13),
            hintStyle: TextStyle(
              color: hintColor,
              fontSize: fontSize,
              fontWeight: hintFontWeight,
            ),
            labelStyle: TextStyle(color: labelColor ?? hintColor, fontSize: fontSize),
            floatingLabelStyle: floatingLabelStyle,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor, width: enabledBorderWidth),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: focusedBorderColor, width: focusedBorderWidth),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: errorBorderColor ?? const Color.fromRGBO(240, 66, 72, 1),
                width: errorBorderWidth,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: errorBorderColor ?? const Color.fromRGBO(240, 66, 72, 1),
                width: focusedErrorBorderWidth,
              ),
            ),
            suffixIcon: showCustomSendIcon
                ? Container(
              margin: EdgeInsets.only(right: 8.0.w),
              // child: GestureDetector(
              //   onTap: () {
              //     // Custom action on tap
              //   },
              //   child: CircleAvatar(
              //     backgroundColor: const Color.fromRGBO(117, 129, 141, 1),
              //     child: FaIcon(
              //       FontAwesomeIcons.paperPlane,
              //       color: const Color.fromRGBO(255, 249, 233, 1),
              //       size: 20.h,
              //     ),
              //   ),
              // ),
            )
                : suffixIcon,
            prefixIcon: prefixIcon != null
                ? GestureDetector(
              onTap: onPrefixIconPressed, // Add this line
              child:
              Icon(prefixIcon, color: prefixIconColor ?? hintColor),
            )
                : null,
          ),
          style: TextStyle(color: textColor),
          cursorColor: cursorColor,
          validator: validator,
          obscureText: isObscureText,
        ),
      );
  }
}
