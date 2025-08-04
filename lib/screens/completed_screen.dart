import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import 'todo_list_screen.dart';
import 'app_screen.dart';

class CompletedScreen extends StatefulWidget {
  final List<TodoItem> completedItems;

  const CompletedScreen({Key? key, required this.completedItems}) : super(key: key);

  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildCompletedList(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
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
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'งานที่เสร็จแล้ว',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF2E7D3A),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '${widget.completedItems.length}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedList() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF2E7D3A), size: 20),
                SizedBox(width: 8),
                Text(
                  'รายการที่เสร็จสมบูรณ์',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Completed items list
            widget.completedItems.isEmpty
                ? _buildEmptyState()
                : Expanded(
                    child: ListView.builder(
                      itemCount: widget.completedItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.completedItems[index];
                        return _buildCompletedItem(item, index);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 80,
              color: Colors.grey[300],
            ),
            SizedBox(height: 16),
            Text(
              'ยังไม่มีงานที่เสร็จ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[500],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'เมื่อคุณทำงานเสร็จ จะแสดงที่นี่',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedItem(TodoItem item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFF2E7D3A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main content
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
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
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteConfirmation(item, index);
                        } else if (value == 'restore') {
                          _restoreItem(item, index);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'restore',
                          child: Row(
                            children: [
                              Icon(Icons.restore, size: 18),
                              SizedBox(width: 8),
                              Text('กลับไปยังรายการ'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('ลบถาวร', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Task duration info
                if (item.startDate != null) ...[
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 14, color: Colors.white70),
                            SizedBox(width: 8),
                            Text(
                              'เริ่ม: ${item.formattedStartDate} ${item.formattedStartTime}',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                        if (item.endDate != null) ...[
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.event, size: 14, color: Colors.white70),
                              SizedBox(width: 8),
                              Text(
                                'สิ้นสุด: ${item.formattedEndDate} ${item.formattedEndTime}',
                                style: TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],

                // Completion info
                if (item.completedDate != null) ...[
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.done_all, size: 16, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'เสร็จเมื่อ: ${item.completedDate!.day}/${item.completedDate!.month}/${item.completedDate!.year} ${item.completedDate!.hour.toString().padLeft(2, '0')}:${item.completedDate!.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(TodoItem item, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ลบรายการ'),
          content: Text('คุณต้องการลบ "${item.title}" ถาวรหรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.completedItems.removeAt(index);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบรายการเรียบร้อยแล้ว'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _restoreItem(TodoItem item, int index) {
    setState(() {
      item.isCompleted = false;
      item.completedDate = null;
      widget.completedItems.removeAt(index);
    });
    
    Navigator.pop(context, item); // ส่งกลับไปยังหน้าหลัก
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('กลับรายการไปยังรายการหลักแล้ว'),
        backgroundColor: Color(0xFF2E7D3A),
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
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TodoListScreen()),
              );
            },
            icon: Icon(Icons.list_alt, color: Colors.white70, size: 28),
          ),
          IconButton(
            onPressed: () {
              // Current screen - highlight it
            },
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.task_alt, color: Colors.white, size: 28),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AppScreen()),
              );
            },
            icon: Icon(Icons.person, color: Colors.white70, size: 28),
          ),
        ],
      ),
    );
  }
}