import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final int point;
  final String image;
  final String description;
  final bool inStock;
  final bool inActive;
  final DocumentReference categoryReference;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.point,
    required this.image,
    required this.description,
    required this.inStock,
    required this.inActive,
    required this.categoryReference,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId, DocumentReference documentReference) {
    return Product(
      id: documentId,
      name: data['name'] ?? 'Unknown',
      price: (data['price'] as num).toDouble(),
      point: int.tryParse(data['point'].toString()) ?? 0,
      image: data['image'] ?? '"assets/images/no-image.jpg',
      description: data['description'] ?? 'No description available',
      inStock: data['inStock'],
      inActive: data['inActive'],
      categoryReference: data['category'] as DocumentReference,
    );
  }

  String get fullImagePath => "assets/images/products/" + image;
}
