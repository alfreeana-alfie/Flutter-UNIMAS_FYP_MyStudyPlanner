class Lesson {
  int id;
  String user_id;
  String name;
  String abbr;
  String color;
  String type;
  String teacher;
  String place;
  String day;
  String startTime;
  String endTime;

  Lesson({
    this.id,
    this.user_id,
    this.name,
    this.abbr,
    this.color,
    this.type,
    this.teacher,
    this.place,
    this.day,
    this.startTime,
    this.endTime
  });

  Lesson.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        abbr = json['abbr'],
        color = json['color'],
        type = json['type'],
        teacher = json['teacher'],
        place = json['place'],
        day = json['day'],
        startTime = json['startTime'],
        endTime = json['endTime'];

  Map<String, dynamic> toJSON() => {
        'id': id,
        'name': name,
        'abbr': abbr,
        'color': color,
        'type': type,
        'teacher': teacher,
        'place': place,
        'day':day,
        'startTime': startTime,
        'endTime': endTime
      };
}
