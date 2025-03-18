import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  int quantity;
  final int point;
  final DocumentReference documentReference;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    required this.point,
    required this.documentReference,
  });

  factory CartItem.fromMap(Map<String, dynamic> data, String documentId, DocumentReference documentReference) {
    return CartItem(
      id: documentId,
      name: data['name'] ??'',
      price: data['price'] ?? 0.00,
      image: data['image'] ?? 'no-image.jpg',
      quantity: data['quantity'],
      point: int.tryParse(data['point'].toString()) ?? 0,
      documentReference: documentReference,
    );
  }

  String get fullImagePath => "assets/images/products/" + image;

}
