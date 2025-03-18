import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:vegedya_firebase/Model/Favorite.dart';
import 'package:vegedya_firebase/Model/Product.dart';
import 'package:vegedya_firebase/pages/auth/login_page.dart';
import 'package:vegedya_firebase/pages/home/fragment/product/product_detail.dart';
import 'package:vegedya_firebase/widgets/loading_widgets.dart';
import 'package:vegedya_firebase/widgets/no_items_widget.dart';
import 'package:vegedya_firebase/widgets/refresh_indicator_widget.dart';
import 'package:vegedya_firebase/widgets/silver_gap_widget.dart';
import 'package:vegedya_firebase/widgets/product_card.dart'; // import ProductCard

class FavoriteFragment extends StatefulWidget {
  final FirebaseFirestore db;
  final String? customerId;

  const FavoriteFragment({super.key, required this.db, this.customerId});

  @override
  State<FavoriteFragment> createState() => _FavoriteFragmentState();
}

class _FavoriteFragmentState extends State<FavoriteFragment> {
  @override
  void initState() {
    super.initState();
    checkCustomerId();
  }

  Future<void> checkCustomerId() async {
    if (widget.customerId == null) {
      await Future.delayed(Duration.zero);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  Future<void> _refreshFavorites() async {
    setState(() {});
  }

  void _removeFromFavorites(String productId) async {
    final favoriteRef = widget.db
        .collection('favorites')
        .doc(widget.customerId)
        .collection('items')
        .doc(productId);

    await favoriteRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customerId == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Favorites"),
      ),
      body: RefreshIndicatorWidget(
        onRefresh: _refreshFavorites,
        child: StreamBuilder<QuerySnapshot>(
              stream: widget.db
                  .collection('favorites')
                  .doc(widget.customerId)
                  .collection('items')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: MainLoading(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return NoItemsWidget(
                    text: "No favorites found",
                  );
                }
            
                var _data = snapshot.data!.docs
                    .map((doc) => Favorite.fromMap(
                        doc.data() as Map<String, dynamic>,
                        doc.id,
                        doc.reference))
                    .toList();
            
                return ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (BuildContext context, int index) { 
                    var item =_data[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPage(
                              product_id: item.productId,
                              db: widget.db,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:Image.network(
                                  item.productImage,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 90,
                                        height: 90,
                                        color: Colors.grey[300], // Shimmer placeholder color
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 90,
                                      height: 90,
                                      color: Colors.red, // Gambar fallback jika ada error
                                      child: Icon(Icons.error, color: Colors.white),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "\$${item.productPrice.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _removeFromFavorites(item.productId);
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    CustomSnackBar.info(
                                      message:
                                          "Product removed from favorite",
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
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
