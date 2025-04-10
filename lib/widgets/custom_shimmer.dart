import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/global_variables.dart';

class CustomShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double? borderRadius;

  const CustomShimmer({
    Key? key,
    required this.height,
    required this.width,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            borderRadius ?? GlobalVariables.borderRadius,
          ),
        ),
      ),
    );
  }
} 