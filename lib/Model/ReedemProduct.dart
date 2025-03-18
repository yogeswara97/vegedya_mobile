import 'package:cloud_firestore/cloud_firestore.dart';

class ReedemProduct {
  final String id;
  final DocumentReference productReference;
  final int pointsRequired;

  ReedemProduct({
    required this.id,
    required this.productReference,
    required this.pointsRequired,
  });

  factory ReedemProduct.fromMap(Map<String, dynamic> data, String documentId) {
    return ReedemProduct(
      id: documentId,
      productReference: data['productRef'] as DocumentReference,
      pointsRequired: data['pointsRequired'] ?? 0,
    );
  }
}
