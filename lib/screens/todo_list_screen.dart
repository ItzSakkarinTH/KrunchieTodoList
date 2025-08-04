import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import 'app_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoItem> todoItems = [];

  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [_buildHeader(), _buildTodoList()]),
      floatingActionButton: _buildAddButton(),
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
                  'SimpleToDoList',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTodoList() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('รายการ'),
            SizedBox(height: 16),

            // Todo items
            Expanded(
              child: ListView.builder(
                itemCount: todoItems.where((item) => !item.isCompleted).length,
                itemBuilder: (context, index) {
                  final item = todoItems
                      .where((item) => !item.isCompleted)
                      .toList()[index];
                  return _buildTodoItem(item);
                },
              ),
            ),

            SizedBox(height: 20),
            _buildSectionTitle('เสร็จแล้ว'),
            SizedBox(height: 16),

            // Completed items
            ...todoItems
                .where((item) => item.isCompleted)
                .map((item) => _buildCompletedItem(item))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildTodoItem(TodoItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Row(
        children: [
          Checkbox(
            value: item.isCompleted,
            onChanged: (value) {
              setState(() {
                item.isCompleted = value ?? false;
                if (item.isCompleted) {
                  item.completedDate = DateTime.now();
                }
              });
            },
            activeColor: Color(0xFF2E7D3A),
          ),
          Expanded(
            child: Text(
              item.title,
              style: TextStyle(
                fontSize: 16,
                decoration: item.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: item.isCompleted ? Colors.grey : Colors.black,
              ),
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
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              item.title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Text(
            '2024-05-30',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
      onPressed: _showAddTodoDialog,
      backgroundColor: Color(0xFF2E7D3A),
      child: Icon(Icons.add, color: Colors.white),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppScreen()),
              );
            },
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

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เพิ่มรายการใหม่'),
          content: TextField(
            controller: _todoController,
            decoration: InputDecoration(hintText: 'ใส่รายการที่ต้องทำ...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _todoController.clear();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                if (_todoController.text.isNotEmpty) {
                  setState(() {
                    todoItems.add(
                      TodoItem(title: _todoController.text, isCompleted: false),
                    );
                  });
                  _todoController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text('เพิ่ม'),
            ),
          ],
        );
      },
    );
  }
}
