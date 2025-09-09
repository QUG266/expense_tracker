int daysInMonth(DateTime m) {
  final first = DateTime(m.year, m.month, 1);
  final next = DateTime(m.year, m.month + 1, 1);
  return next.difference(first).inDays;
}

DateTime monthStart(DateTime m) => DateTime(m.year, m.month, 1);
DateTime monthEnd(DateTime m) =>
    DateTime(m.year, m.month + 1, 1).subtract(const Duration(milliseconds: 1));
