class RevenueData {
  DateTime transactionDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Map<String, int> collectibles;
  Map<String, int> fees;

  RevenueData({
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
