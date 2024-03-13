class ExpenseRowData {
  DateTime selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String? expenseItem;
  String? paymentMethod;
  int cashAmount = 0;
}
