import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import 'app_screen.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    fontWeight: FontWeight.bold,
                    decoration: item.isCompleted 
                        ? TextDecoration.lineThrough 
                        : TextDecoration.none,
                    color: item.isCompleted 
                        ? Colors.grey 
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          
          // Date and Time info
          if (item.startDate != null || item.endDate != null) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  'เริ่ม: ${item.formattedStartDate} ${item.formattedStartTime}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            if (item.endDate != null) ...[
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.event, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    'สิ้นสุด: ${item.formattedEndDate} ${item.formattedEndTime}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ],
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
                  onPressed: () {
                    if (_todoController.text.isNotEmpty) {
                      setState(() {
                        todoItems.add(TodoItem(
                          title: _todoController.text,
                          isCompleted: false,
                          startDate: _selectedStartDate,
                          endDate: _selectedEndDate,
                          startTime: _selectedStartTime,
                          endTime: _selectedEndTime,
                        ));
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