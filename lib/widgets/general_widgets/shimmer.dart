import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/globalVariable.dart';



class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    super.key,
    required this.h,
    required this.w,
  });

  final double h;
  final double w;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Shimmer.fromColors(
          baseColor: firstColor.withOpacity(.2),
          highlightColor: firstColor.withOpacity(.3),
          child: Container(
            decoration:  BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10)

            ),
          ),
        ),
      ),
    );
  }
}

// class ErrorBox extends StatelessWidget {
//   const ErrorBox({
//     Key? key, required this.text,
//   }) : super(key: key);

//   final  text;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         height: 150,
//         child: Center(
//           child: CustomText(
//             fontSize: 15,
//             fontWeight: FontWeight.bold,
//             text: "$text",
//             color: blackColor,
//           ),
//         ),
//       ),
//     );
//   }
// }
