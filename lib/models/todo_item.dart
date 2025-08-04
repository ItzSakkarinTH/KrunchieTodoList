class TodoItem {
  String title;
  bool isCompleted;
  DateTime? completedDate;

  TodoItem({
    required this.title, 
    required this.isCompleted,
    this.completedDate,
  });
}