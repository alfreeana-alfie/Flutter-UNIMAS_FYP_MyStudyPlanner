class Announcement {
  int id;
  String title;
  String description;
  String posted_by;
  String type;
  String created_at;
  String updated_at;

  Announcement(
      {this.id,
      this.title,
      this.description,
      this.posted_by,
      this.type,
      this.created_at,
      this.updated_at});

  Announcement.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        posted_by = json['posted_by'],
        type = json['type'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];

  Map<String, dynamic> toJSON() => {
        'id': id,
        'title': title,
        'description': description,
        'posted_by': posted_by,
        'type': type,
        'created_at': created_at,
        'updated_at': updated_at
      };
}
