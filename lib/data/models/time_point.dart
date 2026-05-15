import 'dart:convert';

class TimePoint {
  final String id;
  final String time; // "09:00"
  final String label;

  const TimePoint({
    required this.id,
    required this.time,
    this.label = '',
  });

  TimePoint copyWith({String? id, String? time, String? label}) {
    return TimePoint(
      id: id ?? this.id,
      time: time ?? this.time,
      label: label ?? this.label,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'time': time,
        'label': label,
      };

  factory TimePoint.fromJson(Map<String, dynamic> json) => TimePoint(
        id: json['id'] as String,
        time: json['time'] as String,
        label: json['label'] as String? ?? '',
      );

  static List<TimePoint> fromJsonList(String jsonStr) {
    if (jsonStr.isEmpty) return [];
    final list = jsonDecode(jsonStr) as List;
    return list.map((e) => TimePoint.fromJson(e)).toList();
  }

  static String toJsonList(List<TimePoint> points) {
    return jsonEncode(points.map((e) => e.toJson()).toList());
  }

  static const defaultTimePoints = [
    TimePoint(id: 'tp_morning', time: '09:00', label: 'Morning'),
    TimePoint(id: 'tp_noon', time: '12:00', label: 'Noon'),
    TimePoint(id: 'tp_evening', time: '17:00', label: 'Evening'),
  ];
}
