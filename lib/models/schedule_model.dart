class ScheduleTask {
  final String subject;
  final double hours;
  final String? day;

  ScheduleTask({
    required this.subject,
    required this.hours,
    this.day,
  });

  factory ScheduleTask.fromJson(Map<String, dynamic> json) {
    return ScheduleTask(
      subject: json['subject'] as String,
      hours: (json['hours'] as num).toDouble(),
      day: json['day'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'hours': hours,
      if (day != null) 'day': day,
    };
  }
}
