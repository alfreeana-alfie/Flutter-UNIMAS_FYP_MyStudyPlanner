class News {
  int id;
  String title;
  String description;
  String postedBy;
  int type;
  String createdAt;
  String updatedAt;

  News(
      {this.id,
      this.title,
      this.description,
      this.postedBy,
      this.type,
      this.createdAt,
      this.updatedAt});

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      postedBy: map['posted_by'] as String,
      type: map['type'] as int,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String
    );
  }

  News.fromJSON(Map<String, dynamic> json)
      : id = json['news']['id'],
        title = json['news']['title'],
        description = json['news']['description'],
        postedBy = json['news']['posted_by'],
        type = json['news']['type'],
        createdAt = json['news']['created_at'],
        updatedAt = json['news']['updated_at'];
}
