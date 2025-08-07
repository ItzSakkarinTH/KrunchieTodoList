import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo_item.dart';
import 'profile_screen.dart';
import 'completed_screen.dart';
import 'package:intl/intl.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoItem> todoItems = [];

  final TextEditingController _todoController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  // โหลดข้อมูล todo จาก SharedPreferences
  Future<void> _loadTodoItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? todoString = prefs.getString('todo_items');
      
      if (todoString != null) {
        final List<dynamic> jsonList = jsonDecode(todoString);
        setState(() {
          todoItems = jsonList.map((json) => TodoItem.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print('Error loading todo items: $e');
    }
  }

  // บันทึกข้อมูล todo ลง SharedPreferences
  Future<void> _saveTodoItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonString = jsonEncode(
        todoItems.map((item) => item.toJson()).toList()
      );
      await prefs.setString('todo_items', jsonString);
    } catch (e) {
      print('Error saving todo items: $e');
    }
  }

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
    final completedCount = todoItems.where((item) => item.isCompleted).length;
    final totalCount = todoItems.length;

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
          // Progress indicator
          if (totalCount > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF2E7D3A),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '$completedCount/$totalCount',
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

  Widget _buildTodoList() {
    final uncompletedItems = todoItems
        .where((item) => !item.isCompleted)
        .toList();
    final completedCount = todoItems.where((item) => item.isCompleted).length;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'รายการ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                // Link to completed screen
                if (completedCount > 0)
                  GestureDetector(
                    onTap: () => _goToCompletedScreen(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF2E7D3A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color(0xFF2E7D3A).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 16,
                            color: Color(0xFF2E7D3A),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'เสร็จแล้ว ($completedCount)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2E7D3A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Color(0xFF2E7D3A),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),

            // Todo items
            uncompletedItems.isEmpty
                ? _buildEmptyState()
                : Expanded(
                    child: ListView.builder(
                      itemCount: uncompletedItems.length,
                      itemBuilder: (context, index) {
                        final item = uncompletedItems[index];
                        return _buildTodoItem(item);
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
            Icon(Icons.assignment_turned_in, size: 80, color: Colors.grey[300]),
            SizedBox(height: 16),
            Text(
              'ไม่มีรายการที่ต้องทำ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[500],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'กดปุ่ม + เพื่อเพิ่มรายการใหม่',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: item.isCompleted,
                onChanged: (value) async {
                  setState(() {
                    item.isCompleted = value ?? false;
                    if (item.isCompleted) {
                      item.completedDate = DateTime.now();
                      // Show completion animation/feedback
                      _showCompletionFeedback(item.title);
                    }
                  });
                  await _saveTodoItems(); // บันทึกทันทีเมื่อมีการเปลี่ยนแปลง
                },
                activeColor: Color(0xFF2E7D3A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: item.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: item.isCompleted ? Colors.grey : Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              // Menu for each item
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditTodoDialog(item);
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(item);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('แก้ไข'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('ลบ', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Date and Time info
          if (item.startDate != null || item.endDate != null) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'เริ่ม: ${item.formattedStartDate} ${item.formattedStartTime}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (item.endDate != null) ...[
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.event, size: 16, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'สิ้นสุด: ${item.formattedEndDate} ${item.formattedEndTime}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showCompletionFeedback(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'เสร็จสิ้น: $title',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF2E7D3A),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  void _goToCompletedScreen() async {
    final completedItems = todoItems.where((item) => item.isCompleted).toList();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompletedScreen(completedItems: completedItems),
      ),
    );

    // If an item was restored, add it back to the main list
    if (result != null && result is TodoItem) {
      setState(() {
        todoItems.add(result);
      });
      await _saveTodoItems(); // บันทึกการเปลี่ยนแปลง
    }
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
          // Current screen - highlight it
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.list_alt, color: Colors.white, size: 28),
            ),
          ),
          IconButton(
            onPressed: () => _goToCompletedScreen(),
            icon: Icon(Icons.task_alt, color: Colors.white70, size: 28),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(
                  username: 'User123',
                  todoItems: todoItems,
                )),
              );
            },
            icon: Icon(Icons.person, color: Colors.white70, size: 28),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(TodoItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ลบรายการ'),
          content: Text('คุณต้องการลบ "${item.title}" หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  todoItems.remove(item);
                });
                await _saveTodoItems(); // บันทึกการเปลี่ยนแปลง
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบรายการเรียบร้อยแล้ว'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height - 150,
                      left: 16,
                      right: 16,
                    ),
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

  void _showEditTodoDialog(TodoItem item) {
    // Set current values
    _todoController.text = item.title;
    _selectedStartDate = item.startDate;
    _selectedEndDate = item.endDate;
    _selectedStartTime = item.startTime;
    _selectedEndTime = item.endTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('แก้ไขรายการ'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title input
                    TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        hintText: 'ใส่รายการที่ต้องทำ...',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Start Date
                    _buildDateTimePicker(
                      label: 'วันที่เริ่มต้น',
                      date: _selectedStartDate,
                      time: _selectedStartTime,
                      onDateTap: () => _selectStartDate(setDialogState),
                      onTimeTap: () => _selectStartTime(setDialogState),
                    ),

                    SizedBox(height: 12),

                    // End Date
                    _buildDateTimePicker(
                      label: 'วันที่สิ้นสุด',
                      date: _selectedEndDate,
                      time: _selectedEndTime,
                      onDateTap: () => _selectEndDate(setDialogState),
                      onTimeTap: () => _selectEndTime(setDialogState),
                    ),
                  ],
                ),
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
                  onPressed: () async {
                    if (_todoController.text.isNotEmpty) {
                      setState(() {
                        item.title = _todoController.text;
                        item.startDate = _selectedStartDate;
                        item.endDate = _selectedEndDate;
                        item.startTime = _selectedStartTime;
                        item.endTime = _selectedEndTime;
                      });
                      await _saveTodoItems(); // บันทึกการเปลี่ยนแปลง
                      _todoController.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('แก้ไขรายการเรียบร้อยแล้ว'),
                          backgroundColor: Color(0xFF2E7D3A),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height - 150,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('บันทึก'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddTodoDialog() {
    // Reset values
    _selectedStartDate = null;
    _selectedEndDate = null;
    _selectedStartTime = null;
    _selectedEndTime = null;
    _todoController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('เพิ่มรายการใหม่'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title input
                    TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        hintText: 'ใส่รายการที่ต้องทำ...',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Start Date
                    _buildDateTimePicker(
                      label: 'วันที่เริ่มต้น',
                      date: _selectedStartDate,
                      time: _selectedStartTime,
                      onDateTap: () => _selectStartDate(setDialogState),
                      onTimeTap: () => _selectStartTime(setDialogState),
                    ),

                    SizedBox(height: 12),

                    // End Date
                    _buildDateTimePicker(
                      label: 'วันที่สิ้นสุด',
                      date: _selectedEndDate,
                      time: _selectedEndTime,
                      onDateTap: () => _selectEndDate(setDialogState),
                      onTimeTap: () => _selectEndTime(setDialogState),
                    ),
                  ],
                ),
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
                  onPressed: () async {
                    if (_todoController.text.isNotEmpty) {
                      setState(() {
                        todoItems.add(
                          TodoItem(
                            title: _todoController.text,
                            isCompleted: false,
                            startDate: _selectedStartDate,
                            endDate: _selectedEndDate,
                            startTime: _selectedStartTime,
                            endTime: _selectedEndTime,
                          ),
                        );
                      });
                      await _saveTodoItems(); // บันทึกการเปลี่ยนแปลง
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
      },
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required DateTime? date,
    required TimeOfDay? time,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onDateTap,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16),
                      SizedBox(width: 8),
                      Text(
                        date != null
                            ? '${date.day}/${date.month}/${date.year}'
                            : 'เลือกวันที่',
                        style: TextStyle(
                          color: date != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: onTimeTap,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, size: 16),
                      SizedBox(width: 8),
                      Text(
                        time != null
                            ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                            : 'เลือกเวลา',
                        style: TextStyle(
                          color: time != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectStartDate(StateSetter setDialogState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setDialogState(() {
        _selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(StateSetter setDialogState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? _selectedStartDate ?? DateTime.now(),
      firstDate: _selectedStartDate ?? DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setDialogState(() {
        _selectedEndDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(StateSetter setDialogState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setDialogState(() {
        _selectedStartTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(StateSetter setDialogState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime ?? _selectedStartTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setDialogState(() {
        _selectedEndTime = picked;
      });
    }
  }
}
