import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegedya_firebase/Model/Order.dart';
import 'package:vegedya_firebase/pages/auth/login_page.dart';
import 'package:vegedya_firebase/pages/navigation/bottom_navigation.dart';
import 'package:vegedya_firebase/pages/order/order_item.dart';
import 'package:vegedya_firebase/utils/swipe_navigation.dart';
import 'package:vegedya_firebase/widgets/loading_widgets.dart';
import 'package:vegedya_firebase/widgets/no_items_widget.dart';
import 'package:vegedya_firebase/widgets/refresh_indicator_widget.dart';

class OrderFragment extends StatefulWidget {
  final String? customerId;
  final FirebaseFirestore db;
  const OrderFragment({super.key, this.customerId, required this.db});

  @override
  State<OrderFragment> createState() => _OrderFragmentState();
}

class _OrderFragmentState extends State<OrderFragment> {
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customerId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      });
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Orders",
        ),
      ),
      body: RefreshIndicatorWidget(
        onRefresh: _refreshData,
        child: StreamBuilder(
          stream: widget.db
              .collection('orders')
              .where('customerId', isEqualTo: widget.customerId)
              .orderBy('orderDate', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return MainLoading();
            }
            if (snapshots.hasError) {
              return Center(child: Text("ERROR: ${snapshots.error}"));
            }

            if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
              return NoItemsWidget(text: "No Orders Found");
            }

            var _data = snapshots.data!.docs
                .map((doc) => OrderModel.fromMap(
                    doc.data() as Map<String, dynamic>, doc.id))
                .toList();

            return ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                var order = _data[index];

                Color orderStatusColor;
                if (order.status == 'Success') {
                  orderStatusColor = Colors.green;
                } else if (order.status == 'Waiting') {
                  orderStatusColor = Colors.blue;
                } else {
                  orderStatusColor = Colors.red;
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      print(order.id);

                      swipeNavigation(
                        context,
                        OrderItemPage(
                          db: widget.db,
                          orderId: order.id,
                          orderStatus: order.status,
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shadowColor: Colors.grey.shade300,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${order.status}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: orderStatusColor,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "${order.orderDate}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "See Details",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 111, 78, 55),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Color.fromARGB(255, 111, 78, 55),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total: \$${order.totalPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                order.status == 'Waiting'
                                    ? Container()
                                    : ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BottomNavigationPage(
                                                initialIndex: 0,
                                                customerId: widget.customerId!,
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(255, 111, 78, 55),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          "Order Again",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
