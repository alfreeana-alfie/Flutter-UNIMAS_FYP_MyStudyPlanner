class Teacher {
  int id;
  String name;

  Teacher({this.id, this.name});

  Teacher.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJSON() => {
        'id': id,
        'name': name
      };
}
