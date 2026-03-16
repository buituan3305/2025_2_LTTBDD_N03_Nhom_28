// Đường dẫn: lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mock_data.dart';
import '../models/transaction.dart';
import '../widgets/new_transaction.dart';
import 'statistic_screen.dart';
import 'infor_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Biến lưu trạng thái Tab đang được chọn (Mặc định 0 là Trang chủ)
  int _selectedIndex = 0;

  // 1. Logic tính toán và xử lý giao dịch (Giữ nguyên)
  double get _totalBalance {
    double total = 0;
    for (var tx in mockTransactions) {
      if (tx.isIncome)
        total += tx.amount;
      else
        total -= tx.amount;
    }
    return total;
  }

  void _addNewTransaction(String txTitle, double txAmount, bool isIncome) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
      isIncome: isIncome,
    );
    setState(() {
      mockTransactions.insert(0, newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      mockTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _editTransaction(
    String id,
    String newTitle,
    double newAmount,
    bool newIsIncome,
  ) {
    final txIndex = mockTransactions.indexWhere((tx) => tx.id == id);
    if (txIndex >= 0) {
      setState(() {
        mockTransactions[txIndex] = Transaction(
          id: id,
          title: newTitle,
          amount: newAmount,
          date: mockTransactions[txIndex].date,
          isIncome: newIsIncome,
        );
      });
    }
  }

  void _showEditDialog(BuildContext context, Transaction tx) {
    final titleController = TextEditingController(text: tx.title);
    final amountController = TextEditingController(
      text: tx.amount.toStringAsFixed(0),
    );
    bool isIncome = tx.isIncome;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Chi tiết giao dịch',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Tên giao dịch'),
                  ),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(labelText: 'Số tiền (VNĐ)'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Loại:', style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          Text('Chi', style: TextStyle(color: Colors.red)),
                          Switch(
                            value: isIncome,
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.red[200],
                            onChanged: (val) {
                              setStateDialog(() {
                                isIncome = val;
                              });
                            },
                          ),
                          Text('Thu', style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    _deleteTransaction(tx.id);
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    'Xóa',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text('Hủy', style: TextStyle(color: Colors.grey)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () {
                        if (titleController.text.isEmpty ||
                            amountController.text.isEmpty)
                          return;
                        _editTransaction(
                          tx.id,
                          titleController.text,
                          double.parse(amountController.text),
                          isIncome,
                        );
                        Navigator.pop(ctx);
                      },
                      child: Text('Lưu', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

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

  // 2. Giao diện "Trang chủ" được tách ra thành một hàm riêng
  Widget _buildDashboard() {
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
        // Đã xóa các nút biểu đồ và chữ i trên này
      ),
      body: Column(
        children: [
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
                      '${NumberFormat('#,##0').format(_totalBalance).replaceAll(',', '.')} đ',
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Giao dịch gần đây',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Chạm để sửa/xóa',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
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
                    onTap: () => _showEditDialog(context, tx),
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
                      '${tx.isIncome ? '+' : '-'}${NumberFormat('#,##0').format(tx.amount).replaceAll(',', '.')} đ',
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
    );
  }

  // Hàm tạo từng nút bấm ở thanh BottomBar
  Widget _buildTabItem(IconData icon, String label, int index) {
    Color color = _selectedIndex == index ? Colors.blueAccent : Colors.grey;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 16.0,
        ), // GIẢM VERTICAL XUỐNG 4.0
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            SizedBox(height: 2), // Ép icon và chữ lại gần nhau hơn
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. KHUNG SƯỜN CHÍNH (Chứa Bottom Navigation Bar)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack giúp giữ nguyên trạng thái các tab khi chuyển đổi
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboard(), // Index 0: Trang chủ
          StatisticScreen(), // Index 1: Báo cáo
          InforScreen(), // Index 2: Tôi
        ],
      ),

      // Nút cộng (+) nổi ở giữa
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        child: Icon(Icons.add, size: 30),
        backgroundColor: Color(0xFFFFD54F), // Màu vàng giống ảnh của bạn
        foregroundColor: Colors.black, // Icon màu đen
        elevation: 4,
      ),

      // Đẩy nút FAB vào chính giữa và neo vào thanh BottomBar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Thanh Navigation Bar khoét lỗ (Notch)
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(), // Tạo hiệu ứng khoét lỗ bo tròn
        notchMargin: 8.0, // Khoảng cách từ nút (+) đến viền
        child: Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cụm bên Trái (Trang chủ)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_buildTabItem(Icons.receipt_long, 'Trang chủ', 0)],
                ),
              ),

              SizedBox(width: 48), // Khoảng trống cho nút (+)
              // Cụm bên Phải (Báo cáo & Tôi)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTabItem(Icons.pie_chart_outline, 'Báo cáo', 1),
                    _buildTabItem(Icons.person_outline, 'Tôi', 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
