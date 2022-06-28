class Filter {
  int id;
  String name;
  String icon;

  Filter({
     this.id,
     this.name,
     this.icon,
  });

  factory Filter.fromJson(Map<String, Object> data) {
    return Filter(
      id: data['id'] as int,
      name: data['name'] as String,
      icon: data['icon']as String,
    );
  }

  @override
  String toString() {
    return 'id: $id'
        'name: $name'
        'icon: $icon';
  }
}
