
String monthName(int num) {
  switch (num) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return 'Invalid';
  }
}

int numberOfDaysInMonth(int monthNumber, int year) {
  switch (monthNumber) {
    case 4:
    case 6:
    case 9:
    case 11:
      return 30;
    case 2:
      return isLeapYear(year) ? 29 : 28;
    default:
      return 31;
  }
}

bool isLeapYear(int year) =>
    (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

String formattedDate(DateTime date) {
  return '${date.day} - ${monthName(date.month)} - ${date.year}';
}
