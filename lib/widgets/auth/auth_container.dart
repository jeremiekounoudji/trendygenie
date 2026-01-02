import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trendygenie/utils/globalVariable.dart';

class AuthContainer extends StatelessWidget {
  final Widget child;
  final double? width;

  const AuthContainer({
    super.key,
    required this.child,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.75,
      constraints: const BoxConstraints(
        maxWidth: 450,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: SingleChildScrollView(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
} 