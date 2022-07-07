class Filter {
  int id;
  int category_id;
  int video_ext_id;
  String name;
  String description;
  String image;
  int price;
  String path;
  bool is_downloaded;
  String category_name;
  String video_ext_name;

  Filter({
    this.id,
    this.category_id,
    this.video_ext_id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.path,
    this.category_name,
    this.video_ext_name,
  });

  factory Filter.fromJson(Map<String, Object> data) {
    return Filter(
      id: data['id'],
      category_id: data["category_id"],
      video_ext_id: data["video_ext_id"],
      name: data['name'] as String,
      description: data['description'] as String,
      image: data['image'] as String,
      price: data['price'],
      path: data['path'] as String,
      category_name: data['category_name'],
      video_ext_name: data['video_ext_name'],
    );
  }

  @override
  String toString() {
    return 'id: $id'
        'category_id: $category_id'
        'video_ext_id: $video_ext_id'
        'name: $name'
        'description: $description'
        'image: $image'
        'price: $price'
        'path: $path'
        'category_name: $category_name'
        'video_ext_name: $video_ext_name';
  }
}
