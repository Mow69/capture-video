import 'package:vjing_app/filters/category.dart';
import 'package:vjing_app/filters/videoExt.dart';

class Filter {
  int id;
  String name;
  String description;
  String path;
  String image;
  int price;
  Category category;
  VideoExt video_ext;

  Filter({
    this.id,
    this.name,
    this.description,
    this.path,
    this.image,
    this.price,
    this.category,
    this.video_ext,
  });

  factory Filter.fromJson(Map<String, Object> data) {
    return Filter(
      id: data['id'],
      name: data['name'] as String,
      description: data['description'] as String,
      path: data['path'] as String,
      image: data['image'] as String,
      price: data['price'],
      category: Category.fromJson(data['category']),
      video_ext: VideoExt.fromJson(data['video_ext']),
    );
  }

  @override
  String toString() {
    return 'id: $id'
        'name: $name'
        'description: $description'
        'path: $path'
        'image: $image'
        'price: $price'
        'type: $category'
        'video_ext: $video_ext';
  }
}
