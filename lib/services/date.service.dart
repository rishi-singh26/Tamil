class DateService {
  static String formatDate(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');

    final formattedDate = '$year-$month-$day $hour:$minute:$second';
    return formattedDate;
  }

  static String getReadableDate(DateTime date, {bool isTwelveHourFormat = false}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));

    if (date.isAfter(today)) {
      return _formatTime(date, isTwelveHourFormat); // Returns time of the day
    } else if (date.isAfter(yesterday)) {
      return 'Yesterday';
    } else if (date.isAfter(weekAgo)) {
      return _getWeekdayName(date.weekday); // Returns day of the week
    } else {
      return _formatDate(date); // Returns date in dd/mm/yy format
    }
  }

  // static String _formatTime(DateTime date, bool isTwelveHourFormat) {
  //   if (isTwelveHourFormat) {
  //     final hour = date.hour;
  //     final period = date.hour < 12 ? 'AM' : 'PM';
  //     final formattedHour = _formatTwoDigit(hour);

  //     return '$formattedHour:${_formatTwoDigit(date.minute)} $period';
  //   } else {
  //     return '${_formatTwoDigit(date.hour)}:${_formatTwoDigit(date.minute)}';
  //   }
  // }

  static String _formatTime(DateTime date, bool isTwelveHourFormat) {
    final hour = isTwelveHourFormat ? ((date.hour + 11) % 12) + 1 : date.hour;
    final formattedHour = _formatTwoDigit(hour);
    final formattedMinute = _formatTwoDigit(date.minute);
    final period = isTwelveHourFormat
        ? date.hour < 12
            ? ' AM'
            : ' PM'
        : '';

    return '$formattedHour:$formattedMinute$period';
  }

  static String _formatTwoDigit(int number) {
    return number.toString().padLeft(2, '0');
  }

  static String _formatDate(DateTime date) {
    return '${_formatTwoDigit(date.day)}/${_formatTwoDigit(date.month)}/${_formatTwoDigit(date.year % 100)}';
  }

  static String _getWeekdayName(int weekday) {
    const weekdayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return weekdayNames[weekday - 1];
  }
}
