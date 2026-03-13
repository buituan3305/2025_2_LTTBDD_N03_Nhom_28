import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx; // Hàm nhận từ màn hình chính để thêm dữ liệu

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isIncome = false; // Mặc định nút chọn là "Khoản Chi"

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text) ?? 0;

    // Validate: Bắt lỗi nếu người dùng không nhập gì hoặc nhập số âm
    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    // Gọi hàm addTx được truyền từ HomeScreen
    widget.addTx(enteredTitle, enteredAmount, _isIncome);

    // Đóng Bottom Sheet lại sau khi lưu thành công
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Tên giao dịch'),
              controller: _titleController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Số tiền (VNĐ)'),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Loại giao dịch:', style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Text('Chi', style: TextStyle(color: Colors.red)),
                    Switch(
                      value: _isIncome,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red[200],
                      onChanged: (val) {
                        setState(() {
                          _isIncome = val;
                        });
                      },
                    ),
                    Text('Thu', style: TextStyle(color: Colors.green)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(
                'Lưu Giao Dịch',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: _submitData,
            ),
          ],
        ),
      ),
    );
  }
}
