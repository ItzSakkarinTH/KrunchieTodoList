import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoItem {
  String title;
  bool isCompleted;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? completedDate;

  TodoItem({
    required this.title,
    required this.isCompleted,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.completedDate,
  });

  String get formattedStartDate => startDate != null
      ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
      : '';

  String get formattedEndDate => endDate != null
      ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
      : '';

  String get formattedStartTime => startTime != null
      ? '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}'
      : '';

  String get formattedEndTime => endTime != null
      ? '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}'
      : '';
}
