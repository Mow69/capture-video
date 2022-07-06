class VideoExt {
  int id;
  String name;

  VideoExt({
    this.id,
    this.name,
  });

  factory VideoExt.fromJson(Map<String, Object> data) {
    return VideoExt(
      id: data['id'],
      name: data['name'] as String,
    );
  }

  @override
  String toString() {
    return 'id: $id'
        'name: $name';
  }
}
