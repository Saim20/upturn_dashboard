String monthName(int num){
  switch(num){
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

DateTime dateTimeFromMonth(String month){
  DateTime now = DateTime.now();
  switch(month){
    case 'January':
      return DateTime(now.year, 1, now.day);
    case 'February':
      return DateTime(now.year, 2, now.day);
    case 'March':
      return DateTime(now.year, 3, now.day);
    case 'April':
      return DateTime(now.year, 4, now.day);
    case 'May':
      return DateTime(now.year, 5, now.day);
    case 'June':
      return DateTime(now.year, 6, now.day);
    case 'July':
      return DateTime(now.year, 7, now.day);
    case 'August':
      return DateTime(now.year, 8, now.day);
    case 'September':
      return DateTime(now.year, 9, now.day);
    case 'October':
      return DateTime(now.year, 10, now.day);
    case 'November':
      return DateTime(now.year, 11, now.day);
    case 'December':
      return DateTime(now.year, 12, now.day);
    default:
      return DateTime.now();
  }
}

String formattedDate(DateTime date){
  return '${date.day} - ${monthName(date.month)} - ${date.year}';
}