import 'package:flutter/material.dart';
import 'package:makeyourlist/models/todo_item.dart';
import 'todo_list_screen.dart';

class AppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          _buildContent(),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
          ),
          Expanded(
            child: Center(
              child: Text(
                'App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'ทรุษจิรัต',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildCompletedItem(TodoItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2E7D3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // Completed date info
          if (item.startDate != null) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: Colors.white70),
                SizedBox(width: 8),
                Text(
                  'ระยะเวลา: ${item.formattedStartDate} - ${item.formattedEndDate}',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ],

          if (item.completedDate != null) ...[
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.done, size: 14, color: Colors.white70),
                SizedBox(width: 8),
                Text(
                  'เสร็จเมื่อ: ${item.completedDate!.day}/${item.completedDate!.month}/${item.completedDate!.year}',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xFF2E7D3A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.list_alt, color: Colors.white, size: 28),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.calendar_today, color: Colors.white, size: 28),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
}

Widget _buildContent() {
  // Replace with your actual content widget
  return Expanded(
    child: Center(
      child: Text(
        'Content goes here',
        style: TextStyle(fontSize: 18),
      ),
    ),
  );
}