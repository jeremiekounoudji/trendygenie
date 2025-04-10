import 'package:flutter/material.dart';

class Verticalspace extends StatelessWidget {
  const Verticalspace({super.key, required this.h});
  final double h;

  @override
  Widget build(BuildContext context) {
    return            SizedBox(height: h,);

  }
}