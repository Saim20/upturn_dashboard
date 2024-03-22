class ExpenseData {
  DateTime transactionDate;
  DateTime incurredDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );
  String? expenseItem;
  String paymentMethod;
  int? amount;

  ExpenseData({
    required this.paymentMethod,
    required this.transactionDate,
  });
}
