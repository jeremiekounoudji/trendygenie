import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import '../../../../../models/category_model.dart';
import '../../../../../utils/globalVariable.dart';

class CategorySelector extends StatelessWidget {
  final CategoryModel? selectedCategory;
  final List<CategoryModel> categories;
  final ValueChanged<CategoryModel> onCategoryChanged;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category, color: firstColor),
              const SizedBox(width: 10),
              CustomText(
                text: "Business Category",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ],
          ),
          const SizedBox(height: 15),
          CustomPopup(
            barrierColor: Colors.black12,
            backgroundColor: whiteColor,
            arrowColor: whiteColor,
            showArrow: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            contentDecoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            content: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: categories.map((category) => 
                    InkWell(
                      onTap: () {
                        onCategoryChanged(category);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedCategory?.id == category.id 
                                  ? firstColor 
                                  : blackColor,
                              ),
                            ),
                            if (selectedCategory?.id == category.id)
                              Icon(Icons.check, color: firstColor, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedCategory?.name ?? "Select Category",
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedCategory != null ? blackColor : Colors.grey,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: firstColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
