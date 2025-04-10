import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import 'globalVariable.dart';

class Utility extends GetxController {
  showInfo(title, message, context, btnText, btnFunction,[customView]) {
    return Dialogs.materialDialog(
      customView: customView??Container(),
        msg: message,
        title: title,
        color: Colors.white,
        context: context,
        actionsBuilder: (context) {
          return IconsButton(
            onPressed: btnFunction,
            text: btnText,
            // iconData: Icons.delete,
            color: firstColor,
            textStyle: TextStyle(color: whiteColor),
          );
        },
        );
  }

// dialogs utils
  showSnack(title, value, duration,[isError]) {
    return Get.snackbar("$title", '$value',
        duration: Duration(seconds: duration),
        snackPosition: SnackPosition.TOP,
        backgroundColor: isError ? redColor.withOpacity(.8) : firstColor.withOpacity(.8),
        colorText: whiteColor);
  }

  showPending() {
    return Get.dialog(
        Material(
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.yellowAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    color: blackColor,
                    strokeWidth: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                      text: "Patientez...",
                      max: 1,
                      align: TextAlign.center,
                      fontSize: 14),
                )
              ],
            ),
          ),
        ),
        barrierDismissible: false);
  }
}
