import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String id;
  final String title;
  final String image;
  final DateTime createdAt;
  final String description;
  final bool inActive;

  BannerModel(
      {required this.id,
      required this.title,
      required this.image,
      required this.description,
      required this.createdAt,
      required this.inActive,
  });

  factory BannerModel.fromMap(Map<String, dynamic> data, String documentId,) {
    return BannerModel(
      id: documentId,
      title: data['title'] ?? '',
      image: data['image'] ?? 'https://via.placeholder.com/150',
      description: data['description'] ?? '',
      createdAt:  (data['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      inActive: data['inActive'] ?? false,
    );
  }
}