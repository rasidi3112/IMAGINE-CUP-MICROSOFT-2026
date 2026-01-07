import 'package:flutter/material.dart';

/// Recurring schedule type
enum RecurrenceType { none, daily, weekly, biweekly, monthly }

/// Priority level for schedules
enum SchedulePriority { low, medium, high, urgent }

class TreatmentSchedule {
  final String id;
  final String scanResultId;
  final String treatmentName;
  final String treatmentType;
  final String description;
  final String dosage;
  final DateTime scheduledDate;
  final DateTime? completedDate;
  final bool isCompleted;
  final bool isNotificationEnabled;
  final String notes;
  final int reminderDaysBefore;

  // Advanced features
  final RecurrenceType recurrence;
  final SchedulePriority priority;
  final bool isWeatherSensitive; // Skip if rain/bad weather
  final String? linkedFarmId;
  final int reminderMinutesBefore; // Additional reminder in minutes
  final List<String> tags;

  TreatmentSchedule({
    required this.id,
    required this.scanResultId,
    required this.treatmentName,
    required this.treatmentType,
    required this.description,
    required this.dosage,
    required this.scheduledDate,
    this.completedDate,
    this.isCompleted = false,
    this.isNotificationEnabled = true,
    this.notes = '',
    this.reminderDaysBefore = 0,
    this.recurrence = RecurrenceType.none,
    this.priority = SchedulePriority.medium,
    this.isWeatherSensitive = false,
    this.linkedFarmId,
    this.reminderMinutesBefore = 30,
    this.tags = const [],
  });

  factory TreatmentSchedule.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value, bool defaultValue) {
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is int) return value == 1;
      return defaultValue;
    }

    return TreatmentSchedule(
      id: json['id'] ?? '',
      scanResultId: json['scan_result_id'] ?? '',
      treatmentName: json['treatment_name'] ?? '',
      treatmentType: json['treatment_type'] ?? '',
      description: json['description'] ?? '',
      dosage: json['dosage'] ?? '',
      scheduledDate: DateTime.parse(json['scheduled_date']),
      completedDate: json['completed_date'] != null
          ? DateTime.parse(json['completed_date'])
          : null,
      isCompleted: parseBool(json['is_completed'], false),
      isNotificationEnabled: parseBool(json['notification_enabled'], true),
      notes: json['notes'] ?? '',
      reminderDaysBefore: json['reminder_days_before'] ?? 0,
      recurrence: RecurrenceType.values[json['recurrence'] ?? 0],
      priority: SchedulePriority.values[json['priority'] ?? 1],
      isWeatherSensitive: parseBool(json['weather_sensitive'], false),
      linkedFarmId: json['linked_farm_id'],
      reminderMinutesBefore: json['reminder_minutes_before'] ?? 30,
      tags: json['tags'] != null
          ? List<String>.from(
              json['tags'].split(',').where((t) => t.isNotEmpty),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scan_result_id': scanResultId,
      'treatment_name': treatmentName,
      'treatment_type': treatmentType,
      'description': description,
      'dosage': dosage,
      'scheduled_date': scheduledDate.toIso8601String(),
      'completed_date': completedDate?.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
      'notification_enabled': isNotificationEnabled ? 1 : 0,
      'notes': notes,
      'reminder_days_before': reminderDaysBefore,
      'recurrence': recurrence.index,
      'priority': priority.index,
      'weather_sensitive': isWeatherSensitive ? 1 : 0,
      'linked_farm_id': linkedFarmId,
      'reminder_minutes_before': reminderMinutesBefore,
      'tags': tags.join(','),
    };
  }

  /// Get status text
  String get statusText {
    if (isCompleted) {
      return 'Selesai';
    } else if (scheduledDate.isBefore(DateTime.now())) {
      return 'Terlambat';
    } else if (scheduledDate.difference(DateTime.now()).inDays == 0) {
      return 'Hari Ini';
    } else if (scheduledDate.difference(DateTime.now()).inDays == 1) {
      return 'Besok';
    } else {
      return '${scheduledDate.difference(DateTime.now()).inDays} hari lagi';
    }
  }

  /// Get emoji for treatment type
  String get typeEmoji {
    switch (treatmentType.toLowerCase()) {
      case 'pesticide':
      case 'pestisida':
        return '🧪';
      case 'fungicide':
      case 'fungisida':
        return '🍄';
      case 'fertilizer':
      case 'pupuk':
        return '🌱';
      case 'organic':
      case 'organik':
        return '🌿';
      case 'watering':
      case 'penyiraman':
        return '💧';
      case 'pruning':
      case 'pemangkasan':
        return '✂️';
      case 'harvesting':
      case 'panen':
        return '🌾';
      default:
        return '📋';
    }
  }

  /// Get color for treatment type
  Color get typeColor {
    switch (treatmentType.toLowerCase()) {
      case 'pesticide':
      case 'pestisida':
        return const Color(0xFFE53935); // Red
      case 'fungicide':
      case 'fungisida':
        return const Color(0xFFFF9800); // Orange
      case 'fertilizer':
      case 'pupuk':
        return const Color(0xFF4CAF50); // Green
      case 'organic':
      case 'organik':
        return const Color(0xFF8BC34A); // Light Green
      case 'watering':
      case 'penyiraman':
        return const Color(0xFF2196F3); // Blue
      case 'pruning':
      case 'pemangkasan':
        return const Color(0xFF9C27B0); // Purple
      case 'harvesting':
      case 'panen':
        return const Color(0xFFFFEB3B); // Yellow
      default:
        return const Color(0xFF607D8B); // Grey
    }
  }

  /// Get priority color
  Color get priorityColor {
    switch (priority) {
      case SchedulePriority.low:
        return const Color(0xFF4CAF50);
      case SchedulePriority.medium:
        return const Color(0xFF2196F3);
      case SchedulePriority.high:
        return const Color(0xFFFF9800);
      case SchedulePriority.urgent:
        return const Color(0xFFE53935);
    }
  }

  /// Get priority text
  String get priorityText {
    switch (priority) {
      case SchedulePriority.low:
        return 'Rendah';
      case SchedulePriority.medium:
        return 'Sedang';
      case SchedulePriority.high:
        return 'Tinggi';
      case SchedulePriority.urgent:
        return 'Mendesak';
    }
  }

  /// Get priority icon
  IconData get priorityIcon {
    switch (priority) {
      case SchedulePriority.low:
        return Icons.keyboard_arrow_down;
      case SchedulePriority.medium:
        return Icons.remove;
      case SchedulePriority.high:
        return Icons.keyboard_arrow_up;
      case SchedulePriority.urgent:
        return Icons.priority_high;
    }
  }

  /// Get recurrence text
  String get recurrenceText {
    switch (recurrence) {
      case RecurrenceType.none:
        return 'Sekali';
      case RecurrenceType.daily:
        return 'Harian';
      case RecurrenceType.weekly:
        return 'Mingguan';
      case RecurrenceType.biweekly:
        return '2 Minggu';
      case RecurrenceType.monthly:
        return 'Bulanan';
    }
  }

  /// Get next occurrence date for recurring schedule
  DateTime? getNextOccurrence() {
    if (recurrence == RecurrenceType.none || !isCompleted) return null;

    switch (recurrence) {
      case RecurrenceType.daily:
        return scheduledDate.add(const Duration(days: 1));
      case RecurrenceType.weekly:
        return scheduledDate.add(const Duration(days: 7));
      case RecurrenceType.biweekly:
        return scheduledDate.add(const Duration(days: 14));
      case RecurrenceType.monthly:
        return DateTime(
          scheduledDate.year,
          scheduledDate.month + 1,
          scheduledDate.day,
        );
      default:
        return null;
    }
  }

  /// Check if schedule is overdue
  bool get isOverdue => !isCompleted && scheduledDate.isBefore(DateTime.now());

  /// Check if schedule is today
  bool get isToday {
    final now = DateTime.now();
    return scheduledDate.year == now.year &&
        scheduledDate.month == now.month &&
        scheduledDate.day == now.day;
  }

  /// Check if schedule is upcoming (within 3 days)
  bool get isUpcoming {
    final diff = scheduledDate.difference(DateTime.now());
    return !isCompleted && diff.inDays >= 0 && diff.inDays <= 3;
  }

  /// Get time until schedule
  String get timeUntil {
    if (isCompleted) return 'Selesai';

    final diff = scheduledDate.difference(DateTime.now());
    if (diff.isNegative) {
      if (diff.inDays.abs() > 0) {
        return '${diff.inDays.abs()} hari yang lalu';
      } else if (diff.inHours.abs() > 0) {
        return '${diff.inHours.abs()} jam yang lalu';
      } else {
        return '${diff.inMinutes.abs()} menit yang lalu';
      }
    } else {
      if (diff.inDays > 0) {
        return 'Dalam ${diff.inDays} hari';
      } else if (diff.inHours > 0) {
        return 'Dalam ${diff.inHours} jam';
      } else if (diff.inMinutes > 0) {
        return 'Dalam ${diff.inMinutes} menit';
      } else {
        return 'Sekarang!';
      }
    }
  }

  TreatmentSchedule copyWith({
    String? id,
    String? scanResultId,
    String? treatmentName,
    String? treatmentType,
    String? description,
    String? dosage,
    DateTime? scheduledDate,
    DateTime? completedDate,
    bool? isCompleted,
    bool? isNotificationEnabled,
    String? notes,
    int? reminderDaysBefore,
    RecurrenceType? recurrence,
    SchedulePriority? priority,
    bool? isWeatherSensitive,
    String? linkedFarmId,
    int? reminderMinutesBefore,
    List<String>? tags,
  }) {
    return TreatmentSchedule(
      id: id ?? this.id,
      scanResultId: scanResultId ?? this.scanResultId,
      treatmentName: treatmentName ?? this.treatmentName,
      treatmentType: treatmentType ?? this.treatmentType,
      description: description ?? this.description,
      dosage: dosage ?? this.dosage,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedDate: completedDate ?? this.completedDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
      notes: notes ?? this.notes,
      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
      recurrence: recurrence ?? this.recurrence,
      priority: priority ?? this.priority,
      isWeatherSensitive: isWeatherSensitive ?? this.isWeatherSensitive,
      linkedFarmId: linkedFarmId ?? this.linkedFarmId,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
      tags: tags ?? this.tags,
    );
  }
}
