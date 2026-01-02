import 'package:flutter/material.dart';
import '../../../../../utils/globalVariable.dart';

class BusinessHoursSection extends StatefulWidget {
  final List<String> businessHours;
  final Function(List<String>) onBusinessHoursChanged;

  const BusinessHoursSection({
    super.key,
    required this.businessHours,
    required this.onBusinessHoursChanged,
  });

  @override
  State<BusinessHoursSection> createState() => _BusinessHoursSectionState();
}

class _BusinessHoursSectionState extends State<BusinessHoursSection> {
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday', 
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  Map<String, Map<String, String>> businessHoursMap = {};

  @override
  void initState() {
    super.initState();
    _initializeBusinessHours();
  }

  void _initializeBusinessHours() {
    // Initialize with existing business hours or default values
    for (String day in daysOfWeek) {
      businessHoursMap[day] = {
        'open': '09:00',
        'close': '17:00',
        'isOpen': 'true'
      };
    }

    // Parse existing business hours
    for (String hourString in widget.businessHours) {
      try {
        final parts = hourString.split(':');
        if (parts.length >= 4) {
          final day = parts[0];
          final isOpen = parts[1] == 'true';
          final openTime = parts[2];
          final closeTime = parts[3];
          
          if (daysOfWeek.contains(day)) {
            businessHoursMap[day] = {
              'open': openTime,
              'close': closeTime,
              'isOpen': isOpen.toString()
            };
          }
        }
      } catch (e) {
        // Skip invalid entries
      }
    }
  }

  void _updateBusinessHours() {
    List<String> hours = [];
    businessHoursMap.forEach((day, times) {
      hours.add('$day:${times['isOpen']}:${times['open']}:${times['close']}');
    });
    widget.onBusinessHoursChanged(hours);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: greyColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Business Hours",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: blackColor,
          ),
          const SizedBox(height: 16),
          ...daysOfWeek.map((day) => _buildDayRow(day)),
        ],
      ),
    );
  }

  Widget _buildDayRow(String day) {
    final dayData = businessHoursMap[day]!;
    final isOpen = dayData['isOpen'] == 'true';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: CustomText(
              text: day.substring(0, 3),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
          ),
          Switch(
            value: isOpen,
            onChanged: (value) {
              setState(() {
                businessHoursMap[day]!['isOpen'] = value.toString();
              });
              _updateBusinessHours();
            },
            activeColor: firstColor,
          ),
          const SizedBox(width: 16),
          if (isOpen) ...[
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildTimeField(
                      value: dayData['open']!,
                      onChanged: (time) {
                        setState(() {
                          businessHoursMap[day]!['open'] = time;
                        });
                        _updateBusinessHours();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: "to",
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: greyColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTimeField(
                      value: dayData['close']!,
                      onChanged: (time) {
                        setState(() {
                          businessHoursMap[day]!['close'] = time;
                        });
                        _updateBusinessHours();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Expanded(
              child: CustomText(
                text: "Closed",
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: greyColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeField({
    required String value,
    required Function(String) onChanged,
  }) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: int.parse(value.split(':')[0]),
            minute: int.parse(value.split(':')[1]),
          ),
        );
        
        if (time != null) {
          final formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
          onChanged(formattedTime);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: greyColor.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomText(
          text: value,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: blackColor,
        ),
      ),
    );
  }
}