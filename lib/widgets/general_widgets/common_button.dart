import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/globalVariable.dart';
import 'common_image.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.textColor,
    required this.bgColor,
    required this.text,
    required this.onTap,
    this.width,
    this.isLoading,
    this.haveBorder,
    this.verticalPadding,
    this.radius,
  });
  final Color textColor;
  final Color bgColor;
  final String text;
  final double? width;
  final double? verticalPadding;
  final double? radius;
  final bool? haveBorder;
  final RxBool? isLoading;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: (radius == null)
                ? BorderRadius.circular(20)
                : BorderRadius.circular(radius!),
            border: (haveBorder != null && haveBorder == true)
                ? Border.all(color: firstColor)
                : null),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 20, vertical: verticalPadding ?? 10),
          child: Center(
            child: Obx(
              (){
                return isLoading?.value == true
                ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: whiteColor,
                    ),
                )
                : CustomText(
                    fontWeight: FontWeight.normal,
                    color: textColor,
                    text: text.obs.value,
                    fontSize: 15,
                    max: 1,
                  );
              }
            )
          ),
        ),
      ),
    );
  }
}
