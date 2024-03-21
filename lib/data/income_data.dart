class IncomeData {
  int netIncome;
  int totalExpense;
  int totalRevenue;
  Map<String, int> perItemExpense;

  IncomeData(
      {this.netIncome = 0,
      this.totalExpense = 0,
      this.totalRevenue = 0,
      this.perItemExpense = const {}});
}
