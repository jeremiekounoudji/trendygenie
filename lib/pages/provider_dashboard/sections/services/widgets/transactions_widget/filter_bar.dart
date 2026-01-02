import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import '../../../../../../utils/globalVariable.dart';
import '../../../../../../models/enums.dart';
import 'date_option_item.dart';
import 'status_option_item.dart';

class FilterBar extends StatelessWidget {
  final String selectedDateFilter;
  final String selectedStatusFilter;
  final Function(String) onDateFilterChanged;
  final Function(String) onStatusFilterChanged;
  final VoidCallback onLoadInitialData;

  const FilterBar({
    super.key,
    required this.selectedDateFilter,
    required this.selectedStatusFilter,
    required this.onDateFilterChanged,
    required this.onStatusFilterChanged,
    required this.onLoadInitialData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                CustomText(
                  text: 'Filter by:',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600]!,
                ),
                const SizedBox(width: 16),
                // Date Filter
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
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  content: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    width: 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DateOptionItem(
                          label: 'All Time',
                          value: 'All Time',
                          hidePopup: () => Navigator.pop(context),
                          selectedValue: selectedDateFilter,
                          onValueChanged: onDateFilterChanged,
                          onLoadInitialData: onLoadInitialData,
                        ),
                        DateOptionItem(
                          label: 'Last 7 Days',
                          value: 'Last 7 Days',
                          hidePopup: () => Navigator.pop(context),
                          selectedValue: selectedDateFilter,
                          onValueChanged: onDateFilterChanged,
                          onLoadInitialData: onLoadInitialData,
                        ),
                        DateOptionItem(
                          label: 'Last 30 Days',
                          value: 'Last 30 Days',
                          hidePopup: () => Navigator.pop(context),
                          selectedValue: selectedDateFilter,
                          onValueChanged: onDateFilterChanged,
                          onLoadInitialData: onLoadInitialData,
                        ),
                        DateOptionItem(
                          label: 'This Month',
                          value: 'This Month',
                          hidePopup: () => Navigator.pop(context),
                          selectedValue: selectedDateFilter,
                          onValueChanged: onDateFilterChanged,
                          onLoadInitialData: onLoadInitialData,
                        ),
                      ],
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        CustomText(
                          text: selectedDateFilter,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[800]!,
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Status Filter
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
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  content: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    width: 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StatusOptionItem(
                          label: 'All',
                          value: 'All',
                          hidePopup: () => Navigator.pop(context),
                          selectedValue: selectedStatusFilter,
                          onValueChanged: onStatusFilterChanged,
                        ),
                        StatusOptionItem(
                          label: 'Completed',
                          value: PaymentStatus.completed.name,
                          color: Colors.green,
                          hidePopup: () => Navigator.pop(context),
                          selectedValue: selectedStatusFilter,
                          onValueChanged: onStatusFilterChanged,
                        ),
                        StatusOptionItem(
                          label: 'Pending',
                          value: PaymentStatus.pending.name,
                          color: Colors.orange,
                          hidePopup: () => Navigator.pop(context),
                          selectedValue: selectedStatusFilter,
                          onValueChanged: onStatusFilterChanged,
                        ),
                        StatusOptionItem(
                          label: 'Failed',
                          value: PaymentStatus.failed.name,
                          color: Colors.red,
                          hidePopup: () => Navigator.pop(context),
                          selectedValue: selectedStatusFilter,
                          onValueChanged: onStatusFilterChanged,
                        ),
                        StatusOptionItem(
                          label: 'Refunded',
                          value: PaymentStatus.refunded.name,
                          color: Colors.grey,
                          hidePopup: () => Navigator.pop(context),
                          selectedValue: selectedStatusFilter,
                          onValueChanged: onStatusFilterChanged,
                        ),
                      ],
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.filter_list, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        CustomText(
                          text: selectedStatusFilter,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[800]!,
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 