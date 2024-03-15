class ExpenseData {
  DateTime transactionDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime incurredDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );
  String? expenseItem;
  String? paymentMethod;
  int amount = 0;
}
