import 'package:cloud_firestore/cloud_firestore.dart';

String capitalize(String s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

class OrderModel {
  final String id;
  final DateTime orderDate;
  final double subTotalPrice;
  final double tax;
  final double totalPrice;
  final String status;

  OrderModel(
      {required this.id,
      required this.orderDate,
      required this.subTotalPrice,
      required this.tax,
      required this.totalPrice,
      required this.status,
  });



  factory OrderModel.fromMap(Map<String, dynamic> data, String documentId,) {
    return OrderModel(
      id: documentId,
      orderDate: (data['orderDate'] as Timestamp).toDate(), // Ubah ke DateTime
      subTotalPrice: (data['subTotalPrice'] as num).toDouble(),
      tax: (data['tax'] as num).toDouble(),
      totalPrice: (data['totalPrice'] as num).toDouble(),
      status: capitalize(data['status']) ,
    );
  }
}

class OrderItem {
  final String itemId;
  final String productId;
  final String productName;
  final double price;
  final double totalPrice;
  final int quantity;
  final String productImage;

  OrderItem({
    required this.itemId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.totalPrice,
    required this.quantity,
    required this.productImage,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data, String documentId) {
    return OrderItem(
      itemId: documentId,
      productId: data['productId'] ?? '',
      productName: data['name'] ?? '',
      price: (data['price'] as num).toDouble(),
      totalPrice: (data['totalPrice'] as num).toDouble(),
      quantity: data['quantity'] ?? 0,
      productImage: data['image'] ?? 'no-image.jpg',
    );
  }

  String get fullImagePath => "assets/images/products/" + productImage;
}

