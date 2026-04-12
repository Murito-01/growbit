class Habit {
  final String title;
  bool isDone;
  DateTime? lastCompletedDate;

  Habit({required this.title, this.isDone = false, this.lastCompletedDate});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isDone': isDone,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      title: json['title'],
      isDone: json['isDone'],
      lastCompletedDate: json['lastCompletedDate'] != null
          ? DateTime.parse(json['lastCompletedDate'])
          : null,
    );
  }
}
