import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegedya_firebase/Model/Product.dart';
import 'package:vegedya_firebase/pages/home/fragment/product/product_detail.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vegedya_firebase/services/session.dart';
import 'package:vegedya_firebase/widgets/no_items_widget.dart';
import 'package:vegedya_firebase/widgets/refresh_indicator_widget.dart';
import 'package:vegedya_firebase/widgets/product_card.dart';
import 'package:vegedya_firebase/widgets/shimmer_product_card_list_widget.dart'; // Import ProductCard

class ProductListPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final FirebaseFirestore db;

  const ProductListPage({
    Key? key,
    required this.db,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
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
        appBar: AppBar(title: Text(widget.categoryName)),
        body: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 5),
          height: double.infinity,
          color: Colors.white,
          child: RefreshIndicatorWidget(
            onRefresh: _refreshData,
            child: StreamBuilder(
              stream: widget.db
                  .collection('products')
                  .where('category',
                      isEqualTo: widget.db
                          .collection('categories')
                          .doc(widget.categoryId))
                  .where('inActive', isEqualTo: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return ShimmerProductCardListWidget(itemCount: 10,);
                } else if (snapshots.hasError) {
                  return const Center(
                    child: Text("ERROR"),
                  );
                } else if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
                  return Center(
                    child: NoItemsWidget(text: "No Products Found"),
                  );
                }

                var _data = snapshots.data!.docs
                    .map((doc) => Product.fromMap(
                        doc.data() as Map<String, dynamic>,
                        doc.id,
                        doc.reference))
                    .toList();

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
                    var item = _data[index];

                    return ProductCard(
                      item: item,
                      onTap: () {
                        
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                db: widget.db,
                                product_id: item.id,
                              ),
                            ),
                          );
                        
                      },
                    );
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

