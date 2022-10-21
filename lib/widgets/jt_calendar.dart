import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

Future<DateTime?> pickDate(BuildContext context) {
  return showRoundedDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(DateTime.now().year - 200),
    lastDate: DateTime(DateTime.now().year + 200),
    textPositiveButton: 'Lưu',
    textNegativeButton: 'Hủy',
    theme: ThemeData(primarySwatch: Colors.blue),
    styleDatePicker: MaterialRoundedDatePickerStyle(
      textStyleDayButton: const TextStyle(fontSize: 32, color: Colors.black),
      textStyleYearButton: const TextStyle(
        fontSize: 48,
        color: Colors.white,
      ),
      textStyleDayHeader: const TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      textStyleCurrentDayOnCalendar: TextStyle(
          fontSize: 28, color: Colors.blue[600], fontWeight: FontWeight.bold),
      textStyleDayOnCalendar:
          const TextStyle(fontSize: 28, color: Colors.black),
      textStyleDayOnCalendarSelected: const TextStyle(
          fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
      textStyleDayOnCalendarDisabled:
          TextStyle(fontSize: 28, color: Colors.black.withOpacity(0.1)),
      textStyleMonthYearHeader: const TextStyle(
          fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
      paddingDatePicker: const EdgeInsets.all(0),
      paddingMonthHeader: const EdgeInsets.all(28),
      paddingActionBar: const EdgeInsets.all(12),
      paddingDateYearHeader: const EdgeInsets.all(28),
      sizeArrow: 46,
      colorArrowNext: Colors.black,
      colorArrowPrevious: Colors.black,
      marginLeftArrowPrevious: 12,
      marginTopArrowPrevious: 12,
      marginTopArrowNext: 12,
      marginRightArrowNext: 28,
      textStyleButtonAction: const TextStyle(fontSize: 28, color: Colors.black),
      textStyleButtonPositive: const TextStyle(
          fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),
      textStyleButtonNegative:
          TextStyle(fontSize: 24, color: Colors.black.withOpacity(0.5)),
      decorationDateSelected:
          BoxDecoration(color: Colors.blue[600], shape: BoxShape.circle),
      backgroundPicker: Colors.white,
      backgroundActionBar: Colors.white,
      backgroundHeaderMonth: Colors.white,
    ),
  );
}
