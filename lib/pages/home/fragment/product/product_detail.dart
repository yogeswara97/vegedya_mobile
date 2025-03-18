import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:vegedya_firebase/Model/Product.dart';
import 'package:vegedya_firebase/pages/auth/login_page.dart';
import 'package:vegedya_firebase/pages/point/waiting_point.dart';
import 'package:vegedya_firebase/services/session.dart';
import 'package:vegedya_firebase/widgets/refresh_indicator_widget.dart';

class ProductPage extends StatefulWidget {
  final String product_id;
  final FirebaseFirestore db;
  int? points;
  ProductPage(
      {super.key, required this.product_id, required this.db, this.points});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? customerId;
  int quantity = 1;
  bool isLoading = true;
  List<String> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _loadCustomerId();
  }

  Future<void> _loadCustomerId() async {
    Session session = Session();
    customerId = await session.getCustomerId();
    await _loadFavorites();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadFavorites() async {
    final favoritesSnapshot = await widget.db
        .collection('favorites')
        .doc(customerId)
        .collection('items')
        .get();

    setState(() {
      favoriteProducts = favoritesSnapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: RefreshIndicatorWidget(
        onRefresh: _refreshData,
        child: StreamBuilder<DocumentSnapshot>(
          stream: widget.db
              .collection('products')
              .doc(widget.product_id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimmerEffect();
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text("Product not found"));
            }

            var product = Product.fromMap(
              snapshot.data!.data() as Map<String, dynamic>,
              snapshot.data!.id,
              snapshot.data!.reference,
            );

            return ProductDetail(product, context, snapshot);
            
          },
        ),
      ),
    );
  }

  Stack ProductDetail(Product product, BuildContext context,
      AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              toolbarHeight: 90,
              pinned: true,
              backgroundColor: Color.fromARGB(255, 111, 78, 55),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null)
                      return child; // Gambar sudah dimuat

                    // Tampilkan shimmer jika gambar masih dimuat
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 160,
                      color: Colors.red, // Placeholder color on error
                      child: Center(child: Text('Image Error')),
                    );
                  },
                ),
              ),
              leading: Container(
                margin: EdgeInsets.only(
                  left: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Color.fromARGB(255, 111, 78, 55)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(
                    right: 10,
                  ), // Posisikan love icon di pojok kanan
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function()) setState) {
                      bool isFavorite = favoriteProducts.contains(product.id);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.brown,
                          size: 27,
                        ),
                        onPressed: () {
                          if (isFavorite) {
                            _removeFromFavorites(product.id, setState);
                          } else {
                            if (customerId == null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            } else {
                              _addToFavorites(product.id, product.name,
                                  product.price, product.image, setState);
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(0.0),
                child: Container(
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    (widget.points == null)
                        ? Text(
                            "\$${product.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.red,
                            ),
                          )
                        : Text(
                            "${widget.points} Points",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 111, 78, 55),
                            ),
                          ),
                    SizedBox(height: 16),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      product.description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
              ),
            )
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildQtyButton(),
                Expanded(
                  child: Center(
                      child: Container(
                          padding: EdgeInsets.all(8),
                          width: double.infinity,
                          child: (product.inStock == false ||
                                  product.inActive == false)
                              ? ElevatedButton(
                                  onPressed: null,
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      EdgeInsets.symmetric(vertical: 15.0),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.grey, // Disabled color
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : (widget.points == null)
                                  ? ElevatedButton(
                                      onPressed: () {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          _showErrorDialog(
                                              context,
                                              "Please wait",
                                              "Data is still loading.");
                                        } else {
                                          _addToCart(product);
                                        }
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                            EdgeInsetsGeometry>(
                                          EdgeInsets.symmetric(vertical: 15.0),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 111, 78,
                                              55), // Enabled color
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Add to Cart',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          _showErrorDialog(
                                              context,
                                              "Please wait",
                                              "Data is still loading.");
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WaitingPoint(
                                                        db: widget.db,
                                                        customerId: customerId,
                                                      )));
                                        }
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                            EdgeInsetsGeometry>(
                                          EdgeInsets.symmetric(vertical: 15.0),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 111, 78,
                                              55), // Enabled color
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Swipe your points',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ))),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget Shimmer Effect
  Widget ShimmerEffect() {
    return Stack(
      children: [
        ListView(
          children: [
            // Shimmer pada gambar
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 300,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shimmer pada nama produk
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 200,
                      height: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Shimmer pada harga produk
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 100,
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Shimmer pada deskripsi
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Shimmer untuk Bottom Navigation Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQtyButton() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (quantity > 1) {
                    quantity--;
                  }
                });
              },
              icon: Icon(
                Icons.remove_circle_outline,
                size: 40,
                color: Color.fromARGB(255, 111, 78, 55),
              ),
            ),
            Container(
              width: 35,
              child: Center(
                child: Text(
                  "$quantity",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  quantity++;
                });
              },
              icon: Icon(
                Icons.add_circle_outlined,
                size: 40,
                color: Color.fromARGB(255, 111, 78, 55),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addToCart(Product product) async {
    if (customerId != null) {
      final cartRef = widget.db
          .collection('carts')
          .doc(customerId)
          .collection('items')
          .doc(product.id);

      final cartItemSnapshot = await cartRef.get();
      if (cartItemSnapshot.exists) {
        _showErrorDialog(context, "Can't add this Product",
            "This product is already in your cart");
      } else {
        cartRef.set({
          'productId': product.id,
          'name': product.name,
          'price': product.price,
          'image': product.image,
          'created_at': FieldValue.serverTimestamp(),
          'quantity': quantity,
          'point': product.point * quantity
        });
        Navigator.pop(context);
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _addToFavorites(String productId, String productName,
      double productPrice, String productImage, StateSetter setState) async {
    final favoriteRef = widget.db
        .collection('favorites')
        .doc(customerId)
        .collection('items')
        .doc(productId);

    await favoriteRef.set({
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productImage': productImage,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      favoriteProducts.add(productId);
    });

    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        message: "Product added to favorite",
      ),
    );
  }

  void _removeFromFavorites(String productId, StateSetter setState) async {
    final favoriteRef = widget.db
        .collection('favorites')
        .doc(customerId)
        .collection('items')
        .doc(productId);

    await favoriteRef.delete();

    setState(() {
      favoriteProducts.remove(productId);
    });

    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.info(
        message: "Product removed to favorite",
      ),
    );
  }
}
