class IncomeData {
  int netIncome;
  int totalExpense;
  int totalRevenue;
  Map<String, int> perItemExpense;
  Map<String, int> perTypeCollectible;
  Map<String, int> perTypeFee;

  IncomeData(
      {required this.netIncome,
      required this.totalExpense,
      required this.totalRevenue,
      required this.perItemExpense,
      required this.perTypeCollectible,
      required this.perTypeFee});
}
