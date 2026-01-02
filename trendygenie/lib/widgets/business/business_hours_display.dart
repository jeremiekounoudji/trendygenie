import 'package:flutter/material.dart';
import '../../utils/globalVariable.dart';

class BusinessHoursDisplay extends StatelessWidget {
  final List<String> businessHours;
  final bool isCompact;

  const BusinessHoursDisplay({
    super.key,
    required this.businessHours,
    this.isCompact = false,
  });

  Map<String, Map<String, String>> _parseBusinessHours() {
    Map<String, Map<String, String>> hoursMap = {};
    
    final List<String> daysOfWeek = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
      'Friday', 'Saturday', 'Sunday'
    ];

    // Initialize with default closed status
    for (String day in daysOfWeek) {
      hoursMap[day] = {
        'open': '09:00',
        'close': '17:00',
        'isOpen': 'false'
      };
    }

    // Parse existing business hours
    for (String hourString in businessHours) {
      try {
        final parts = hourString.split(':');
        if (parts.length >= 4) {
          final day = parts[0];
          final isOpen = parts[1] == 'true';
          final openTime = parts[2];
          final closeTime = parts[3];
          
          if (daysOfWeek.contains(day)) {
            hoursMap[day] = {
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

    return hoursMap;
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      
      if (hour == 0) {
        return '12:$minute AM';
      } else if (hour < 12) {
        return '$hour:$minute AM';
      } else if (hour == 12) {
        return '12:$minute PM';
      } else {
        return '${hour - 12}:$minute PM';
      }
    } catch (e) {
      return time;
    }
  }

  bool _isCurrentlyOpen() {
    final now = DateTime.now();
    final currentDay = _getDayName(now.weekday);
    final hoursMap = _parseBusinessHours();
    
    if (hoursMap[currentDay]?['isOpen'] != 'true') {
      return false;
    }

    try {
      final openTime = hoursMap[currentDay]!['open']!;
      final closeTime = hoursMap[currentDay]!['close']!;
      
      final openParts = openTime.split(':');
      final closeParts = closeTime.split(':');
      
      final openDateTime = DateTime(
        now.year, now.month, now.day,
        int.parse(openParts[0]), int.parse(openParts[1])
      );
      
      final closeDateTime = DateTime(
        now.year, now.month, now.day,
        int.parse(closeParts[0]), int.parse(closeParts[1])
      );

      return now.isAfter(openDateTime) && now.isBefore(closeDateTime);
    } catch (e) {
      return false;
    }
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (businessHours.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.schedule, color: Colors.grey[600], size: 16),
            const SizedBox(width: 8),
            CustomText(
              text: "Business hours not set",
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600]!,
            ),
          ],
        ),
      );
    }

    final hoursMap = _parseBusinessHours();
    final isOpen = _isCurrentlyOpen();

    if (isCompact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isOpen ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule,
              size: 14,
              color: isOpen ? Colors.green[700] : Colors.red[700],
            ),
            const SizedBox(width: 4),
            CustomText(
              text: isOpen ? "Open" : "Closed",
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isOpen ? Colors.green[700]! : Colors.red[700]!,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: firstColor, size: 20),
              const SizedBox(width: 8),
              CustomText(
                text: "Business Hours",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: blackColor,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOpen ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomText(
                  text: isOpen ? "Open Now" : "Closed",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isOpen ? Colors.green[700]! : Colors.red[700]!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...hoursMap.entries.map((entry) {
            final day = entry.key;
            final hours = entry.value;
            final isOpenDay = hours['isOpen'] == 'true';
            final isToday = day == _getDayName(DateTime.now().weekday);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: CustomText(
                      text: day.substring(0, 3),
                      fontSize: 14,
                      fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                      color: isToday ? firstColor : blackColor,
                    ),
                  ),
                  Expanded(
                    child: CustomText(
                      text: isOpenDay 
                          ? "${_formatTime(hours['open']!)} - ${_formatTime(hours['close']!)}"
                          : "Closed",
                      fontSize: 14,
                      fontWeight: isToday ? FontWeight.w500 : FontWeight.normal,
                      color: isToday ? firstColor : (isOpenDay ? blackColor : Colors.grey[600]!),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}