import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/values/my_color.dart';
class CustomHeaderBarWidget extends StatelessWidget {
  final String? title;
  final bool? radius;
  final double? fontSize;
  final FontWeight? titleFontWeight;
  final Color? titleColor;
  final TextAlign? titleAlign;

  final bool showClear;
  final String? clearText;
  final Color? clearTextColor;
  final double? clearFontSize;
  final FontWeight? clearFontWeight;
  final Function()? functionClear;

  final bool showDivider;
  final String backIconPath;
  final double backIconSize;

  const CustomHeaderBarWidget({
    Key? key,
    this.title,
    this.radius = false,
    this.fontSize,
    this.titleFontWeight,
    this.titleColor,
    this.titleAlign,
    this.showClear = true,
    this.clearText,
    this.clearTextColor,
    this.clearFontSize,
    this.clearFontWeight,
    this.functionClear,
    this.showDivider = true,
    this.backIconPath = "assets/svgs/search_svgs/close_flat.svg",
    this.backIconSize = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Back button
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: MyColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.black.withOpacity(0.10),
                      blurRadius: 7,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                    foregroundColor: Colors.white,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      child: SvgPicture.asset(
                        backIconPath,
                        height: backIconSize,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
