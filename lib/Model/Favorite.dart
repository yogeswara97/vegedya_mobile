import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final String favoriteId;
  final String productId;
  final String productName;
  final double productPrice;
  final String productImage;
  final Timestamp timestamp;
  final DocumentReference documentReference;

  Favorite({
    required this.favoriteId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.timestamp,
    required this.documentReference,
  });

  factory Favorite.fromMap(Map<String, dynamic> data, String documentId, DocumentReference documentReference) {
    return Favorite(
      favoriteId: documentId,
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      productPrice: (data['productPrice'] as num?)?.toDouble() ?? 0.0,
      productImage: data['productImage'] ?? 'assets/images/no-image.jpg',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      documentReference: documentReference,
    );
  }

  String get fullImagePath => "assets/images/products/" + productImage;
}
