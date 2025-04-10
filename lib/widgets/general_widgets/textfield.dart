import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/globalVariable.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType inputType;
  final TextInputAction textInputAction;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final double? radius;
  final bool enabled;
  final Icon? prefixIcon;
  final RxBool? obscureText;
  final Widget? suffix;
  final bool readOnly;
  final Color? borderColor;
  final FocusNode? focusNode;
  final String? initialValue;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final void Function()? onEditingComplete;
  final Color? fillColor;
  final bool? filled;
  final bool showLabel;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.controller,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.radius,
    this.focusNode,
    this.obscureText,
    this.enabled = true,
    this.readOnly = false,
    this.validator,
    this.initialValue,
    this.onTap,
    this.borderColor,
    this.suffix,
    this.textInputAction = TextInputAction.next,
    this.onSaved,
    this.onChanged,
    this.prefixIcon,
    this.onEditingComplete,
    this.fillColor,
    this.filled,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Obx( () {
          return TextFormField(
            controller: controller,
            keyboardType: inputType,
            obscureText:obscureText==null?false.obs.value: obscureText!.value,
            focusNode: focusNode,
            initialValue: initialValue,
            validator: validator,
            enabled: enabled,
            onTap: onTap,
            readOnly: readOnly,
            onSaved: onSaved,
            minLines: minLines,
            maxLines: maxLines,
            maxLength: maxLength,
            textInputAction: textInputAction,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            
            decoration: InputDecoration(
              filled: filled,
              fillColor: fillColor,
              // border: InputBorder.none,
              suffix:suffix ,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color:borderColor?? blackColor),
                borderRadius:  BorderRadius.all(Radius.circular(radius==null?50:radius!)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:  BorderRadius.all(Radius.circular(radius==null?50:radius!)),
                borderSide: BorderSide(color: firstColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius:  BorderRadius.all(Radius.circular(radius==null?50:radius!)),
                borderSide: BorderSide(color: redColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:  BorderRadius.all(Radius.circular(radius==null?50:radius!)),
                borderSide: BorderSide(color: redColor),
              ),
              // disabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              //   borderSide: BorderSide(color: blackColor),
              // ),
              
              prefixIcon: prefixIcon,
              counterText: "",
              hintText: hintText,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.5),
              iconColor: blackColor,
              prefixIconColor: blackColor,
              label: showLabel ? CustomText(
                fontWeight: FontWeight.bold,
                color: blackColor,
                text: hintText,
                fontSize: 12,
                max: 1,
              ) : null,
              hintStyle:  TextStyle(
                color: blackColor.withOpacity(.4),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        }
      ),
    );
  }

  static InputDecoration get myDecoration {
    return InputDecoration(
      // labelText: labelText ,

      // hintText: labelText,

      filled: true,

      contentPadding: const EdgeInsets.all(8.0),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: blackColor, width: 1),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: blackColor, width: 1),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: blackColor, width: 1),
      ),
    );
  }

  static InputDecoration get myDecoration1 {
    return InputDecoration(
      // labelText: labelText ,

      // hintText: labelText,
      prefixIcon: const CircleAvatar(
          radius: 5,
          backgroundColor: Colors.transparent,
          child: Image(
            image: AssetImage("assets/icons/certificate.png"),
            height: 20,
            width: 20,
          )),

      filled: true,

      contentPadding: const EdgeInsets.all(20.0),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: blackColor, width: 1),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: blackColor, width: 1),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: blackColor, width: 1),
      ),
    );
  }
}

class CustomTextFieldWithoutBorder extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType inputType;
  final TextInputAction textInputAction;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final Icon? prefixIcon;
  final bool readOnly;
  final FocusNode? focusNode;
  final String? initialValue;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final void Function()? onEditingComplete;
  final Color? fillColor;
  final bool? filled;

  const CustomTextFieldWithoutBorder({
    super.key,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.controller,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.validator,
    this.initialValue,
    this.suffix,
    this.onTap,
    this.textInputAction = TextInputAction.next,
    this.onSaved,
    this.onChanged,
    this.prefixIcon,
    this.onEditingComplete,
    this.fillColor,
    this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        focusNode: focusNode,
        initialValue: initialValue,
        validator: validator,
        enabled: enabled,
        onTap: onTap,
        readOnly: readOnly,
        onSaved: onSaved,
        minLines: minLines,
        maxLines: maxLines,
        maxLength: maxLength,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
              suffix:suffix ,

          border: InputBorder.none,
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: blackColor),
          //   borderRadius: BorderRadius.all(Radius.circular(10)),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(10)),
          //   borderSide: BorderSide(color: firstColor),
          // ),
          // focusedErrorBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(10)),
          //   borderSide: BorderSide(color: redColor),
          // ),
          // errorBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(10)),
          //   borderSide: BorderSide(color: redColor),
          // ),
          // disabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(10)),
          //   borderSide: BorderSide(color: blackColor),
          // ),
          prefixIcon: prefixIcon,
          counterText: "",
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          iconColor: blackColor,
          prefixIconColor: blackColor,

          hintStyle: const TextStyle(
            color: Colors.black26,
            fontSize: 13.26,
            fontWeight: FontWeight.w500,
          ),
          filled: filled,
          fillColor: fillColor,
        ),
      ),
    );
  }

  static InputDecoration get myDecoration {
    return InputDecoration(
      // labelText: labelText ,

      // hintText: labelText,

      filled: true,

      contentPadding: const EdgeInsets.all(8.0),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: blackColor, width: 1),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: blackColor, width: 1),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: blackColor, width: 1),
      ),
    );
  }

  static InputDecoration get myDecoration1 {
    return InputDecoration(
      // labelText: labelText ,

      // hintText: labelText,
      prefixIcon: const CircleAvatar(
          radius: 5,
          backgroundColor: Colors.transparent,
          child: Image(
            image: AssetImage("assets/icons/certificate.png"),
            height: 20,
            width: 20,
          )),

      filled: true,

      contentPadding: const EdgeInsets.all(20.0),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: blackColor, width: 1),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: blackColor, width: 1),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: blackColor, width: 1),
      ),
    );
  }
}
