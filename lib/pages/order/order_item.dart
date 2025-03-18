import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vegedya_firebase/Model/Order.dart';
import 'package:vegedya_firebase/widgets/calculate_total_widget.dart';
import 'package:vegedya_firebase/widgets/loading_widgets.dart';
import 'package:vegedya_firebase/widgets/silver_gap_widget.dart';

class OrderItemPage extends StatelessWidget {
  final String orderId;
  final String orderStatus;
  final FirebaseFirestore db;
  

  const OrderItemPage(
      {super.key,
      required this.orderId,
      required this.db,
      required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () {
          //     Navigator.pop(context); // Kembali ke halaman sebelumnya
          //   },
          // ),
          ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('orders')
            .doc(orderId)
            .collection('items')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MainLoading();
          }
          if (snapshot.hasError) {
            return Center(child: Text("ERROR: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No order items found"));
          }

          var orderItems = snapshot.data!.docs
              .map((doc) =>
                  OrderItem.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();

          Color orderStatusColor;
          if (orderStatus == 'Success') {
            orderStatusColor = Colors.green;
          } else if (orderStatus == 'Waiting') {
            orderStatusColor = Colors.blue;
          } else {
            orderStatusColor = Colors.red;
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          '${orderStatus}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: orderStatusColor),
                        ),
                        Divider(color: Colors.grey[300]),
                        Text(
                          "${orderId}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SilverGapWidget(),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Your Orders",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = orderItems[index];
                    return Container(
                        child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item.productImage,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[
                                              300], // Shimmer placeholder color
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors
                                            .red, // Gambar fallback jika ada error
                                        child: Icon(Icons.error,
                                            color: Colors.white),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Divider(color: Colors.grey[300]),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "\$${(item.quantity * item.price).toStringAsFixed(2)}",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    200, 146, 116, 87),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  "${item.quantity}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ));
                  },
                  childCount: orderItems.length,
                ),
              ),
              SilverGapWidget(),
              SliverToBoxAdapter(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: db.collection('orders').doc(orderId).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("ERROR: ${snapshot.error}"));
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: Text("Order not found"));
                    }

                    var orderData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    var order =
                        OrderModel.fromMap(orderData, snapshot.data!.id);

                    return calculateTotalWidget(
                        subTotalPrice: order.subTotalPrice,
                        tax: order.tax,
                        grandTotal: order.totalPrice);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
