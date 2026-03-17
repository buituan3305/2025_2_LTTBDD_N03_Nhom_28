// Đường dẫn: lib/screens/statistic_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mock_data.dart';

class StatisticScreen extends StatelessWidget {
  // Hàm format tiền tệ (có dấu chấm)
  String _formatCurrency(double amount) {
    return '${NumberFormat('#,##0').format(amount).replaceAll(',', '.')} đ';
  }

  @override
  Widget build(BuildContext context) {
    // 1. Xử lý logic: Nhóm dữ liệu theo tháng
    // Tạo một Map để lưu trữ kiểu: {"Tháng 3/2026": {"thu": 1500000, "chi": 500000}}
    Map<String, Map<String, double>> monthlyData = {};

    for (var tx in mockTransactions) {
      String monthYear = 'Tháng ${tx.date.month}/${tx.date.year}';

      // Nếu tháng này chưa có trong danh sách thì tạo mới
      if (!monthlyData.containsKey(monthYear)) {
        monthlyData[monthYear] = {'thu': 0.0, 'chi': 0.0};
      }

      // Cộng dồn tiền vào Thu hoặc Chi
      if (tx.isIncome) {
        monthlyData[monthYear]!['thu'] =
            monthlyData[monthYear]!['thu']! + tx.amount;
      } else {
        monthlyData[monthYear]!['chi'] =
            monthlyData[monthYear]!['chi']! + tx.amount;
      }
    }

    // Chuyển danh sách các tháng thành dạng List để hiển thị
    List<String> months = monthlyData.keys.toList();

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text(
          'Thống kê theo tháng',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.orange[50],
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ), // Nút mũi tên quay lại màu đen
      ),
      body: months.isEmpty
          ? Center(
              child: Text(
                'Chưa có dữ liệu giao dịch',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              itemCount: months.length,
              itemBuilder: (ctx, index) {
                String monthKey = months[index];
                double tongThu = monthlyData[monthKey]!['thu']!;
                double tongChi = monthlyData[monthKey]!['chi']!;
                double soDu = tongThu - tongChi;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề Tháng
                        Text(
                          monthKey,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Divider(height: 20, thickness: 1),

                        // Dòng Tổng Thu
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tổng thu:', style: TextStyle(fontSize: 16)),
                            Text(
                              '+ ${_formatCurrency(tongThu)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Dòng Tổng Chi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tổng chi:', style: TextStyle(fontSize: 16)),
                            Text(
                              '- ${_formatCurrency(tongChi)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 20, thickness: 1),

                        // Dòng Tổng Kết Số Dư
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Số dư trong tháng:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatCurrency(soDu),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: soDu >= 0
                                    ? Colors.blue
                                    : Colors.red, // Lãi màu xanh, Lỗ màu đỏ
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
