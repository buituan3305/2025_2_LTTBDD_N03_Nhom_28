// Đường dẫn: lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../models/transaction.dart';
import '../widgets/new_transaction.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Hàm tính tổng số dư
  double get _totalBalance {
    double total = 0;
    for (var tx in mockTransactions) {
      if (tx.isIncome) {
        total += tx.amount;
      } else {
        total -= tx.amount;
      }
    }
    return total;
  }

  // Hàm thêm giao dịch mới
  void _addNewTransaction(String txTitle, double txAmount, bool isIncome) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
      isIncome: isIncome,
    );

    setState(() {
      mockTransactions.insert(0, newTx); // Chèn lên đầu danh sách
    });
  }

  // Hàm mở Bottom Sheet (Form nhập liệu)
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Quản lý Tài chính',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.blue),
            onPressed: () {
              // Chuyển sang trang Thông tin nhóm
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Thẻ Tổng số dư
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.blueAccent,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Tổng số dư',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${_totalBalance.toStringAsFixed(0)} đ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tiêu đề danh sách
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Giao dịch gần đây',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Danh sách giao dịch ListView
          Expanded(
            child: ListView.builder(
              itemCount: mockTransactions.length,
              itemBuilder: (context, index) {
                final tx = mockTransactions[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: tx.isIncome
                          ? Colors.green[100]
                          : Colors.red[100],
                      child: Icon(
                        tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                        color: tx.isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(
                      tx.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                    ),
                    trailing: Text(
                      '${tx.isIncome ? '+' : '-'}${tx.amount.toStringAsFixed(0)} đ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: tx.isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
