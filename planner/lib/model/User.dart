class User {
  int id;
  String name;
  String email;
  String phone_no;
  String matric_no;
  String image;

  User(this.id, this.name, this.email, this.phone_no, this.matric_no, this.image);

  User.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        phone_no = json['phone_no'],
        matric_no = json['matric_no'],
        image = json['image'];

  Map<String, dynamic> toJSON() => {
        'id': id,
        'name': name,
        'email': email,
        'phone_no': phone_no,
        'matric_no': matric_no,
        'image': image
      };
}
