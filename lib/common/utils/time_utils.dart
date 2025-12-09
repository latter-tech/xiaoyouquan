
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

class TimeUtils {

  static int getTimestampNow() {
    DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch ~/ 1000;
  }

  static Widget timeConvert(BuildContext context, DateTime dateTime) {
    return Text(
      format(context, dateTime),
      style: const TextStyle(
        color: Colors.grey,   // 默认浅灰色，约等于 #9E9E9E
        fontSize: 12,         // 比正文小一号
      ),
    );
  }

  /**
   * 时间格式化
   */
  static String format(BuildContext context, DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    final loc = S.of(context);

    String formatUnit(int value, String singularKey, String pluralKey) {
      final unit = value == 1 ? singularKey : pluralKey;
      final unitText = _getLocalizedUnit(loc, unit);
      return loc.timeAgo(value.toString(), unitText);
    }

    if (diff.inDays > 365) {
      final years = diff.inDays ~/ 365;
      return formatUnit(years, 'year', 'years');
    } else if (diff.inDays > 30) {
      final months = diff.inDays ~/ 30;
      return formatUnit(months, 'month', 'months');
    } else if (diff.inDays > 7) {
      final weeks = diff.inDays ~/ 7;
      return formatUnit(weeks, 'week', 'weeks');
    } else if (diff.inDays > 0) {
      return formatUnit(diff.inDays, 'day', 'days');
    } else if (diff.inHours > 0) {
      return formatUnit(diff.inHours, 'hour', 'hours');
    } else if (diff.inMinutes > 0) {
      return formatUnit(diff.inMinutes, 'minute', 'minutes');
    } else {
      return loc.justNow;
    }
  }

  static String _getLocalizedUnit(S loc, String key) {
    switch (key) {
      case 'year':
        return loc.year;
      case 'years':
        return loc.years;
      case 'month':
        return loc.month;
      case 'months':
        return loc.months;
      case 'week':
        return loc.week;
      case 'weeks':
        return loc.weeks;
      case 'day':
        return loc.day;
      case 'days':
        return loc.days;
      case 'hour':
        return loc.hour;
      case 'hours':
        return loc.hours;
      case 'minute':
        return loc.minute;
      case 'minutes':
        return loc.minutes;
      default:
        return key;
    }
  }

}