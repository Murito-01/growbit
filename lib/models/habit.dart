class Habit {
  final String title;
  bool isDone;

  Habit({required this.title, this.isDone = false});

  // Convert object ke JSON (untuk disimpan)
  Map<String, dynamic> toJson() {
    return {'title': title, 'isDone': isDone};
  }

  // Convert JSON ke object (untuk load dari storage)
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      title: json['title'] as String,
      isDone: json['isDone'] as bool,
    );
  }
}
