class ExpenseData {
  DateTime transactionDate;
  DateTime incurredDate;
  String? expenseItem;
  String paymentMethod;
  int? amount;

  ExpenseData({
    required this.paymentMethod,
    required this.transactionDate,
    required this.incurredDate,
  });
}
