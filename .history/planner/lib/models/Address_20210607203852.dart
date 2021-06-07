class Address {
  int id;
  int user_id;
  String address;
  String other_address;
  String postcode;
  String city;
  String state;
  String country;

  Address(
    this.id, 
    this.user_id, 
    this.address, 
    this.phone_no, 
    this.matric_no,
    this.image
  );

  Address.fromJSON(Map<String, dynamic> json)
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
