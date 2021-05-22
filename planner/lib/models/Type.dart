class Type {
  int id;
  String name;

  Type({
    this.id, 
    this.name
  });

  Type.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJSON() => {
        'id': id,
        'name': name
      };
}
