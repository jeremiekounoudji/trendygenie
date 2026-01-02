import 'package:flutter/material.dart';
import 'package:trendygenie/utils/globalVariable.dart';

class CategoriesListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const CategoriesListWidget({
    super.key,
    required this.categories,
  });

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            category['icon'],
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(height: 8),
        CustomText(
          text: category['name'],
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: blackColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 24),
          child: _buildCategoryItem(categories[index]),
        ),
      ),
    );
  }
} 