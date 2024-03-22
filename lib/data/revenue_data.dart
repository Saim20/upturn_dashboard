class RevenueData {
  DateTime transactionDate;
  Map<String, int?> collectibles;
  Map<String, int?> fees;

  RevenueData({
    required this.transactionDate,
    required this.collectibles,
    required this.fees,
  });
  // int collectibleSteadfast = 0;
  // int collectiblePathao = 0;
  // int collectibleSslcommerz = 0;
  // int feesPathao = 0;
  // int feesSteadfast = 0;
  // int feesSslcommerz = 0;
  // int warehouseSales = 0;
  // int otherIncome = 0;
}
