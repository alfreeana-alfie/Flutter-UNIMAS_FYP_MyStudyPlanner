class User {
  int id;
  String name;
  String email;
  String phone_no;
  String matric_no;
  String image;

  User(this.id, this.name, this.email, this.phone_no, this.matric_no,
      this.image);

  User.fromJSON(Map<String, dynamic> json)
      : id = json['user']['id'],
        name = json['user']['name'],
        email = json['user']['email'],
        phone_no = json['user']['phone_no'],
        matric_no = json['user']['matric_no'],
        image = json['user']['image'];

  Map<String, dynamic> toJSON() => {
        'id': id,
        'name': name,
        'email': email,
        'phone_no': phone_no,
        'matric_no': matric_no,
        'image': image
      };
}
