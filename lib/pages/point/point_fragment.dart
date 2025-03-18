import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vegedya_firebase/Model/Product.dart';
import 'package:vegedya_firebase/pages/home/fragment/product/product_detail.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vegedya_firebase/services/session.dart';
import 'package:vegedya_firebase/widgets/no_items_widget.dart';
import 'package:vegedya_firebase/widgets/refresh_indicator_widget.dart';
import 'package:vegedya_firebase/widgets/product_card.dart';
import 'package:vegedya_firebase/widgets/shimmer_product_card_list_widget.dart'; // Import ProductCard

class PointFragment extends StatefulWidget {
  final FirebaseFirestore db;

  const PointFragment({
    Key? key,
    required this.db,
  }) : super(key: key);

  @override
  _PointFragmentState createState() => _PointFragmentState();
}

class _PointFragmentState extends State<PointFragment> {
  String? customerId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomerId();
  }

  Future<void> _loadCustomerId() async {
    Session session = Session();
    customerId = await session.getCustomerId();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.brown,
            size: 80,
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        // Kembalikan false untuk mencegah animasi turun
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 5),
          height: double.infinity,
          color: Colors.white,
          child: RefreshIndicatorWidget(
            onRefresh: _refreshData,
            child: StreamBuilder(
              stream: widget.db.collection('redeemProducts').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return ShimmerProductCardListWidget(
                    itemCount: 10,
                  );
                } else if (snapshots.hasError) {
                  return const Center(
                    child: Text("ERROR"),
                  );
                } else if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
                  return Center(
                    child: NoItemsWidget(text: "No Products Found"),
                  );
                }

                var _data = snapshots.data!.docs;

                return GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    var redeemProduct =
                        _data[index].data() as Map<String, dynamic>;
                    var productRef =
                        redeemProduct['productRef'] as DocumentReference;
                    var pointsRequired = redeemProduct['pointsRequired'] as int;

                    return FutureBuilder(
                        future: productRef.get(),
                        builder: (context, snapshots) {
                          if (snapshots.connectionState ==
                              ConnectionState.waiting) {
                            return ShimerProductCard();
                          } else if (snapshots.hasError) {
                            return const Center(
                                child: Text("Error loading product"));
                          } else if (!snapshots.hasData ||
                              !snapshots.data!.exists) {
                            return const Center(
                                child: Text("Product not found"));
                          }

                          var productData =
                              snapshots.data!.data() as Map<String, dynamic>;
                          var product = Product.fromMap(
                              productData, snapshots.data!.id, productRef);

                          return ProductCard(
                            item: product,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    db: widget.db,
                                    product_id: product.id,
                                    points: pointsRequired,
                                  ),
                                ),
                              );
                            },
                            pointsRequired: pointsRequired,
                          );
                        });
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ShimerProductCard extends StatelessWidget {
  const ShimerProductCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0.8,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 165,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      )),
                ),
              ),
              // Placeholder for text
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 100,
                        height: 22,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 50,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
