class Timetable {
  int id;
  String name;

  Timetable({this.id, this.name});

  Timetable.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJSON() => {
        'id': id,
        'name': name
      };
}
