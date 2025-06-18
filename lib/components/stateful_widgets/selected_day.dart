import 'package:flutter/material.dart';

class SelectedDay extends StatefulWidget {
  final List<DateTime> days;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const SelectedDay({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  State<SelectedDay> createState() => _SelectedDayState();
}

class _SelectedDayState extends State<SelectedDay> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: widget.days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final isSelected = index == widget.selectedIndex;
          final day = widget.days[index];
          return GestureDetector(
            onTap: () => widget.onChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              height: 140,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF86B2) : Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: const Color(0xFFFF86B2),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _monthShort(day.month),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _monthShort(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
