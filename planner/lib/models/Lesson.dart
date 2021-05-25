class Lesson {
  int id;
  String name;
  String abbr;
  String color;
  String type;
  String teacher;
  String place;
  String day;
  String startTime;
  String endTime;

  Lesson(
      {this.id,
      this.name,
      this.abbr,
      this.color,
      this.type,
      this.teacher,
      this.place,
      this.day,
      this.startTime,
      this.endTime});

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] as int,
      name: map['name'] as String,
      abbr: map['abbr'] as String,
      color: map['color'] as String,
      type: map['type'] as String,
      teacher: map['teacher'] as String,
      place: map['place'] as String,
      day: map['day'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
    );
  }

  Lesson.fromJSON(Map<String, dynamic> json)
      : id = json['lesson']['id'],
        name = json['lesson']['name'],
        abbr = json['lesson']['abbr'],
        color = json['lesson']['color'],
        type = json['lesson']['type'],
        teacher = json['lesson']['teacher'],
        place = json['lesson']['place'],
        day = json['lesson']['day'],
        startTime = json['lesson']['startTime'],
        endTime = json['lesson']['endTime'];
}
