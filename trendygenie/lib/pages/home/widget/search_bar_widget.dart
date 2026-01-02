import 'package:flutter/material.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/textfield.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;

  const SearchBarWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'Find your best artist...',
      controller: controller,
      radius: 8,
      prefixIcon: const Icon(Icons.search),
      suffix: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.brown[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.tune, color: Colors.white, size: 20),
      ),
    );
  }
} 