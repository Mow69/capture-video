class Category {
  int id;
  String name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromJson(Map<String, Object> data) {
    return Category(
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
