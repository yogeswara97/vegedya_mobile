import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String image;
  final bool inActive;

  Category(
      {required this.id,
      required this.name,
      required this.image,
      required this.inActive,
  });

  factory Category.fromMap(Map<String, dynamic> data, String documentId,
      DocumentReference documentReference) {
    return Category(
      id: documentId,
      name: data['name'] ?? '',
      image: data['image'] ?? 'https://via.placeholder.com/150',
      inActive: data['inActive'] ?? false,
    );
  }
}
