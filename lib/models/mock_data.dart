// Đường dẫn: lib/models/mock_data.dart

import 'transaction.dart';

// Dữ liệu giả lập lưu trong biến List để kiểm thử tính năng (đáp ứng yêu cầu 4.1.2)
List<Transaction> mockTransactions = [
  Transaction(
    id: 't1',
    title: 'Lương ',
    amount: 1000000,
    date: DateTime.now().subtract(const Duration(days: 1)),
    isIncome: true,
  ),
  Transaction(
    id: 't2',
    title: 'Ăn sáng ',
    amount: 40000,
    date: DateTime.now(),
    isIncome: false,
  ),
  Transaction(
    id: 't3',
    title: 'Mua quà',
    amount: 85000,
    date: DateTime.now().subtract(const Duration(days: 2)),
    isIncome: false,
  ),
  Transaction(
    id: 't4',
    title: 'Tiền tiêu vặt',
    amount: 500000,
    date: DateTime.now().subtract(const Duration(days: 5)),
    isIncome: true,
  ),
];
