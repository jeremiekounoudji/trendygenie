import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Color firstColor = const Color(0xFF16C79A);
Color bgColor = const Color(0xFFF5F7F8);
Color secondColor = const Color(0xFFe06929);
Color thirdColor = const Color(0xFFe5a32b);
Color whiteColor = Colors.white;
Color blackColor = Colors.black;
Color redColor = const Color(0xFFDC2743);

// borders
var smallerBorder = BorderRadius.circular(8);
var mediumBorder = BorderRadius.circular(16);
var largeBorder = BorderRadius.circular(24);


// text const
class CustomText extends StatelessWidget {
  const CustomText({
    required this.fontWeight,
    required this.color,
    required this.text,
    required this.fontSize,
    Key? key,
    this.overflow,
    this.max,
    this.align,
  }) : super(key: key);
  final String text;
  final Color? color;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final int? max;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      softWrap: true,
      textAlign: align,
      overflow: overflow,
      maxLines: max,
    );
  }
}

class CustomGorticText extends StatelessWidget {
  const CustomGorticText({
    required this.fontWeight,
    required this.color,
    required this.text,
    required this.fontSize,
    Key? key,
    this.overflow,
    this.max,
    this.align,
  }) : super(key: key);
  final String text;
  final Color? color;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final int? max;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.pacifico(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      softWrap: true,
      textAlign: align,
      overflow: overflow,
      maxLines: max,
    );
  }
}

// costom icon
class CustomIcon extends StatelessWidget {
  const CustomIcon({Key? key, required this.iconData, required this.size, this.color})
      : super(key: key);
  final IconData iconData;
  final double size;
  final color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Icon(
        iconData,
        color: color,
        size: size,
      ),
    );
  }
}

