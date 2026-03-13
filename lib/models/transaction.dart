class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome; // true là Khoản Thu, false là Khoản Chi

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}
