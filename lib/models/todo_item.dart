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
    this.isCompleted = false,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.completedDate,
  });

  // Convert TodoItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'startTimeHour': startTime?.hour,
      'startTimeMinute': startTime?.minute,
      'endTimeHour': endTime?.hour,
      'endTimeMinute': endTime?.minute,
      'completedDate': completedDate?.millisecondsSinceEpoch,
    };
  }

  // Create TodoItem from JSON
  static TodoItem fromJson(Map<String, dynamic> json) {
    return TodoItem(
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      startDate: json['startDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['startDate']) 
          : null,
      endDate: json['endDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['endDate']) 
          : null,
      startTime: json['startTimeHour'] != null && json['startTimeMinute'] != null
          ? TimeOfDay(hour: json['startTimeHour'], minute: json['startTimeMinute'])
          : null,
      endTime: json['endTimeHour'] != null && json['endTimeMinute'] != null
          ? TimeOfDay(hour: json['endTimeHour'], minute: json['endTimeMinute'])
          : null,
      completedDate: json['completedDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['completedDate']) 
          : null,
    );
  }

  String get formattedStartDate {
    if (startDate == null) return '';
    return DateFormat('dd/MM/yyyy').format(startDate!);
  }

  String get formattedEndDate {
    if (endDate == null) return '';
    return DateFormat('dd/MM/yyyy').format(endDate!);
  }

  String get formattedStartTime {
    if (startTime == null) return '';
    return '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}';
  }

  String get formattedEndTime {
    if (endTime == null) return '';
    return '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';
  }

  String get formattedCompletedDate {
    if (completedDate == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm').format(completedDate!);
  }
}