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
    this.other_address, 
    this.postcode,
    this.city,
    this.state,
    this.country
  );

  Address.fromJSON(Map<String, dynamic> json)
      : id = json['address']['id'],
        address = json['address']['address'],
        email = json['address']['email'],
        phone_no = json['address']['phone_no'],
        matric_no = json['address']['matric_no'],
        image = json['address']['image'];

  Map<String, dynamic> toJSON() => {
        'id': id,
        'address': address,
        'email': email,
        'phone_no': phone_no,
        'matric_no': matric_no,
        'image': image
      };
}
