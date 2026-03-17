// Đường dẫn: lib/screens/infor_screen.dart

import 'package:flutter/material.dart';

class InforScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('Thông tin nhóm', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.orange[50],
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ), // Mũi tên quay lại màu đen
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              SizedBox(height: 20),

              // Tên môn học và Tên đề tài
              Text(
                'Lập trình cho thiết bị di động',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 8),
              Text(
                'Bài tập lớn: Quản lý Tài chính',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              // Thẻ thông tin thành viên nhóm
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'NHÓM 28',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Divider(height: 30, thickness: 1),

                      // Thông tin của bạn
                      ListTile(
                        title: Text(
                          'Bùi Anh Tuấn',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text('Mã Sinh Viên: 23010590'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
