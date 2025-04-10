import 'package:flutter/material.dart';
import '../models/service_item.dart';
import '../utils/global_variables.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ServiceCard({
    Key? key,
    required this.service,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(GlobalVariables.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageHeader(),
          Padding(
            padding: const EdgeInsets.all(GlobalVariables.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleRow(),
                const SizedBox(height: GlobalVariables.smallPadding),
                _buildCategories(),
                const SizedBox(height: GlobalVariables.smallPadding),
                _buildPriceAndRating(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(GlobalVariables.borderRadius),
            topRight: Radius.circular(GlobalVariables.borderRadius),
          ),
          child: Image.network(
            service.image,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Row(
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
                color: Colors.white,
                style: IconButton.styleFrom(
                  backgroundColor: GlobalVariables.primaryColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete),
                color: Colors.white,
                style: IconButton.styleFrom(
                  backgroundColor: GlobalVariables.secondaryColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            service.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: GlobalVariables.smallPadding,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: service.isActive ?? true
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            service.isActive ?? true ? 'Available' : 'Unavailable',
            style: TextStyle(
              color: service.isActive ?? true ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildCategoryChip(service.category.name),
        if (service.foodCategory != null)
          _buildCategoryChip(service.foodCategory!, isSubcategory: true),
      ],
    );
  }

  Widget _buildCategoryChip(String text, {bool isSubcategory = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSubcategory
            ? GlobalVariables.accentColor.withOpacity(0.1)
            : GlobalVariables.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSubcategory
              ? GlobalVariables.accentColor
              : GlobalVariables.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriceAndRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$${service.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: GlobalVariables.primaryColor,
          ),
        ),
        Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              service.rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' (${service.viewCount ?? 0})',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
} 