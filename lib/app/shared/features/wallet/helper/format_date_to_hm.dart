import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/providers/service_providers.dart';

String formatDateToHm(String? timeStamp) => timeStamp == null
    ? ''
    : DateFormat('Hm').format(DateTime.parse('${timeStamp}Z').toLocal());

String formatDateToHmFromDate(String time) =>
    DateFormat('Hm').format(DateTime.parse(time).toLocal());

String formatDateToDMYFromDate(String time) =>
    DateFormat('dd.MM.yyyy').format(DateTime.parse(time).toLocal());

String formatDateToDMonthYFromDate(String time) =>
    DateFormat('dd MMMM yyyy').format(DateTime.parse(time).toLocal());

String formatDateToDMY(String? timeStamp) => timeStamp == null
    ? ''
    : DateFormat('dd.MM.yyyy')
        .format(DateTime.parse('${timeStamp}Z').toLocal());

String convertDateToTomorrowOrDate(String? timeStamp, BuildContext context,) {
  final intl = context.read(intlPod);

  if (timeStamp == null) {
    return '';
  } else {
    final now = DateTime.now();
    final date = DateTime.parse('${timeStamp}Z').toLocal();
    final isTomorrow = DateTime(date.year, date.month, date.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        1;

    return isTomorrow ? intl.tomorrow : DateFormat('dd.MM.yyyy').format(date);
  }
}
