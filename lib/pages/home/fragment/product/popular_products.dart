import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegedya_firebase/Model/Product.dart';
import 'package:vegedya_firebase/pages/home/fragment/product/product_detail.dart';
import 'package:vegedya_firebase/widgets/loading_widgets.dart';
import 'package:vegedya_firebase/widgets/product_card.dart';
import 'package:vegedya_firebase/widgets/refresh_indicator_widget.dart';
import 'package:vegedya_firebase/widgets/shimmer_product_card_list_widget.dart';

class PopularProducts extends StatelessWidget {
  final FirebaseFirestore db;
  const PopularProducts({
    super.key,
    required this.db,
  });

  Future<Map<String, int>> _fetchPopularProducts() async {
    Map<String, int> productOrderCount = {};

    QuerySnapshot orderSnapshot = await db.collection('orders').where('status', isEqualTo: "success").get();

    for (var orderDoc in orderSnapshot.docs) {
      QuerySnapshot itemsSnapshot =
          await orderDoc.reference.collection('items').get();
      for (var itemDoc in itemsSnapshot.docs) {
        String productId = itemDoc['productId'];
        int qty = itemDoc['quantity'];
        if (productOrderCount.containsKey(productId)) {
          productOrderCount[productId] = productOrderCount[productId]! + qty;
        } else {
          productOrderCount[productId] = qty;
        }
      }
    }

    return productOrderCount;
  }

  Future<List<Product>> _fetchPopularProductDetails(
      Map<String, int> productOrderCount) async {
    List<Product> products = [];

    for (var entry in productOrderCount.entries) {
      DocumentSnapshot productSnapshot =
          await db.collection('products').doc(entry.key).get();
      if (productSnapshot.exists) {
        Product product = Product.fromMap(
            productSnapshot.data() as Map<String, dynamic>,
            productSnapshot.id,
            productSnapshot.reference);
        
        if (product.inActive == true && product.inStock == true) {
          products.add(product);
        }
      }
    }

    products.sort(
        (a, b) => productOrderCount[b.id]!.compareTo(productOrderCount[a.id]!));
    return products.take(4).toList(); // Ambil hanya 4 produk teratas
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
          child: Text(
            "Recomended Products",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        FutureBuilder<Map<String, int>>(
          future: _fetchPopularProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimmerProductCardListWidget(
                itemCount: 4,
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                child: Text("No popular products found"),
              );
            }

            return FutureBuilder<List<Product>>(
              future: _fetchPopularProductDetails(snapshot.data!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ShimmerProductCardListWidget(
                    itemCount: 4,
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("No popular products found"),
                  );
                }

                var _data = snapshot.data!;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      var item = _data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 8.0),
                        child: ProductCard(
                          item: item,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductPage(
                                  db: db,
                                  product_id: item.id,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );

                // return GridView.builder(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     crossAxisSpacing: 15,
                //     mainAxisSpacing: 15,
                //     childAspectRatio: 0.75,
                //   ),
                //   itemCount: _data.length,
                //   itemBuilder: (context, index) {
                //     var item = _data[index];

                //     return ProductCard(
                //       item: item,
                //       onTap: () {
                //         if (item.inStock) {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => ProductPage(
                //                 db: widget.db,
                //                 product_id: item.id,
                //               ),
                //             ),
                //           );
                //         }
                //       },
                //     );
                //   },
                // );
              },
            );
          },
        ),
      ],
    );
  }
}
