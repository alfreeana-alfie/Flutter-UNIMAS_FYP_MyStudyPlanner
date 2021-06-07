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
        other_address = json['address']['other_address'],
        postcode = json['address']['postcode'],
        city = json['address']['city'],
        state = json['address']['state'];

  Map<String, dynamic> toJSON() => {
        'id': id,
        'address': address,
        'other_address': other_address,
        'postcode': postcode,
        'city': city,
        'state': state
      };
}
